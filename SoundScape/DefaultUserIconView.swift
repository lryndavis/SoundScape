
import Foundation


class DefaultRoundIconView: UIView {
    
    let label = UILabel()
    var displayName = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupRoundIcon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupRoundIcon()
    }
    
    private func setupRoundIcon() {
        self.backgroundColor = UIColor.black
    }

    override func draw(_ rect: CGRect) {
        
        let radius = self.frame.size.width / 2
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        label.font = UIFont(name: "Helvetica Neue", size: 22.0)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.sizeToFit()
        label.center = self.convert(self.center, from: self.superview)
        
        self.addSubview(label)
    }
    
    public func setupUserIconText(displayName: String) {
        
        let letterIndex = displayName.characters.index(displayName.startIndex, offsetBy: 1)
        label.text = displayName.substring(to: letterIndex).capitalized
    }
}
