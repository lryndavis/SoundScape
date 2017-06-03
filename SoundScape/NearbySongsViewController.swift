
import UIKit
import Firebase
import CoreLocation
import GeoFire

class NearbySongsViewController: UIViewController {
    
    var songItems: [SpotifyTrackPartial] = []
    var ref: DatabaseReference?
    var locationManager: CLLocationManager!
    var localSongIds: [String] = []
    //let audioPlayer = SpotifyAudioPlayer()
    let noResultsLabel = UILabel()
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    let audioPlayerVC = SpotifyAudioPlayerViewController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerStackView: UIStackView!
    //@IBOutlet weak var enlargeModalButton: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)
        
        self.navigationItem.title = "Songs near you"
        
        determineCurrentUserLocation()
        
        addSpotifyMusicPlayerVC()
    }
    
    func addSpotifyMusicPlayerVC() {
        
        containerStackView.axis = .vertical
        addChildViewController(audioPlayerVC)
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(audioPlayerVC.view)
        
        audioPlayerVC.didMove(toParentViewController: self)
        audioPlayerVC.view.anchorSidesTo(view)
        containerStackView.addArrangedSubview(view)
    }
    
    func loadLocalSongIds() {
        
        if let location = self.locationManager.location {
            self.queryLocalSongs(location: location,
                          completionHandler: {
                            (keys) in
                            if let keys = keys {
                                print(keys.count)
                                self.localSongIds = keys
                                self.updateSongItems()
                            }
            })
        }
    }
    
    func updateSongItems() {
        
        self.returnSongsFromId(songsByKey: self.localSongIds) {
            newSongs in
            
            if self.localSongIds.count > 0 {
                
                self.tableView.separatorStyle = .singleLine
                self.tableView.backgroundView = nil
                
                self.songItems.removeAll()
                self.songItems.append(contentsOf: newSongs)
                self.tableView.reloadData()
            } else {
                
                self.songItems.removeAll()
                self.tableView.reloadData()
                self.showNoResultsView()
            }
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
    
    func returnSongsFromId(songsByKey: [String], completionHandler: @escaping (_ newSongs: [SpotifyTrackPartial]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var newSongs: [SpotifyTrackPartial] = []
        
        for songId in songsByKey {
            
            dispatchGroup.enter()
            
            self.ref?.child(songId).observeSingleEvent(of: .value, with: { snapshot in
                
                if let _ = snapshot.value as? [String: Any] {
                    newSongs.append(SpotifyTrackPartial(snapshot: snapshot))
                    
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completionHandler(newSongs)
        }
    }


    @IBAction func addSongButtonTapped(_ sender: Any) {
        
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

extension NearbySongsViewController: CLLocationManagerDelegate {
    
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
        
        let userLocation: CLLocation = locations[0] as CLLocation
        
        print("LAT:\(userLocation.coordinate.latitude)")
        print("LONG:\(userLocation.coordinate.longitude)")
        
        loadLocalSongIds()
    }
}

extension NearbySongsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songItems.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        let songItem = songItems[indexPath.row]
        
        cell.textLabel?.text = songItem.name
        cell.detailTextLabel?.text = songItem.artist
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let songItem = songItems[indexPath.row]

        var nearbySongsQueue = songItems
        nearbySongsQueue.insert(songItem, at: 0)
        
        audioPlayerVC.setQueue(playerQueue: nearbySongsQueue)
    }
}

