//: A MapKit based Playground

import MapKit
import PlaygroundSupport






class ViewController : UIViewController{
    override func viewDidLoad() {
        //let infiniteLoopCoord = CLLocationCoordinate2DMake(37.331695, -122.0322854)
        let gwBridge = CLLocationCoordinate2DMake(40.8516, -73.9524)
        
        // Now let's create a MKMapView
        let mapView = MKMapView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.width))
        
        mapView.mapType = MKMapType(rawValue: 3)!
        mapView.showsBuildings = true
        let myCamera = MKMapCamera()
        myCamera.pitch = 50
        print(mapView.camera.pitch,myCamera.pitch)
        
        mapView.camera = myCamera
        print(mapView.camera.pitch,myCamera.pitch)
        
        // Define a region for our map view
        var mapRegion = MKCoordinateRegion()
        
        let mapRegionSpan = 0.02
        mapRegion.center = gwBridge
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan
        
        mapView.setRegion(mapRegion, animated: true)
        
        // Create a map annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = gwBridge
        annotation.title = "George Washington Bridge"
        annotation.subtitle = "The Hudson river, 2 years ago..."
        mapView.addAnnotation(annotation)
        
        self.view = mapView
        
    }
}

let myMapVC = ViewController()
PlaygroundPage.current.liveView = myMapVC
// Add the created mapView to our Playground Live View

