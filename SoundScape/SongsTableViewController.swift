
import UIKit
import Firebase
import CoreLocation
import GeoFire

class SongsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var songItems: [Song] = []
    var ref: DatabaseReference?
    var locationManager: CLLocationManager!
    var localSongIds: [String] = []

    override func viewDidLoad() {

        super.viewDidLoad()
        
        ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        determineCurrentUserLocation()
    }
    

    func loadLocalSongIds() {
        
        if let location = self.locationManager.location {
            self.queryLocalSongs(location: location,
                          completionHandler: {
                            (keys) in
                            if let keys = keys {
                                self.localSongIds = keys
                                self.updateSongsArray()
                            }
                            else {
                                //no local songs
                                print("No songs in vicinity")
                            }
                            
            })
        }
    }
    
    func updateSongsArray() {
        
        print(localSongIds.count)
        
        self.returnSongsFromId(songsByKey: self.localSongIds) {
            newSongs in
            
            self.songItems.removeAll()
            self.songItems.append(contentsOf: newSongs)
            self.tableView.reloadData()
        }
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
    
    func returnSongsFromId(songsByKey: [String], completionHandler: @escaping (_ newSongs: [Song]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var newSongs: [Song] = []
        
        for songId in songsByKey {
            
            dispatchGroup.enter()
            
            self.ref?.child(songId).observeSingleEvent(of: .value, with: { snapshot in
                
                if let _ = snapshot.value as? [String: Any] {
                    newSongs.append(Song(snapshot: snapshot))
                    
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completionHandler(newSongs)
        }
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
        
        let userLocation: CLLocation = locations[0] as CLLocation
        
        print("LAT:\(userLocation.coordinate.latitude)")
        print("LONG:\(userLocation.coordinate.longitude)")
        
        loadLocalSongIds()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        let songItem = songItems[indexPath.row]
        
        cell.textLabel?.text = songItem.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            songItems.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var songItem = songItems[indexPath.row]

        tableView.reloadData()
    }
    
    // MARK: Add song
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SongsSearchViewController") as! SongsSearchViewController
        
        vc.userLocation = self.locationManager.location
        
        navigationController?.pushViewController(vc, animated: true)
        
//        let alert = UIAlertController(title: "New Song",
//                                      message: "Add a song",
//                                      preferredStyle: .alert)
//        
//        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
//
//        guard let textField = alert.textFields?.first,
//              let text = textField.text else { return }
//
//        if let ref = self.ref {
//            
//            let key = ref.childByAutoId().key
//            let songItem = Song(
//                            title: text,
//                            id: key)
//            
//            ref.child(key).setValue(songItem.toAnyObject())
//
//            let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
//            
//            if let longitude = self.locationManager.location?.coordinate.longitude,
//                let latitude = self.locationManager.location?.coordinate.latitude {
//                
//                geoFire?.setLocation(CLLocation(latitude: latitude, longitude: longitude), forKey: key)
//            }
//            
//            self.songItems.append(songItem)
//            self.tableView.reloadData()
//            
//            }
//        }
//
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default)
//        
//        alert.addTextField()
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert, animated: true, completion: nil)
    }
}




