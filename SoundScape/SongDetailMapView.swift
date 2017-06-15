
import UIKit

//TODO: delegate for playing song

class SongDetailMapView: UIView {
    
    let songNameLabel = UILabel()
    let artistLabel = UILabel()
    let playButton = UIButton()
    let closeButton = UIButton()
    let verticalContainerStackView = UIStackView()
    let horizontalContainerStackView = UIStackView()
    
    var spotifyTrack: SpotifyTrack?
    
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
    }
}

