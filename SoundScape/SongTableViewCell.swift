
import UIKit

class SongTableViewCell: UITableViewCell {
    
    var songLabel = UILabel()
    var artistLabel = UILabel()
    var verticalContainerStackView = UIStackView()

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildCell()
    }
    
    fileprivate func buildCell() {
        
        let imageView = UIImageView()
        let horizontalContainerStackView = UIStackView()
        horizontalContainerStackView.axis = .horizontal
        horizontalContainerStackView.isLayoutMarginsRelativeArrangement = true
        horizontalContainerStackView.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)
        horizontalContainerStackView.spacing = 8.0
        horizontalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalContainerStackView)
        horizontalContainerStackView.anchorSidesTo(self)
        
        imageView.image = UIImage(named: "headphones.png")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        horizontalContainerStackView.addArrangedSubview(imageView)
        
        verticalContainerStackView.axis = .vertical
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalContainerStackView.spacing = 8.0
        
        songLabel.textColor = UIColor.black
        songLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        artistLabel.textColor = UIColor.black
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 8.0)
        
        verticalContainerStackView.addArrangedSubview(songLabel)
        verticalContainerStackView.addArrangedSubview(artistLabel)
        
        horizontalContainerStackView.addArrangedSubview(verticalContainerStackView)
    }
}


