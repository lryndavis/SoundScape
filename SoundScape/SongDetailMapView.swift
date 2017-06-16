
import UIKit


class SongDetailMapView: UIView, SpotifyAudioPlayable, SpotifyAudioControllable {
    
    let songNameLabel = UILabel()
    let artistLabel = UILabel()
    let playButton = UIButton()
    let closeButton = UIButton()
    let verticalContainerStackView = UIStackView()
    let horizontalContainerStackView = UIStackView()
    let pausePlayButton = AudioPausePlayButton()

    var spotifyTrack: SpotifyTrack?
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    
    init() {
        super.init(frame: .zero)
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupWithTrack(spotifyTrack: SpotifyTrack) {
        
        self.spotifyTrack = spotifyTrack
        
        songNameLabel.text = spotifyTrack.name
        artistLabel.text = spotifyTrack.artist
    }
    
    fileprivate func buildView() {
    
        self.layer.cornerRadius = 8.0
        self.backgroundColor = UIColor.black
        self.translatesAutoresizingMaskIntoConstraints = false
        verticalContainerStackView.axis = .vertical
        self.addSubview(verticalContainerStackView)
        
        verticalContainerStackView.anchorSidesTo(self)
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16)
        
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.distribution = .fill
        horizontalContainerStackView.alignment = .center
        horizontalContainerStackView.isLayoutMarginsRelativeArrangement = true
        
        let secondaryVerticalStackView = UIStackView()
        secondaryVerticalStackView.axis = .vertical
        
        songNameLabel.textColor = UIColor.white
        songNameLabel.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
        artistLabel.textColor = UIColor.white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 10.0)
        
        secondaryVerticalStackView.addArrangedSubview(songNameLabel)
        secondaryVerticalStackView.addArrangedSubview(artistLabel)
        
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(secondaryVerticalStackView)
        
        
        setupButton()
    }
    
    func setupButton() {
        
        if let currentTrackId = spotifyAudioPlayer.currentTrackId,
            let spotifyTrack = spotifyTrack {
            if currentTrackId == spotifyTrack.id {
                pausePlayButton.setButtonPause()
            } else {
                pausePlayButton.setButtonPlay()
            }
        } else {
            pausePlayButton.setButtonPlay()
        }
        
        pausePlayButton.addTarget(self, action: #selector(onPausePlayButtonTap), for: .touchUpInside)
        horizontalContainerStackView.addArrangedSubview(pausePlayButton)
    }
    
    func onPausePlayButtonTap() {
        
        if let currentTrackId = spotifyAudioPlayer.currentTrackId,
            let spotifyTrack = spotifyTrack,
            var queue = spotifyAudioPlayer.trackQueue {
            
            if currentTrackId == spotifyTrack.id {
                togglePlay()
            } else {
                queue.insert(spotifyTrack, at: 0)
                beginNewQueueWithSelection(trackQueue: queue)
            }
        }
    }
}

