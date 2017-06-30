
import UIKit


class AudioHalfModalView: UIView {
    
    let artistLabel = UILabel()
    let songLabel = UILabel()
    let pausePlayButton = UIButton()
    let verticalContainerStackView = UIStackView()
    let controlsHorizontalStackView = UIStackView()
    let albumCoverImageView = UIImageView()
    let forwardButton = UIButton()
    let rewindButton = UIButton()
    
    var albumCoverImage: UIImage?
    let spotifyAudioPlayer = SpotifyAudioPlayer.sharedInstance
    
    init(albumCoverImage: UIImage?) {
        super.init(frame: .zero)
        
        self.albumCoverImage = albumCoverImage
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
        
        let currentArtist = spotifyAudioPlayer.currentTrack?.albumArtistDisplay ?? "Artist Unavailable"
        let currentSong = spotifyAudioPlayer.currentTrack?.name ?? "Song Unavailable"
        
        artistLabel.textColor = .white
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        artistLabel.textAlignment = .left
        artistLabel.text = currentArtist
        
        songLabel.textColor = .white
        songLabel.font = UIFont(name: "Helvetica Neue", size: 18.0)
        songLabel.textAlignment = .left
        songLabel.text = currentSong
        
        songInfoContainerStackView.addArrangedSubview(artistLabel)
        songInfoContainerStackView.addArrangedSubview(songLabel)
        
        addControlsStackView()
    }
    
    private func addControlsStackView() {
        
        controlsHorizontalStackView.axis = .horizontal
        controlsHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        controlsHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        controlsHorizontalStackView.distribution = .fillEqually
        controlsHorizontalStackView.layoutMargins = UIEdgeInsetsMake(16.0, 0.0, 16.0, 0.0)
        
        verticalContainerStackView.addArrangedSubview(controlsHorizontalStackView)
        
        setupControlButtons()
        setupAlbumCoverImageView()
        
        controlsHorizontalStackView.addArrangedSubview(rewindButton)
        controlsHorizontalStackView.addArrangedSubview(albumCoverImageView)
        controlsHorizontalStackView.addArrangedSubview(forwardButton)
        
        let verticalSpacerView = StackableSpacerView(height: 40.0, color: .black)
        verticalContainerStackView.addArrangedSubview(verticalSpacerView)
    }
    
    private func setupAlbumCoverImageView() {
        
        albumCoverImageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        albumCoverImageView.contentMode = .scaleAspectFit
        
        if let albumCoverImage = albumCoverImage {
            let image = albumCoverImage.af_imageRoundedIntoCircle()
            albumCoverImageView.image = image
        }
        
        pausePlayButton.frame = CGRect(x: 28, y: 25, width: 50.0, height: 50.0)
        pausePlayButton.tintColor = .white
        pausePlayButton.imageView?.contentMode = .scaleAspectFill
        
        let forwardImage = UIImage(named: "play.png")
        let tintedForwardImage = forwardImage?.withRenderingMode(.alwaysTemplate)
        pausePlayButton.setImage(tintedForwardImage, for: .normal)

        albumCoverImageView.addSubview(pausePlayButton)
        albumCoverImageView.bringSubview(toFront: pausePlayButton)
        albumCoverImageView.isUserInteractionEnabled = true
    }
    
    private func setupControlButtons() {

        // fast forward button
        forwardButton.tintColor = .white
        forwardButton.imageView?.contentMode = .scaleAspectFit
        
        let forwardImage = UIImage(named: "forward.png")
        let tintedForwardImage = forwardImage?.withRenderingMode(.alwaysTemplate)
        forwardButton.setImage(tintedForwardImage, for: .normal)

        // rewind button
        rewindButton.tintColor = .white
        rewindButton.imageView?.contentMode = .scaleAspectFit
        
        let rewindImage = UIImage(named: "rewind.png")
        let tintedRewindImage = rewindImage?.withRenderingMode(.alwaysTemplate)
        rewindButton.setImage(tintedRewindImage, for: .normal)

    }
}
