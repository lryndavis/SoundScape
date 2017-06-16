
import UIKit
import Firebase
import CoreLocation
import GeoFire

class NearbySongsViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, SpotifyAudioPlayable {
    
    var songItems = [SpotifyTrack]()
    var songAnnotationItems = [SpotifyTrackAnnotation]()
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    var currentQueue = [SpotifyTrack]()
    var ref: DatabaseReference?
    var locationManager: CLLocationManager!
    var localSongIds: [String] = []
    
    let noResultsLabel = UILabel()
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    let audioPlayerVC = SpotifyAudioPlayerViewController()
    let tableView = UITableView()
    let mapView = MKMapView()
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)
        
        // navigation bar
        self.navigationItem.title = "Songs near You"
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        addButton.setBackgroundImage(UIImage(named: "plus.png"), for: .normal)
        addButton.addTarget(self, action: #selector(addSongButtonTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        // mapview
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
    
        // build views
        determineCurrentUserLocation()
        buildView()
        addSpotifyMusicPlayerVC()
        
        //map gesture recognizer
       let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        longPressGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        print(coordinate)
    }

    
    func buildView() {
        
        // add mapview
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        containerStackView.addArrangedSubview(mapView)
        
//        let closeMapButton = UIButton()
//        closeMapButton.frame = CGRect(x: 10, y: 10, width: 15, height: 15)
//        closeMapButton.addTarget(self, action: #selector(toggleMap), for: .touchUpInside)
//        closeMapButton.imageView?.contentMode = .scaleAspectFit
//        closeMapButton.tintColor = .blue
//        let closeImage = UIImage(named: "close.png")
//        let tintedCloseImage = closeImage?.withRenderingMode(.alwaysTemplate)
//        closeMapButton.setImage(tintedCloseImage, for: .normal)
//        mapView.addSubview(closeMapButton)

        // add tableview
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        containerStackView.addArrangedSubview(tableView)
    }
    
    func addSpotifyMusicPlayerVC() {
        
        containerStackView.axis = .vertical
        addChildViewController(audioPlayerVC)
        
        audioPlayerVC.didMove(toParentViewController: self)
        containerStackView.addArrangedSubview(audioPlayerVC.view)
        
        if !audioPlayerVC.spotifyAudioPlayer.isPlaying {
            audioPlayerVC.view.isHidden = true
        }
    }
    
    func showMusicPlayer() {

        if audioPlayerVC.view.isHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.audioPlayerVC.view.isHidden = false
            }
        }
    }
    
    func toggleMap() {
        
        UIView.animate(withDuration: 0.3){
            self.mapView.isHidden = !self.mapView.isHidden
        }
    }
    
    func showNoResultsView() {
        
        noResultsLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        noResultsLabel.text = "No nearby songs"
        noResultsLabel.textColor = UIColor.black
        noResultsLabel.textAlignment = .center
        self.tableView.backgroundView = noResultsLabel
        self.tableView.separatorStyle = .none
    }
    
    func determineCurrentUserLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        loadLocalSongIds()
    }
    
    internal func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    // get songs from query and update 
    func loadLocalSongIds() {
        
        if let location = self.locationManager.location {
            self.queryLocalSongs(location: location,
                                 completionHandler: {
                                    (keys) in
                                    if let keys = keys {
                                        self.localSongIds = keys
                                        self.updateSongItems()
                                    }
            })
        }
    }

    // query geofire to find all songs in radius
    func queryLocalSongs(location: CLLocation, completionHandler: @escaping (_ songData: [String]?) -> Void) {
        
        var songData: [String] = []
        let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
        
        if let geoFire = geoFire {
            
            let circleQuery = geoFire.query(at: location, withRadius: 25.0)
            
            _ = circleQuery?.observe(.keyEntered, with: { (key, location) in
                
                if let key = key {
                    songData.insert(key, at: 0)
                }
            })
            
            circleQuery?.observeReady({
                completionHandler(songData)
            })
        }
    }
    
    // creat new track and annotation objects from returned song objects
    func returnSongsFromId(songsByKey: [String], completionHandler: @escaping (_ nearbySongs: [SpotifyTrack], _ nearbyAnnotations: [SpotifyTrackAnnotation]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var nearbySongs: [SpotifyTrack] = []
        var nearbyAnnotations: [SpotifyTrackAnnotation] = []
        
        for songId in songsByKey {
            
            dispatchGroup.enter()
            
            self.ref?.child(songId).observeSingleEvent(of: .value, with: { snapshot in
                
                if let _ = snapshot.value as? [String: Any] {
                    
                    let newSong = SpotifyTrack(snapshot: snapshot)
                    nearbySongs.append(newSong)
                    
                    let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
                    
                    geoFire?.getLocationForKey(songId, withCallback: { (location, error) in
                        if let location = location {
                            
                            let newAnnotation = SpotifyTrackAnnotation(coordinate: location.coordinate, spotifyTrack: newSong)
                            nearbyAnnotations.append(newAnnotation)
                        } else {
                            print("\(String(describing: error))")
                        }
                        
                        dispatchGroup.leave()
                    })
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completionHandler(nearbySongs, nearbyAnnotations)
        }
    }
    
    // once songs are returned, call methods for updating UI
    func updateSongItems() {
        
        self.returnSongsFromId(songsByKey: self.localSongIds) {
            nearbySongs, nearbyAnnotations in
            
            if !self.localSongIds.isEmpty {
                
                self.tableView.separatorStyle = .singleLine
                self.tableView.backgroundView = nil
                
                self.updateSongsList(nearbySongs: nearbySongs)
                self.addTrackAnnotations(nearbyAnnotations: nearbyAnnotations)
                
            } else {
                
                self.songItems.removeAll()
                self.tableView.reloadData()
                self.showNoResultsView()
            }
        }
    }
    
    // add annotations to map view for relevant songs
    func addTrackAnnotations(nearbyAnnotations: [SpotifyTrackAnnotation]) {
        
        if !songAnnotationItems.isEmpty {
            let existingAnnotationIds = songAnnotationItems.map{ $0.spotifyTrack.id }
            let newAnnotations = nearbyAnnotations.filter { !existingAnnotationIds.contains($0.spotifyTrack.id) }
            
            songAnnotationItems.append(contentsOf: newAnnotations)
            mapView.addAnnotations(newAnnotations)
        } else {
            songAnnotationItems.append(contentsOf: nearbyAnnotations)
            mapView.addAnnotations(self.songAnnotationItems)
        }
    }
    
    // update nearby songs tableview
    func updateSongsList(nearbySongs: [SpotifyTrack]) {
        
        songItems.removeAll()
        songItems.append(contentsOf: nearbySongs)
        
        tableView.reloadData()
    }

    func addSongButtonTapped() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SongsSearchViewController") as! SongsSearchViewController
        
        vc.userLocation = self.locationManager.location
        
        navigationController?.pushViewController(vc, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
        
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
    }
}

// MARK: UITableViewDelegate + UITableViewDataSource methods
extension NearbySongsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songItems.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        let songItem = songItems[indexPath.row]
        
        cell.songLabel.text = songItem.name
        cell.artistLabel.text = songItem.albumArtistDisplay
        cell.selectionStyle = .none
        
        let currentTrackId = spotifyAudioPlayer.trackQueue?[safe: spotifyAudioPlayer.trackIndex]?.spotifyId
        
        if songItem.spotifyId == currentTrackId {
            cell.songLabel.textColor = UIColor.blue
        } else {
            cell.songLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let songItem = songItems[indexPath.row]
        currentQueue = songItems
        currentQueue.insert(songItem, at: 0)

        beginNewQueueWithSelection(trackQueue: currentQueue)
        audioPlayerVC.setCurrentPlayerDisplay()
        showMusicPlayer()
    }
}

// MARK: - MKMapViewDelegate methods
extension NearbySongsViewController: MKMapViewDelegate {
   
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let userLocation = userLocation.location {

            let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5000, 5000)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "SongAnnotation")
        
        if annotationView == nil {
            annotationView = SongDetailAnnotationView(annotation: annotation, reuseIdentifier: "SongAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let span = mapView.region.span
        
        if let annotationPin = view.annotation {
            let region = MKCoordinateRegion(center: annotationPin.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}

//extension NearbySongsViewController: SpotifyAudioPlayerDelegate {
//    
//    func togglePlay() {
//        
//        if spotifyAudioPlayer.isPlaying {
//            spotifyAudioPlayer.player?.setIsPlaying(false, callback: nil)
//            spotifyAudioPlayer.isPlaying = false
//            pausePlayButton.setButtonPlay()
//        } else {
//            spotifyAudioPlayer.player?.setIsPlaying(true, callback: nil)
//            spotifyAudioPlayer.isPlaying = true
//            pausePlayButton.setButtonPause()
//        }
//    }
//}
