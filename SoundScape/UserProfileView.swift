

import UIKit

protocol UserProfileViewDelegate {
    //add method for logout user
}

class UserProfileView: UIView {
    
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let userImageView = UIImageView()
    let mainHorizontalStackView = UIStackView()
    let profileImageHorizontalStackView = UIStackView()
    let profileTextVerticalStackView = UIStackView()
    let logoutButton = LogoutButton()
    
    var username: String?
    var userAvatarImage: UIImage?

    init() {
        super.init(frame: .zero)
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func buildView() {
        
        self.translatesAutoresizingMaskIntoConstraints = false

        mainHorizontalStackView.axis = .horizontal
        mainHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        mainHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        mainHorizontalStackView.layoutMargins = UIEdgeInsetsMake(16.0, 0.0, 16.0, 16.0)
        
        self.addSubview(mainHorizontalStackView)
        mainHorizontalStackView.anchorSidesTo(self)
        
        profileImageHorizontalStackView.axis = .horizontal
        profileImageHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        profileImageHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        profileImageHorizontalStackView.layoutMargins = UIEdgeInsetsMake(0.0, 16.0, 0.0, 0.0)
        profileImageHorizontalStackView.spacing = 16.0
        profileImageHorizontalStackView.alignment = .center
        
        profileTextVerticalStackView.axis = .vertical
        profileTextVerticalStackView.isLayoutMarginsRelativeArrangement = false
        profileTextVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        mainHorizontalStackView.addArrangedSubview(profileImageHorizontalStackView)
        mainHorizontalStackView.addArrangedSubview(logoutButton)
    }
    
    public func setupUserProfileText() {
        
        usernameLabel.font = UIFont(name: "Helvetica Neue", size: 18.0)
        usernameLabel.text = username
        
        profileImageHorizontalStackView.addArrangedSubview(profileTextVerticalStackView)
        profileTextVerticalStackView.addArrangedSubview(usernameLabel)
    }
    
    public func setupUserIconImage() {
        
        if let userAvatarImage = userAvatarImage {
            
            userImageView.clipsToBounds = true
            userImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
            userImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            userImageView.layer.cornerRadius = 40
            
            profileImageHorizontalStackView.addArrangedSubview(userImageView)
            userImageView.image = userAvatarImage
        }
    }
    
    public func setupDefaultIconImage() {

        if let username = username {
            
            let defaultIconView = DefaultRoundIconView()
            
            defaultIconView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
            defaultIconView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
            
            defaultIconView.setupUserIconText(displayName: username)
            profileImageHorizontalStackView.addArrangedSubview(defaultIconView)
        }
    }
    
    public func removeAllSubviews() {
        
        for view in mainHorizontalStackView.arrangedSubviews {
            mainHorizontalStackView.removeArrangedSubview(view)
        }
    }
    
}
