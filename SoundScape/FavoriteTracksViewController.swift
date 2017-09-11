
import UIKit

class FavoriteTracksViewController: UIViewController {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteTracks: [SpotifyTrackExtended]?
    let spotifyManager = SpotifyManager.sharedInstance
    let dataSource = FavoriteTracksDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar 
        self.navigationItem.title = "Favorite Tracks"
        
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
                        strongSelf.favoriteTracks = favoriteTracks
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
        
        if let favoriteTracks = favoriteTracks {
            return favoriteTracks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteSongCell", for: indexPath) as! SongTableViewCell
        let trackItem = favoriteTracks?[indexPath.row]
        
        cell.songLabel.text = trackItem?.track.name
        cell.artistLabel.text = trackItem?.albumArtistDisplayStr
        cell.selectionStyle = .none
        
        if let imageURL = trackItem?.albumCoverImageURLSmall {
            ImageDataRequest.getAlbumCoverImage(imageUrl: imageURL, completion: { (image) in
                cell.albumImage.image = image
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
