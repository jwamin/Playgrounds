import UIKit
import ARKit
import os
import PlaygroundSupport

//OSLog("log message")

class ARSKSceneViewController : UIViewController, ARSessionDelegate, ARSKViewDelegate{
    
    var sksceneview:ARSKView!
    var pointSwitch:UISwitch!
    
    override func loadView() {
        view = UIView()
    }
    
    override func viewDidLoad() {
        
        sksceneview = ARSKView(frame: self.view.bounds)
        view = sksceneview
        sksceneview.session.delegate = self
        sksceneview.delegate = self
        let scene = SKScene(size: self.view.bounds.size)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sksceneview.presentScene(scene)
        sksceneview.showsFPS = true
        sksceneview.showsNodeCount = true
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.isLightEstimationEnabled = true
        sksceneview.session.run(config, options: [.removeExistingAnchors])
        
        pointSwitch = UISwitch()
        sksceneview.addSubview(pointSwitch)
        
    }
    
    var savedAnchors:[ARAnchor] = []
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let pointCloud = frame.rawFeaturePoints{
            
            if (pointSwitch.isOn){
                drawFeaturePoints(pointCloud)
            }
            
        }
        
    }
    
    func drawFeaturePoints(_ points:ARPointCloud){
        print(points)
    }
    
    func view(_ view: ARSKView, willUpdate node: SKNode, for anchor: ARAnchor) {
        guard let current = sksceneview.session.currentFrame, let lightestimate = current.lightEstimate else{
            return
        }
        
        let neutralIntensity:CGFloat = 1000
        let ambient = min(lightestimate.ambientIntensity,neutralIntensity)
        
        let blendfactor = 1 - ambient / neutralIntensity
        
        if let sprite = node as? SKSpriteNode{
            sprite.color = UIColor.black
            sprite.colorBlendFactor = blendfactor
        }
        
        
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        return SKLabelNode(text: "😑")
    }
    
    
}

PlaygroundPage.current.liveView = ARSKSceneViewController()
