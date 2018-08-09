import UIKit
import ARKit
import PlaygroundSupport

let debug = false

class ARView : UIViewController, ARSCNViewDelegate  {
    
    var arsceneview:ARSCNView!
    var scene:SCNScene?
    var pointerDot:UIView!
    var pointerPosition:CGPoint!
    var thisIsAHit:Bool = false 
    
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".serialSceneKitQueue")
    
    override func loadView() {
        self.view = UIView()
    }
    
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.cyan
        
        initLiveView()
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("session interruped")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("session resumed")
        arsceneview.session.run(session.configuration!, options: [.resetTracking,.removeExistingAnchors])
    }
    
    
    func initLiveView(){
        
        let uiImages = [#imageLiteral(resourceName: "ARMarker.jpg")]
        var detectionImages:Set<ARReferenceImage> = []
        for uiimage in uiImages{
            let cg = uiimage.cgImage
            let ariamge:ARReferenceImage = ARReferenceImage.init(cg!,orientation:CGImagePropertyOrientation.up,physicalWidth:0.3)
            detectionImages.insert(ariamge)
        }
        
        
        let config = ARWorldTrackingConfiguration()
        config.detectionImages = detectionImages
        config.planeDetection = [.horizontal]
        
        scene = SCNScene()
        
        arsceneview = ARSCNView(frame: self.view.bounds)
        if (debug){
            arsceneview.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        }
        
        arsceneview?.session.run(config, options: [.resetTracking,.removeExistingAnchors])
        arsceneview?.scene = scene!
        
        
        arsceneview?.delegate = self
        
        self.view = arsceneview
    }
    
    
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {return}
        let referenceImage = imageAnchor.referenceImage
        
        updateQueue.async{
            let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            planeNode.eulerAngles.x = -.pi / 2
            planeNode.runAction(self.imageHilightAction, completionHandler: { 
                self.removeDetectionAnchor(anchor: anchor)
            })
            
            node.addChildNode(planeNode)
            
        }
        
    }
    
    func removeDetectionAnchor(anchor:ARAnchor){
        arsceneview.session.remove(anchor: anchor)
    }
    
    var imageHilightAction:SCNAction {
        return .sequence([
        .wait(duration:0.25),
        .fadeOpacity(to: 0.85, duration:0.25),
        .fadeOpacity(to: 0.15, duration:0.25),
        .fadeOpacity(to: 0.85, duration:0.25),
        .fadeOut(duration: 0.5),
        .removeFromParentNode()
            
            ])
    }
    
}

let arvc = ARView()

PlaygroundPage.current.liveView = arvc
