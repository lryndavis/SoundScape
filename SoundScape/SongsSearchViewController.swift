
import UIKit
import Firebase
import GeoFire

class SongsSearchViewController: UITableViewController {
    
    var songs: [SpotifyTrackPartial] = []
    var session: SPTSession!
    var ref: DatabaseReference?
    var userLocation: CLLocation?
    let searchController = UISearchController(searchResultsController: nil)
    var searchTimer: Timer?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.navigationItem.title = "Add a song to this location"
        ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)

        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as! Data
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        
        // Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false

        tableView.tableHeaderView = searchController.searchBar
    }
    
    deinit {
        
        self.searchController.view.removeFromSuperview()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongSearchCell", for: indexPath)
        let songItem = songs[indexPath.row]
        
        cell.textLabel?.text = songItem.name
        cell.detailTextLabel?.text = songItem.artist
        
        return cell
    }
    
    //TODO: move logic of tableview func
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    func updateTableView(listPage: SPTListPage) {
        
        if listPage.items != nil {
            
            songs.removeAll()
            
            for item in listPage.items {
                let songItem = SpotifyTrackPartial(track: item as! SPTPartialTrack)
                songs.append(songItem)
            }
            tableView.reloadData()
        } 
    }
    
    func searchSpotify(query: String) {
        
        SPTSearch.perform(withQuery: query, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: session.accessToken) { (error, response) in
            
            if let error = error {
                print("error while searching spotify: \(error)")
            } else {
                let listpage = response as! SPTListPage
                self.updateTableView(listPage: listpage)
            }
        }
    }
    
    func performSearch() {
        
        if let query = searchController.searchBar.text {
            if !query.isEmpty {
                
                searchSpotify(query: query)
            }
        }
    }
}

extension SongsSearchViewController: UISearchBarDelegate {

    func didChangeSearchText(_ query: String) {
        
        if query.characters.count > 2 {
            
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(SongsSearchViewController.performSearch), userInfo: nil, repeats: false)
        }
    }
}

extension SongsSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        didChangeSearchText(searchController.searchBar.text!)
    }
}

