//Todo: on hold for now 

//
//import UIKit
//
//class NoResultsView: UIView {
//    
//    let noResultsLabel = UILabel()
//    let addSongsButton = UIButton()
//    let verticalContainerStackView = UIStackView()
//    
//    init() {
//        super.init(frame: .zero)
//        
//        buildView()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    fileprivate func buildView() {
//        
//        self.translatesAutoresizingMaskIntoConstraints = false
//        verticalContainerStackView.axis = .vertical
//        self.addSubview(verticalContainerStackView)
//        verticalContainerStackView.anchorSidesTo(self)
//        verticalContainerStackView.isLayoutMarginsRelativeArrangement = true
//        verticalContainerStackView.layoutMargins = UIEdgeInsetsMake(16, 24, 16, 24)
//        
//        noResultsLabel.textColor = UIColor.black
//        noResultsLabel.text = "Sorry, there are no songs near you!"
//        noResultsLabel.font = UIFont(name: "Helvetica Neue", size: 18.0)
//        
//        verticalContainerStackView.addArrangedSubview(noResultsLabel)
//        
//        addSongsButton.setTitle("Add a song", for: .normal)
//        addSongsButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
//        verticalContainerStackView.addArrangedSubview(addSongsButton)
//    }
//}
