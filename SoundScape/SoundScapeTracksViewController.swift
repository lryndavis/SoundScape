
import UIKit

class SoundScapeTracksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerStackView: UIStackView!
    
    var spotifyTracks: [SpotifyTrackExtended] = []
    let dataSource = SoundscapeTracksDataSource()
    let spotifyManager = SpotifyManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: "SoundscapeTrackCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let currentUsername = spotifyManager.currentUser?.canonicalUserName {
            dataSource.loadSoundscapeTracksData(userName: currentUsername, completion: {
                [weak self] success in
                if success {
                    if let strongSelf = self,
                        let tracksPlacedByCurrentUser = strongSelf.dataSource.soundscapeTracks {
                        strongSelf.spotifyTracks = tracksPlacedByCurrentUser
                        //tableView.reloadData
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

extension SoundScapeTracksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotifyTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundscapeTrackCell", for: indexPath) as! SongTableViewCell
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
}
