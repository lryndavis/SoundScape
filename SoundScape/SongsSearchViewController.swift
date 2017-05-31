

import UIKit
import Firebase
import GeoFire

class SongsSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var songs: [SpotifyTrackSimplified] = []
    var session: SPTSession!
    var ref: DatabaseReference?
    var userLocation: CLLocation?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)

        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: "SpotifySession")
        let sessionDataObj = sessionObj as! Data
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
    }
    
    func searchSpotify(query: String) {
        
        SPTSearch.perform(withQuery: query, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: session.accessToken) { (error, response) in
            if error != nil {
                print(error!)
            } else {
                let listpage = response as! SPTListPage
                self.updateTableView(listPage: listpage)
            }
        }
    }
}


extension SongsSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let query = searchBar.text
        searchSpotify(query: query!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let query = searchBar.text
        
        searchSpotify(query: query!)
    }
}


extension SongsSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func updateTableView(listPage: SPTListPage) {
        
        if listPage.items != nil {
            for item in listPage.items {
                let songItem = SpotifyTrackSimplified(track: item as! SPTPartialTrack)
                dump(songItem)
                songs.append(songItem)
                print(songs.count)
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songs.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongSearchCell", for: indexPath)
        let songItem = songs[indexPath.row]
       
        cell.textLabel?.text = songItem.name
        cell.detailTextLabel?.text = songItem.artist

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let songItem = songs[indexPath.row]
        
        let alert = UIAlertController(title: nil,
                                      message: "Do you want to add \(songItem.name) to this location?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let ref = self.ref {
                
                let key = ref.childByAutoId().key
                ref.child(key).setValue(songItem.toAnyObject())
                
                let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
                
                if let longitude = self.userLocation?.coordinate.longitude,
                   let latitude = self.userLocation?.coordinate.latitude {
                
                    geoFire?.setLocation(CLLocation(latitude: latitude, longitude: longitude), forKey: key)
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)

            alert.addAction(saveAction)
            alert.addAction(cancelAction)
                    
            present(alert, animated: true, completion: nil)
        }
    }
