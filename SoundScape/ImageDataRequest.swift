
import Foundation
import AlamofireImage
import Alamofire


struct ImageDataRequest {
    
    static func getAlbumCoverImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        var newImage: UIImage?
        
        Alamofire.request(imageUrl).response { response in
            
            dispatchGroup.enter()
            
            if let imageData = response.data {
                newImage = UIImage(data: imageData)
            } else {
                print("error fetching image")
            }
            dispatchGroup.leave()
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(newImage)
            }
        }
    }
    
}

