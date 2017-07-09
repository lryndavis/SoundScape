
import UIKit
import Firebase
import CoreLocation
import GeoFire


class NearbySongsViewController: UIViewController, CLLocationManagerDelegate, SpotifyAudioPlayable {
    
    var spotifyTracks = [SpotifyTrackExtended]()
    var spotifyTrackAnnotationItems = [SpotifyTrackAnnotation]()
    let spotifyManager = SpotifyManager.sharedInstance
    var locationManager: CLLocationManager!
    let dataSource = NearbySongsDataSource()
    
    let noResultsLabel = UILabel()
    let tableView = UITableView()
    let mapView = MKMapView()

    @IBOutlet weak var containerStackView: UIStackView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
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
        determineCurrentUserLocation()
    
        // build views
        buildView()
        
        //map gesture recognizer
       let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        longPressGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func buildView() {
        
        // add mapview
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        containerStackView.addArrangedSubview(mapView)

        // add tableview
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        containerStackView.addArrangedSubview(tableView)
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
        
        loadTracksInVicinity()
    }
    
    internal func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    // get local tracks from query and update
    func loadTracksInVicinity() {

        if let location = self.locationManager.location {
            dataSource.loadNearbyTrackData(location: location, completion: {
                [weak self] (success) in
                if success {
                    if let strongSelf = self,
                        let trackAnnotations = strongSelf.dataSource.spotifyTrackAnnotations,
                        let tracks = strongSelf.dataSource.spotifyTracksExtended {

                        strongSelf.updateTracksList(nearbyTracks: tracks)
                        strongSelf.updateTrackAnnotations(nearbyAnnotations: trackAnnotations)
                    }
                }
            })
        }
    }
    
    // add annotations to map view for relevant songs
    func updateTrackAnnotations(nearbyAnnotations: [SpotifyTrackAnnotation]) {
        
        if !nearbyAnnotations.isEmpty {
            let existingAnnotationIds = spotifyTrackAnnotationItems.flatMap{ $0.spotifyTrackExtended.soundScapeId }
            let newAnnotations = nearbyAnnotations.filter { (nearbyAnnotation) -> Bool in
                if let id = nearbyAnnotation.spotifyTrackExtended.soundScapeId {
                    if !existingAnnotationIds.contains(id) {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                    
                }
            }
            
            if !newAnnotations.isEmpty {
                spotifyTrackAnnotationItems = nearbyAnnotations
                mapView.addAnnotations(newAnnotations)
            }
        }
    }
    
    // update nearby songs tableview
    func updateTracksList(nearbyTracks: [SpotifyTrackExtended]) {
        
        if !nearbyTracks.isEmpty {
            
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView = nil
            
            let existingTrackIds = spotifyTracks.flatMap{ $0.soundScapeId }
            //let newTracks = nearbyTracks.filter { !existingTrackIds.contains( $0.soundScapeId) }
            
            let newTracks = nearbyTracks.filter { (nearbyTrack) -> Bool in
                if let id = nearbyTrack.soundScapeId {
                    if !existingTrackIds.contains(id) {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                    
                }
            }
            
            if !newTracks.isEmpty {
                
                spotifyTracks.removeAll()
                spotifyTracks = nearbyTracks
                
                tableView.reloadData()
            }
        } else {
            spotifyTracks.removeAll()
            tableView.reloadData()
            showNoResultsView()
        }
    }
    
    func addSongButtonTapped() {
        
        if let coordinate = self.locationManager.location?.coordinate {
            segueToSongSearchVC(coordinate: coordinate)
        }
    }
    
    func segueToSongSearchVC(coordinate: CLLocationCoordinate2D) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SongsSearchViewController") as! SongsSearchViewController
        
        vc.coordinate = coordinate
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSource methods
extension NearbySongsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return spotifyTracks.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        let trackItem = spotifyTracks[indexPath.row]
        
        cell.songLabel.text = trackItem.track.name
        cell.artistLabel.text = trackItem.albumArtistDisplayStr
        cell.selectionStyle = .none
        
        if let currentTrackId = spotifyManager.currentTrack?.soundScapeId {
            if trackItem.soundScapeId == currentTrackId {
                cell.songLabel.textColor = UIColor.blue
            } else {
                cell.songLabel.textColor = UIColor.black
            }
        }
        
        if let imageURL = trackItem.albumCoverImageURLSmall {
            ImageDataRequest.getAlbumCoverImage(imageUrl: imageURL, completion: { (image) in
                cell.albumImage.image = image
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trackItem = spotifyTracks[indexPath.row]
        startNewQueueFromSelection(sptTrack: trackItem)
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
            (annotationView as! SongDetailAnnotationView).delegate = self

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

// MARK: - UIGestureRecognizerDelegate methods
extension NearbySongsViewController: UIGestureRecognizerDelegate {
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        if gestureReconizer.state == UIGestureRecognizerState.ended {
            
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            
            showNewSongAdditionAlert(coordinate: coordinate)
            
        } else if gestureReconizer.state == UIGestureRecognizerState.began {
            print("map press gesture detected")
        }
    }
    
    func showNewSongAdditionAlert(coordinate: CLLocationCoordinate2D) {
        
        let alert = UIAlertController(title: nil, message: "Would you like to add a song here?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes!", style: .default) { _ in
            
            self.segueToSongSearchVC(coordinate: coordinate)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - SongDetailMapViewDelegate methods 
extension NearbySongsViewController: SongDetailMapViewDelegate {
    
    func setAnnotationAudioPlayer(track: SpotifyTrackExtended) {
        
        startNewQueueFromSelection(sptTrack: track)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showModalTriggered"), object: nil)
    }
}





