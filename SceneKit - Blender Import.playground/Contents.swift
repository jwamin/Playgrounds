import UIKit
import SceneKit
import PlaygroundSupport

class SKViewController : UIViewController{
    
    var scene:SCNScene!
    var sceneView:SCNView!
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        print("load")
        
        sceneView = SCNView(frame: view.bounds)
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: sceneView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: sceneView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        print("hello worldz")
        NSLayoutConstraint(item: sceneView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: sceneView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0).isActive = true
        
        let file = #fileLiteral(resourceName: "NeXT-ao-4.scn")
        print(file.absoluteURL)
        do{ 
        scene = try SCNScene(url: file.absoluteURL, options: [:])
            print(sceneView)
            sceneView.scene = scene
            sceneView.autoenablesDefaultLighting = true
            sceneView.allowsCameraControl = true
            //scene.rootNode.camera.
        } catch {
        print(error)
        }
        //sceneView.scene = scen
    }
    
}

PlaygroundPage.current.liveView = SKViewController()

