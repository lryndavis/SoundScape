
import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainContainerView: UIView!
    let userProfileView = UserProfileView()
    
    let spotifyManager = SpotifyManager.sharedInstance
    let dataSource = UserProfileDataSource()
    var sptUser: SPTUser?
    
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

        userProfileView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true 
        userProfileView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(userProfileView)
        setupSegmentedControl()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let currentUser = spotifyManager.currentUser {
            dataSource.loadData(username: currentUser.canonicalUserName, completion: {
                [weak self] success in
                if success {
                    if let strongSelf = self {
                        let user = strongSelf.dataSource.sptUser
                        strongSelf.sptUser = user
                        strongSelf.getUserProfileImage()
                    }
                }
            })
        }
    }
    
    private func getUserProfileImage() {
        
        if let sptUser = sptUser {
            if let userImageURL = SpotifyUser.getUserProfileImage(user: sptUser) {
                ImageDataRequest.getImageData(imageUrl: userImageURL, completion: {
                    [weak self] image in
                    if let strongSelf = self {
                        guard let image = image else { return }
                        strongSelf.userProfileView.userImage = image
                        strongSelf.userProfileView.setupProfileImage()
                    }
                })
            }
        }
    }
    
    private func setupSegmentedControl() {
        
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Your Favorites", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Your SoundScapes", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    func addAsChildViewController(viewController: UIViewController) {
        
        addChildViewController(viewController)
        mainContainerView.addSubview(viewController.view)
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
            removeAsChildViewController(viewController: soundScapeTracksViewController)
            addAsChildViewController(viewController: favoriteTracksViewController)
        } else {
            removeAsChildViewController(viewController: favoriteTracksViewController)
            addAsChildViewController(viewController: soundScapeTracksViewController)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

