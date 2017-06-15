
import UIKit
import MapKit

private let kMapPinImage = UIImage(named: "headphones")!

class SongDetailAnnotationView: MKAnnotationView {
    
    var customCalloutView: SongDetailMapView?
    
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = kMapPinImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.canShowCallout = false
        self.image = kMapPinImage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.customCalloutView?.removeFromSuperview()
            
            let newCustomCalloutView = loadSongDetailAnnotationView()
            self.addSubview(newCustomCalloutView)
            self.customCalloutView = newCustomCalloutView
            
            NSLayoutConstraint.activate([
                newCustomCalloutView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5),
                newCustomCalloutView.widthAnchor.constraint(equalToConstant: 200),
                newCustomCalloutView.heightAnchor.constraint(equalToConstant: 75),
                newCustomCalloutView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: self.calloutOffset.x)
                ])
            
            if animated {
                self.customCalloutView?.alpha = 0.0
                UIView.animate(withDuration: 0.3, animations: {
                    self.customCalloutView?.alpha = 1.0
                })
            }
        } else {
            if customCalloutView != nil {
                if animated {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.customCalloutView?.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView?.removeFromSuperview()
                    })
                } else {
                    self.customCalloutView?.removeFromSuperview()
                }
            }
        }
    }
    
    func loadSongDetailAnnotationView() -> SongDetailMapView {
        
        let songDetailMapView = SongDetailMapView()
        
        if let trackAnnotation = annotation as? SpotifyTrackAnnotation {
            songDetailMapView.setupWithTrack(spotifyTrack: trackAnnotation.spotifyTrackPartial)
        }
        return songDetailMapView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
