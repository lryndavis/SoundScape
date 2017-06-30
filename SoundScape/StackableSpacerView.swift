
import UIKit

class StackableSpacerView: UIView {
    
    init(height: CGFloat, color: UIColor = UIColor.clear) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = color
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    init(width: CGFloat, color: UIColor = UIColor.clear) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = color
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
