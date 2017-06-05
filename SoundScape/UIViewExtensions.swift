
import Foundation

extension UIView {
    
    func anchorSidesTo(_ view: UIView, insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0) , topAnchorActive : Bool = true, leadingAnchorActive : Bool = true , bottomAnchorActive : Bool = true , trailingAnchorActive : Bool = true ) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = topAnchorActive
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = leadingAnchorActive
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = bottomAnchorActive
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right).isActive = trailingAnchorActive
    }
}
