
import UIKit
import Firebase
import GeoFire


class SongsSearchViewController: UIViewController, SpotifyAudioPlayable {
    
    var spotifyTracks: [SpotifyTrackExtended] = []
    let spotifyManager = SpotifyManager.sharedInstance
    var coordinate: CLLocationCoordinate2D?
    let searchController = UISearchController(searchResultsController: nil)
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
                    [weak self] (spotifyTracks) in
                    if let strongSelf = self {
                        strongSelf.spotifyTracks.removeAll()
                        strongSelf.spotifyTracks.append(contentsOf: spotifyTracks)
                        strongSelf.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func presentSaveSongAlert(spotifyTrack: SpotifyTrackExtended) {

        let alert = UIAlertController(title: nil,
                                      message: "Do you want to add \(spotifyTrack.track.name) to this location?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let coordinates = self.coordinate {
                self.dataSource.saveSongToLocation(spotifyTrack: spotifyTrack, coordinate: coordinates)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource methods 
extension SongsSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotifyTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        let trackItem = spotifyTracks[indexPath.row]
        
        cell.artistLabel.text = trackItem.albumArtistDisplayStr
        cell.songLabel.text = trackItem.track.name
        cell.selectionStyle = .none
        
        let url = trackItem.albumCoverImageURLSmall
        if let url = url {
            ImageDataRequest.getAlbumCoverImage(imageUrl: url, completion: { (image) in
                cell.albumImage.image = image
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("cell tapped")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let trackItem = spotifyTracks[editActionsForRowAt.row]
        
        let playAction = UITableViewRowAction(style: .normal, title: "") { action, index in
            self.startNewQueueFromSelection(sptTrack: trackItem, isSampleSelection: true)
        }
        
        playAction.backgroundColor = .black
        playAction.title = ">>"
        
        let addAction = UITableViewRowAction(style: .normal, title: "") { action, index in
            self.presentSaveSongAlert(spotifyTrack: trackItem)
        }
        
        addAction.backgroundColor = .blue
        addAction.title = "+"
        
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

            performSearch()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension SongsSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        didChangeSearchText(searchController.searchBar.text!)
    }
}

