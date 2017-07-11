
import UIKit

// build the annotation (map pin) view 
protocol SongDetailMapViewDelegate {
    
    func setAnnotationAudioPlayer(track: SpotifyTrackExtended)
}

class SongDetailMapView: UIView {
    
    let songNameLabel = UILabel()
    let artistLabel = UILabel()
    let userLabel = UILabel()
    let closeButton = UIButton()
    let verticalContainerStackView = UIStackView()
    let horizontalContainerStackView = UIStackView()
    let playTrackButton = UIButton()
    let backgroundViewButton = UIButton()

    var spotifyTrackExtended: SpotifyTrackExtended?
    let spotifyManager = SpotifyManager.sharedInstance
    var delegate: SongDetailMapViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupWithTrack(spotifyTrackExtended: SpotifyTrackExtended) {
        
        self.spotifyTrackExtended = spotifyTrackExtended
        
        songNameLabel.text = spotifyTrackExtended.track.name
        artistLabel.text = spotifyTrackExtended.primaryArtistDisplayStr
        userLabel.text = "Placed By: \(spotifyTrackExtended.userDisplayStr)"
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
        verticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.distribution = .fill
        horizontalContainerStackView.alignment = .center
        horizontalContainerStackView.isLayoutMarginsRelativeArrangement = true
        horizontalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let secondaryVerticalStackView = UIStackView()
        secondaryVerticalStackView.axis = .vertical
        secondaryVerticalStackView.translatesAutoresizingMaskIntoConstraints = false 
        
        songNameLabel.textColor = UIColor.white
        songNameLabel.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
        artistLabel.textColor = UIColor.white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 10.0)
        
        userLabel.textColor = UIColor.white
        userLabel.font = UIFont(name: "Helvetica Neue", size: 10.0)
        
        secondaryVerticalStackView.addArrangedSubview(songNameLabel)
        secondaryVerticalStackView.addArrangedSubview(artistLabel)
        secondaryVerticalStackView.addArrangedSubview(userLabel)
        
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(secondaryVerticalStackView)

        addButton()
    }
    
    func addButton() {
        
        playTrackButton.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        playTrackButton.tintColor = .blue
        playTrackButton.imageView?.contentMode = .scaleAspectFit
        
        let playImage = UIImage(named: "play.png")
        let tintedPlayImage = playImage?.withRenderingMode(.alwaysTemplate)
        playTrackButton.setImage(tintedPlayImage, for: .normal)
        
        playTrackButton.addTarget(self, action: #selector(onPlayButtonTap), for: .touchUpInside)
        horizontalContainerStackView.addArrangedSubview(playTrackButton)
    }
    
    func onPlayButtonTap(_ sender: AudioPausePlayButton) {
        
        guard let delegate = delegate,
              let spotifyTrackExtended = spotifyTrackExtended else { return }
        
        delegate.setAnnotationAudioPlayer(track: spotifyTrackExtended)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let result = playTrackButton.hitTest(convert(point, to: playTrackButton), with: event) {
            return result
        }
        return backgroundViewButton.hitTest(convert(point, to: backgroundViewButton), with: event)
    }
}

