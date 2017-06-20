
import UIKit
import MapKit
import Pulsator

let kMapPinImage = UIImage(named: "headphones")!

class SongDetailAnnotationView: MKAnnotationView {
    
    var customCalloutView: SongDetailMapView?
    var delegate: SongDetailMapViewDelegate? 
    
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = kMapPinImage

        //animateWithPulse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.canShowCallout = false
        self.image = kMapPinImage
    }

//    func animateWithPulse() {
//        
//        let pulsator = Pulsator()
//        pulsator.position = CGPoint(x: 17, y: 19)
//        pulsator.numPulse = 9
//        pulsator.radius = 32
//        pulsator.animationDuration = 5.9
//        pulsator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        layer.addSublayer(pulsator)
//
//        if let trackAnnotation = annotation as? SpotifyTrackAnnotation {
//            if trackAnnotation.isCurrentlyPlaying {
//                pulsator.start()
//            } else {
//                pulsator.stop()
//            }
//        }
//    }
    
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
        songDetailMapView.delegate = self.delegate
        
        if let trackAnnotation = annotation as? SpotifyTrackAnnotation {
            songDetailMapView.setupWithTrack(spotifyTrack: trackAnnotation.spotifyTrack)
        }
        return songDetailMapView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else {
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
}
