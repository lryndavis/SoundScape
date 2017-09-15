

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
    
    var userImage: UIImage?

    init() {
        super.init(frame: .zero)
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func buildView() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .blue
       // self.heightAnchor.constraint(equalToConstant: 115.0).isActive = true

        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.isLayoutMarginsRelativeArrangement = true
        //containerStackView.layoutMargins = UIEdgeInsetsMake(16.0, 0, 16.0, 0.0)
        
        self.addSubview(containerStackView)
        containerStackView.anchorSidesTo(self)
        
        mainHorizontalStackView.axis = .horizontal
        mainHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        mainHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        mainHorizontalStackView.layoutMargins = UIEdgeInsetsMake(16.0, 0.0, 16.0, 16.0)
        
        containerStackView.addArrangedSubview(mainHorizontalStackView)
        
//        self.addSubview(mainHorizontalStackView)
//        mainHorizontalStackView.anchorSidesTo(self)
        
        profileImageHorizontalStackView.axis = .horizontal
        profileImageHorizontalStackView.isLayoutMarginsRelativeArrangement = true
        profileImageHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        profileImageHorizontalStackView.layoutMargins = UIEdgeInsetsMake(0.0, 16.0, 0.0, 0.0)
        profileImageHorizontalStackView.spacing = 16.0
        profileImageHorizontalStackView.alignment = .center
        
        mainHorizontalStackView.addArrangedSubview(profileImageHorizontalStackView)
        
        userImageView.clipsToBounds = true
        userImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        userImageView.layer.cornerRadius = 40
        profileImageHorizontalStackView.addArrangedSubview(userImageView)
        
        profileTextVerticalStackView.axis = .vertical
        profileTextVerticalStackView.isLayoutMarginsRelativeArrangement = false
        profileTextVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        profileTextVerticalStackView.addArrangedSubview(nameLabel)
        profileTextVerticalStackView.addArrangedSubview(usernameLabel)
        
        profileImageHorizontalStackView.addArrangedSubview(profileTextVerticalStackView)
        
        mainHorizontalStackView.addArrangedSubview(logoutButton)
    }
    
    func setupProfileImage() {
        
        userImageView.image = userImage
        nameLabel.text = "test"
        usernameLabel.text = "test"
    }
    
    private func setupLabels() {
        
        
    }
}
