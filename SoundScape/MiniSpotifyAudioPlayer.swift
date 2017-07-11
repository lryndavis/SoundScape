
import UIKit

protocol MiniSpotifyAudioPlayerDelegate {
    
    func togglePlay()
}

class MiniSpotifyAudioPlayer: UIView {

    let artistLabel = UILabel()
    let songLabel = UILabel()
    let pausePlayButton = AudioPausePlayButton()
    let verticalContainerStackView = UIStackView()
    let horizontalContainerStackView = UIStackView()
    
    var delegate: MiniSpotifyAudioPlayerDelegate?
    
    init() {
        super.init(frame: .zero)
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func buildView() {
        
        self.backgroundColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
        
        verticalContainerStackView.axis = .vertical
        self.addSubview(verticalContainerStackView)
        
        verticalContainerStackView.anchorSidesTo(self)
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(8, 16, 8, 16)
        
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.distribution = .fill
        horizontalContainerStackView.alignment = .center
        horizontalContainerStackView.isLayoutMarginsRelativeArrangement = true
        horizontalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let secondaryVerticalStackView = UIStackView()
        secondaryVerticalStackView.axis = .vertical
        secondaryVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        secondaryVerticalStackView.isLayoutMarginsRelativeArrangement = true
        
        songLabel.textColor = UIColor.white
        songLabel.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
        artistLabel.textColor = UIColor.white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 10.0)
        
        secondaryVerticalStackView.addArrangedSubview(songLabel)
        secondaryVerticalStackView.addArrangedSubview(artistLabel)
        
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(secondaryVerticalStackView)
        
        pausePlayButton.addTarget(self, action: #selector(onPausePlayButtonTap), for: .touchUpInside)
        horizontalContainerStackView.addArrangedSubview(pausePlayButton)
    }
    
    func onPausePlayButtonTap() {
        
        guard let delegate = delegate else { return }
        delegate.togglePlay()
    }
}
