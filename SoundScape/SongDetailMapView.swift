
import UIKit

protocol SongDetailMapViewDelegate {
    
    func setAnnotationAudioPlayer(track: SpotifyTrack)
}

class SongDetailMapView: UIView {
    
    let songNameLabel = UILabel()
    let artistLabel = UILabel()
    let closeButton = UIButton()
    let verticalContainerStackView = UIStackView()
    let horizontalContainerStackView = UIStackView()
    let playTrackButton = UIButton()
    let backgroundViewButton = UIButton()

    var spotifyTrack: SpotifyTrack?
    //let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    var delegate: SongDetailMapViewDelegate?
    
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
        
        self.addSubview(backgroundViewButton)
        backgroundViewButton.anchorSidesTo(self)
        backgroundViewButton.translatesAutoresizingMaskIntoConstraints = false
        self.bringSubview(toFront: backgroundViewButton)
    
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

        addButton()
    }
    
    func addButton() {
        
        playTrackButton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        playTrackButton.tintColor = .white
        playTrackButton.imageView?.contentMode = .scaleAspectFit
        
        let playImage = UIImage(named: "playlist.png")
        let tintedPlayImage = playImage?.withRenderingMode(.alwaysTemplate)
        playTrackButton.setImage(tintedPlayImage, for: .normal)
        
        playTrackButton.addTarget(self, action: #selector(onPlayButtonTap), for: .touchUpInside)
        horizontalContainerStackView.addArrangedSubview(playTrackButton)
    }
    
    func onPlayButtonTap(_ sender: AudioPausePlayButton) {
        
        guard let delegate = delegate,
              let spotifyTrack = spotifyTrack else { return }
        
        delegate.setAnnotationAudioPlayer(track: spotifyTrack)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let result = playTrackButton.hitTest(convert(point, to: playTrackButton), with: event) {
            return result
        }
        return backgroundViewButton.hitTest(convert(point, to: backgroundViewButton), with: event)
    }
}

