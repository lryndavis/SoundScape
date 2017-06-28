
import UIKit
import Firebase
import GeoFire


class SongsSearchViewController: UIViewController {
    
    var songs: [SpotifyTrack] = []
    var coordinate: CLLocationCoordinate2D?
    let searchController = UISearchController(searchResultsController: nil)
    var searchTimer: Timer?
    let dataSource = SongsSearchDataSource()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerStackView: UIStackView!

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // navigation bar
        self.navigationItem.title = "Add a Song Here"

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
    }
    
    // prevent search controller warning
    deinit {
        self.searchController.view.removeFromSuperview()
    }

    // begin search
    func performSearch() {
        
        if let query = searchController.searchBar.text {
            if !query.isEmpty {
                
                dataSource.searchSpotify(query: query, completion: {
                    (spotifyTracks) in
                    self.songs.removeAll()
                    self.songs.append(contentsOf: spotifyTracks)
                    self.tableView.reloadData()
                })
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
        
        ImageDataRequest.getAlbumCoverImage(imageUrl: songItem.smallestAlbumCoverURL!, completion: { (image) in
            cell.albumImage.image = image
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let songItem = songs[indexPath.row]
        
        let alert = UIAlertController(title: nil,
                                      message: "Do you want to add \(songItem.name) to this location?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let coordinates = self.coordinate {
                self.dataSource.saveSongToLocation(song: songItem, coordinate: coordinates)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let playAction = UITableViewRowAction(style: .normal, title: "") { action, index in
            print("more button tapped")
        }
        playAction.backgroundColor = .lightGray
        
        let addAction = UITableViewRowAction(style: .normal, title: "") { action, index in
            print("share button tapped")
        }
        addAction.backgroundColor = .blue
        
        return [addAction, playAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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

