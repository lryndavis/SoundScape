
import UIKit
import Firebase
import GeoFire

class SongsSearchViewController: UIViewController {
    
    var songs: [SpotifyTrack] = []
    var session: SPTSession!
    var ref: DatabaseReference?
    var coordinate: CLLocationCoordinate2D?
    let searchController = UISearchController(searchResultsController: nil)
    var searchTimer: Timer?
    //let audioPlayerVC = SpotifyAudioPlayerViewController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerStackView: UIStackView!

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // navigation bar
        self.navigationItem.title = "Add a Song Here"        
        ref = FirebaseService.baseRef.child(FirebaseService.ChildRef.songs.rawValue)

        let userDefaults = UserDefaults.standard
        let sessionObj: Any? = userDefaults.object(forKey: SpotifyAuthManager.kUserDefaultsKey)
        let sessionDataObj = sessionObj as! Data
        self.session = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
        
        // SearchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false

        // TableView
        tableView.tableHeaderView = searchController.searchBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
        //addAudioPlayer()
    }
    
    // prevent search controller warning
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    
    // if the audio player has an active queue, add the audio player vc as a child
    func addAudioPlayer() {
        
//        if let queue = audioPlayerVC.spotifyAudioPlayer.trackQueue {
//            if queue.count > 0 {
//                audioPlayerVC.setCurrentPlayerDisplay()
//                containerStackView.axis = .vertical
//                addChildViewController(audioPlayerVC)
//                
//                audioPlayerVC.didMove(toParentViewController: self)
//                containerStackView.addArrangedSubview(audioPlayerVC.view)
//            }
//        }
    }

    // begin search
    func performSearch() {
        
        if let query = searchController.searchBar.text {
            if !query.isEmpty {
                
                searchSpotify(query: query)
            }
        }
    }
    
    // query spotify for tracks
    func searchSpotify(query: String) {
        
        SPTSearch.perform(withQuery: query, queryType: SPTSearchQueryType.queryTypeTrack, accessToken: session.accessToken) { (error, response) in
            if let error = error {
                print("error while searching spotify: \(error)")
            } else {
                let listpage = response as! SPTListPage
                self.getFullTrackObjects(listPage: listpage)
            }
        }
    }
    
    // spotify query always returns an array of partial tracks 
    // make additional call to get full track objects from partial track URIs
    func getFullTrackObjects(listPage: SPTListPage) {
        
        if listPage.items != nil {
            
            songs.removeAll()
            let tracks = listPage.items as! [SPTPartialTrack]
            let trackURIs = tracks.map{ $0.uri.absoluteURL }
        
            SPTTrack.tracks(withURIs: trackURIs, accessToken: session.accessToken, market: nil) { error, response in
                if let error = error {
                    print("error when getting full tracks: \(error)")
                } else {
                    let spotifyTracks = response as! [SPTTrack]
                    self.updateTableView(spotifyTracks: spotifyTracks)
                }
            }
        }
    }
    
    // update tableview with new tracks
    func updateTableView(spotifyTracks: [SPTTrack]) {
        
        for track in spotifyTracks {
            let songItem = SpotifyTrack(track: track)
            songs.append(songItem)
        }
        tableView.reloadData()
    }
    
    // save selected song to user's current location 
    func saveSongToLocation(song: SpotifyTrack) {
        
        if let ref = self.ref {
            
            let key = ref.childByAutoId().key
            ref.child(key).setValue(song.toAnyObject(key: key))
            
            let geoFire = GeoFire(firebaseRef: FirebaseService.baseRef.child(FirebaseService.ChildRef.songLocations.rawValue))
            
            if let longitude = self.coordinate?.longitude,
                let latitude = self.coordinate?.latitude {
                
                geoFire?.setLocation(CLLocation(latitude: latitude, longitude: longitude), forKey: key)
            }
        }
    }
    
}

// MARK: - UITableViewDelegate and UITableViewDataSource methods 
extension SongsSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        let songItem = songs[indexPath.row]
        
        cell.songLabel.text = songItem.name
        cell.artistLabel.text = songItem.albumArtistDisplay
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let songItem = songs[indexPath.row]
        
        let alert = UIAlertController(title: nil,
                                      message: "Do you want to add \(songItem.name) to this location?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            self.saveSongToLocation(song: songItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate methods
extension SongsSearchViewController: UISearchBarDelegate {

    func didChangeSearchText(_ query: String) {
        
        if query.characters.count > 2 {
            
            searchTimer?.invalidate()
            searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(SongsSearchViewController.performSearch), userInfo: nil, repeats: false)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension SongsSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        didChangeSearchText(searchController.searchBar.text!)
    }
}

