
import UIKit

protocol AudioModalViewDelegate {
    
    func handlePlayNextTrack()
    func handlePlayPreviousTrack()
    func togglePlay()
}

class AudioHalfModalView: UIView {
    
    let artistLabel = UILabel()
    let songLabel = UILabel()
    let pausePlayButton = UIButton()
    let verticalContainerStackView = UIStackView()
    let controlsHorizontalStackView = UIStackView()
    let albumCoverImageView = UIImageView()
    let forwardButton = UIButton()
    let rewindButton = UIButton()
    let audioButton = ModalAudioButton()
    
    var albumCoverImage: UIImage?
    var delegate: AudioModalViewDelegate?
    
    init() {
        super.init(frame: .zero)

        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
        
    private func buildView() {
        
        self.backgroundColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
        
        verticalContainerStackView.axis = .vertical
        verticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(0.0, 16.0, 8.0, 16.0)
        verticalContainerStackView.spacing = 16.0
        
        self.addSubview(verticalContainerStackView)
        verticalContainerStackView.anchorSidesTo(self)
        
        let songInfoContainerStackView = UIStackView()
        songInfoContainerStackView.axis = .vertical
        songInfoContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        songInfoContainerStackView.isLayoutMarginsRelativeArrangement = true
        songInfoContainerStackView.spacing = 8.0
        verticalContainerStackView.addArrangedSubview(songInfoContainerStackView)
        
        artistLabel.textColor = .white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        artistLabel.textAlignment = .left
        
        songLabel.textColor = .white
        songLabel.font = UIFont(name: "Helvetica Neue", size: 18.0)
        songLabel.textAlignment = .left
        
        songInfoContainerStackView.addArrangedSubview(artistLabel)
        songInfoContainerStackView.addArrangedSubview(songLabel)
        
        addControlsStackView()
    }
    
    private func addControlsStackView() {
        
        controlsHorizontalStackView.axis = .horizontal
        controlsHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        controlsHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        controlsHorizontalStackView.distribution = .equalSpacing
        controlsHorizontalStackView.alignment = .center
        controlsHorizontalStackView.layoutMargins = UIEdgeInsetsMake(16.0, 0.0, 16.0, 0.0)
        
        verticalContainerStackView.addArrangedSubview(controlsHorizontalStackView)
        setupControlButtons()
        controlsHorizontalStackView.addArrangedSubview(rewindButton)
        
        controlsHorizontalStackView.addArrangedSubview(audioButton)
        audioButton.addTarget(self, action: #selector(onPausePlayButtonTap), for: .touchUpInside)

        controlsHorizontalStackView.addArrangedSubview(forwardButton)
    }
    
    private func setupControlButtons() {

        // fast forward button
        forwardButton.tintColor = .white
        forwardButton.imageView?.contentMode = .scaleAspectFit
        
        let forwardImage = UIImage(named: "forward.png")
        let tintedForwardImage = forwardImage?.withRenderingMode(.alwaysTemplate)
        forwardButton.setImage(tintedForwardImage, for: .normal)
        forwardButton.addTarget(self, action: #selector(onForwardButtonTap), for: .touchUpInside)

        // rewind button
        rewindButton.tintColor = .white
        rewindButton.imageView?.contentMode = .scaleAspectFit
        
        let rewindImage = UIImage(named: "rewind.png")
        let tintedRewindImage = rewindImage?.withRenderingMode(.alwaysTemplate)
        rewindButton.setImage(tintedRewindImage, for: .normal)
        rewindButton.addTarget(self, action: #selector(onRewindButtonTap), for: .touchUpInside)
    }
    
    func onForwardButtonTap() {
        guard let delegate = delegate else { return }
        delegate.handlePlayNextTrack()
    }
    
    func onRewindButtonTap() {
        guard let delegate = delegate else { return }
        delegate.handlePlayPreviousTrack()
    }
    
    func onPausePlayButtonTap() {
        guard let delegate = delegate else { return }
        delegate.togglePlay()
    }
}
