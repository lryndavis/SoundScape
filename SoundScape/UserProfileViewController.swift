
import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var mainVerticalContainerStackView: UIStackView!

    let userProfileView = UserProfileView()
    let segmentedControl = UISegmentedControl()
    
    let spotifyManager = SpotifyManager.sharedInstance
    let dataSource = UserProfileDataSource()
    var user: CurrentSpotifyUser?
    
    let horizontalLineStackView = UIStackView()
    let firstSegmentUnderline = UIView()
    let secondSegmentUnderline = UIView()
    
    private lazy var favoriteTracksViewController: FavoriteTracksViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "FavoriteTracksViewController") as! FavoriteTracksViewController
        
        self.addAsChildViewController(viewController: viewController)
        
        return viewController
        
    }()
    
    private lazy var soundScapeTracksViewController: SoundScapeTracksViewController = {
       
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "SoundScapeTracksViewController") as! SoundScapeTracksViewController
        
        self.addAsChildViewController(viewController: viewController)
        
        return viewController
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataSource.loadData(completion: {
            [weak self] success in
                if success {
                    if let strongSelf = self {
                    
                        let user = strongSelf.dataSource.currentUser
                        strongSelf.user = user
                        strongSelf.userProfileView.username = user?.id
                        strongSelf.getUserProfileImage()
                }
            }
        })
    }
    
    private func setupView() {
        
        mainVerticalContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVerticalContainerStackView.addArrangedSubview(userProfileView)

        setupSegmentedControl()
        updateView()
    }
    
    private func getUserProfileImage() {
        
        guard let user = user else { return }
        userProfileView.username = user.id
        
        if let imageUrl = user.largestImageUrl {
            ImageDataRequest.getImageData(imageUrl: imageUrl, completion: {
                [weak self] image in
                if let strongSelf = self {
                    
                    strongSelf.userProfileView.userAvatarImage = image
                    strongSelf.userProfileView.setupProfileDisplayInfo()
                }
            })
        }
    }
    
    private func setupSegmentedControl() {
        
        mainVerticalContainerStackView.addArrangedSubview(segmentedControl)
        segmentedControl.removeAllSegments()
        segmentedControl.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        segmentedControl.insertSegment(withTitle: "YOUR FAVORITES", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "YOUR SOUNDSCAPES", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.removeBorder()

        horizontalLineStackView.axis = .horizontal
        horizontalLineStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalLineStackView.heightAnchor.constraint(equalToConstant: 2.0).isActive  = true

        horizontalLineStackView.addArrangedSubview(firstSegmentUnderline)
        horizontalLineStackView.addArrangedSubview(secondSegmentUnderline)

        mainVerticalContainerStackView.addArrangedSubview(horizontalLineStackView)
        
        firstSegmentUnderline.widthAnchor.constraint(equalTo: mainVerticalContainerStackView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {

        updateView()
    }
    
    func addAsChildViewController(viewController: UIViewController) {
        
        addChildViewController(viewController)
        mainVerticalContainerStackView.addArrangedSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    func removeAsChildViewController(viewController: UIViewController) {
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            UIView.animate(withDuration: 0.8, animations: {
                self.firstSegmentUnderline.backgroundColor = .blue
            })
            
            secondSegmentUnderline.backgroundColor = .white
            removeAsChildViewController(viewController: soundScapeTracksViewController)
            addAsChildViewController(viewController: favoriteTracksViewController)
        } else {
            
            UIView.animate(withDuration: 0.8, animations: {
                self.secondSegmentUnderline.backgroundColor = .blue
            })
            
            firstSegmentUnderline.backgroundColor = .white
            removeAsChildViewController(viewController: favoriteTracksViewController)
            addAsChildViewController(viewController: soundScapeTracksViewController)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

