
import UIKit
import AVFoundation

protocol AudioModalViewDelegate {
    
    func handlePlayNextTrack()
    func handlePlayPreviousTrack()
    func togglePlay()
    func toggleFavoriteSong()
}

class AudioHalfModalView: UIView {
    
    let artistLabel = UILabel()
    let songLabel = UILabel()
    let pausePlayButton = UIButton()
    let mainVerticalContainerStackView = UIStackView()
    let controlsHorizontalStackView = UIStackView()
    let albumCoverImageView = UIImageView()
    let forwardButton = UIButton()
    let rewindButton = UIButton()
    let audioButton = ModalAudioButton()
    let progressSlider = UISlider()
    let favoriteButton = FavoriteSongButton()
    
    var albumCoverImage: UIImage?
    var delegate: AudioModalViewDelegate?
    let spotifyManager = SpotifyManager.sharedInstance
    var isDragging: Bool = false

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
        
        mainVerticalContainerStackView.axis = .vertical
        mainVerticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVerticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        mainVerticalContainerStackView.layoutMargins = UIEdgeInsetsMake(0.0, 16.0, 16.0, 16.0)
        mainVerticalContainerStackView.spacing = 8.0
        
        self.addSubview(mainVerticalContainerStackView)
        mainVerticalContainerStackView.anchorSidesTo(self)
        
        let secondaryVerticalContainerStackView = UIStackView()
        secondaryVerticalContainerStackView.axis = .vertical
        secondaryVerticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        secondaryVerticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVerticalContainerStackView.addArrangedSubview(secondaryVerticalContainerStackView)
        //secondaryVerticalContainerStackView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        let secondaryHorizontalContainerStackView = UIStackView()
        secondaryHorizontalContainerStackView.axis = .horizontal
        secondaryHorizontalContainerStackView.distribution = .fill
        secondaryHorizontalContainerStackView.alignment = .center
        secondaryHorizontalContainerStackView.isLayoutMarginsRelativeArrangement = true
        secondaryHorizontalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let songInfoContainerStackView = UIStackView()
        songInfoContainerStackView.axis = .vertical
        songInfoContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        songInfoContainerStackView.isLayoutMarginsRelativeArrangement = true
        songInfoContainerStackView.spacing = 4.0
        
        artistLabel.textColor = .white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        artistLabel.textAlignment = .left
        
        songLabel.textColor = .white
        songLabel.font = UIFont(name: "Helvetica Neue", size: 16.0)
        songLabel.textAlignment = .left
        
        songInfoContainerStackView.addArrangedSubview(artistLabel)
        songInfoContainerStackView.addArrangedSubview(songLabel)
        
    
        secondaryVerticalContainerStackView.addArrangedSubview(secondaryHorizontalContainerStackView)
        secondaryHorizontalContainerStackView.addArrangedSubview(songInfoContainerStackView)
        secondaryHorizontalContainerStackView.addArrangedSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(onFavoriteButtonTap), for: .touchUpInside)
        
        addControlsStackView()
    }
    
    private func addControlsStackView() {
        
        // setup controls stack view
        controlsHorizontalStackView.axis = .horizontal
        controlsHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        controlsHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        controlsHorizontalStackView.distribution = .equalSpacing
        controlsHorizontalStackView.alignment = .center
        controlsHorizontalStackView.layoutMargins = UIEdgeInsetsMake(16.0, 0.0, 16.0, 0.0)
        
        // add buttons
        mainVerticalContainerStackView.addArrangedSubview(controlsHorizontalStackView)
        setupControlButtons()
        controlsHorizontalStackView.addArrangedSubview(rewindButton)
        
        controlsHorizontalStackView.addArrangedSubview(audioButton)
        audioButton.addTarget(self, action: #selector(onPausePlayButtonTap), for: .touchUpInside)

        controlsHorizontalStackView.addArrangedSubview(forwardButton)
        
        // add audio progress slider
        progressSlider.thumbTintColor = .red
        mainVerticalContainerStackView.addArrangedSubview(progressSlider)
        self.bringSubview(toFront: progressSlider)
        progressSlider.addTarget(self, action: #selector(seekTrack), for: .allEvents)
        progressSlider.isContinuous = true

    }
    
    func updateProgressSlider(position: TimeInterval) {
        
        if !isDragging {
            guard let currentTrack = spotifyManager.currentTrack else { return }
            let duration = currentTrack.track.duration

            progressSlider.value = Float(position / duration)
        }
    }
    
    func seekTrack(sender: UISlider, for event: UIEvent) {

        isDragging = false
        
        guard let touchEvents = event.allTouches else { return }
        for touchEvent in touchEvents {
            if touchEvent.phase == .began || touchEvent.phase == .moved {
                isDragging = true
            }
        }
        
        if !isDragging {
            guard let currentTrack = spotifyManager.currentTrack else { return }
            let targetTime = currentTrack.track.duration * Double(progressSlider.value)
            spotifyManager.player?.seek(to: TimeInterval(targetTime), callback: nil)
        }
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
    
    func onFavoriteButtonTap() {
        guard let delegate = delegate else { return }
        delegate.toggleFavoriteSong()
    }
}
