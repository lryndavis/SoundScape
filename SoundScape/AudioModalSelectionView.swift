
import Foundation

//TODO: In progress, will be added below modal audio player 
class AudioModalSelectionView: UIView {
    
    let verticalContainerView = UIStackView()
    var tableView = UITableView()
    
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
        
        verticalContainerView.axis = .vertical
        verticalContainerView.translatesAutoresizingMaskIntoConstraints = false
        verticalContainerView.isLayoutMarginsRelativeArrangement = true
        
        self.addSubview(verticalContainerView)
        verticalContainerView.anchorSidesTo(self)
        
        verticalContainerView.addArrangedSubview(tableView)
    }
}

