
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
        
        verticalContainerStackView.axis = .vertical
        self.addSubview(verticalContainerStackView)
        verticalContainerStackView.anchorSidesTo(self)
        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(16, 24, 16, 24)
        verticalContainerStackView.spacing = 8.0
        
        songLabel.textColor = UIColor.black
        songLabel.font = UIFont(name: "Helvetica Neue", size: 12.0)
        
        artistLabel.textColor = UIColor.black
        artistLabel.font = UIFont(name: "Helvetica Neue", size: 8.0)
        
        verticalContainerStackView.addArrangedSubview(songLabel)
        verticalContainerStackView.addArrangedSubview(artistLabel)
    }
}


