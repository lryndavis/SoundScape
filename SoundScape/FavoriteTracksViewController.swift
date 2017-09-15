
import UIKit

class FavoriteTracksViewController: UIViewController, SpotifyAudioPlayable {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var spotifyTracks: [SpotifyTrackExtended] = []
    let spotifyManager = SpotifyManager.sharedInstance
    let dataSource = FavoriteTracksDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "FavoriteSongCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let favoriteTracks = spotifyManager.currentUser?.favoritedSongs {
            dataSource.loadFavoriteTracksData(trackKeys: favoriteTracks, completion: {
                [weak self] success in
                if success {
                    if let strongSelf = self,
                        let favoriteTracks = strongSelf.dataSource.favoriteTracks {
                        strongSelf.spotifyTracks = favoriteTracks
                        strongSelf.tableView.reloadData()
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FavoriteTracksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotifyTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteSongCell", for: indexPath) as! SongTableViewCell
        let trackItem = spotifyTracks[indexPath.row]
        
        cell.songLabel.text = trackItem.track.name
        cell.artistLabel.text = trackItem.albumArtistDisplayStr
        cell.selectionStyle = .none
        
        if let imageURL = trackItem.albumCoverImageURLSmall {
            ImageDataRequest.getImageData(imageUrl: imageURL, completion: { (image) in
                cell.albumImage.image = image
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let trackItem = spotifyTracks[editActionsForRowAt.row]
        
        let removeAction = UITableViewRowAction(style: .normal, title: "") { action, index in
            if let _ = self.spotifyManager.currentUser,
                let id = trackItem.soundScapeId {
                self.spotifyManager.currentUser?.removeFavoriteSong(songId: id)
                
                self.spotifyTracks = self.spotifyTracks.filter{ $0.soundScapeId != id }
                tableView.reloadData()
            }
        }
        
        removeAction.backgroundColor = .black
        removeAction.title = "X"
        
        return [removeAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trackItem = spotifyTracks[indexPath.row]
        startNewQueueFromSelection(sptTrack: trackItem, isSampleSelection: true)
    }
    
}
