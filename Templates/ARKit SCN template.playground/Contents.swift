import UIKit
import ARKit
import PlaygroundSupport

class ARView : UIViewController, ARSCNViewDelegate  {
    
    var arsceneview:ARSCNView!
    var scene:SCNScene?
    var pointerDot:UIView!
    var pointerPosition:CGPoint!
    var thisIsAHit:Bool = false
    
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
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        scene = SCNScene()
        
        arsceneview = ARSCNView(frame: self.view.bounds)
        arsceneview.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        arsceneview?.session.run(config, options: .removeExistingAnchors)
        arsceneview?.scene = scene!
        
        
        arsceneview?.delegate = self
        
        self.view = arsceneview
        
        pointerDot = UIView(frame: 
            CGRect(x: 0, y: 0, width: 10, height: 10)
        )
        //pointerDot.alpha = 0.3
        pointerDot.backgroundColor = UIColor.yellow
        pointerDot.autoresizingMask = [.flexibleBottomMargin,.flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin]
        
        let effect = UIBlurEffect(style: .regular)
        
        let buttonContainer = UIVisualEffectView(effect: effect)
        buttonContainer.frame = (CGRect(x: 0, y: 0, width: 60, height: 60))
        let label = UIButton(frame: buttonContainer.frame)
        label.setTitle("⭕️", for: .normal)
        buttonContainer.contentView.addSubview(label)
        label.autoresizingMask = [.flexibleBottomMargin,.flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin]
        
        label.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        //buttonContainer.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin]
        
        arsceneview.addSubview(buttonContainer)
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([buttonContainer.widthAnchor.constraint(equalToConstant: 60),buttonContainer.heightAnchor.constraint(equalToConstant: 60)])
        
        
        let x = NSLayoutConstraint(item: arsceneview, attribute: .trailing, relatedBy: .equal, toItem: buttonContainer, attribute: .trailing, multiplier: 1.0, constant: 10.0)
        let y = NSLayoutConstraint(item: arsceneview, attribute: .bottom, relatedBy: .equal, toItem: buttonContainer, attribute: .bottom, multiplier: 1.0, constant: 10.0)
        
        //NSLayoutConstraint(item: buttonContainer, attribute: .centerY, relatedBy: .equal, toItem: arsceneview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        //NSLayoutConstraint(item: buttonContainer, attribute: .centerX, relatedBy: .equal, toItem: arsceneview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        
        NSLayoutConstraint.activate([x,y])
        
        
        
        
        print(buttonContainer.constraints)
        
        //pointerDot.translatesAutoresizingMaskIntoConstraints = false
        
        //NSLayoutConstraint(item: pointerDot, attribute: .centerX, relatedBy: .equal, toItem: arsceneview, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        //NSLayoutConstraint(item: pointerDot, attribute: .centerY, relatedBy: <#T##NSLayoutRelation#>, toItem: <#T##Any?#>, attribute: <#T##NSLayoutAttribute#>, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
        
        //pointerDot.center.x = (arsceneview?.center.x)!/2
        
        //pointerDot.center.y = (arsceneview?.center.y)!/2
        
        
        
        
        
        //pointerPosition = pointerDot.center
        //pointerDot.frame.y = arsceneview?.center.y - (pointerDot.frame.height/2)
        arsceneview?.addSubview(pointerDot)
        
    }
    
    @objc func buttonPressed(_ sender:Any){
    print("buttonPressed")
        
        if(thisIsAHit){
             let gothit = arsceneview.hitTest(pointerPosition, types: [])
            
            if gothit.count == 0 {
                return
            }
            
            print(gothit)
            
        }
        
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        
        
        
            
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        if let positionThing = pointerDot {
            
            let results = arsceneview.hitTest(pointerDot.center, options: nil)
            
            guard let result = results.first else { 
                print("no hit")
                //pointerview.backgroundColor = UIColor.yellow; 
                
                DispatchQueue.main.async {
                    
                    if(self.thisIsAHit != false){
                        self.thisIsAHit=false
                    }
                    
                    self.pointerDot.backgroundColor = UIColor.yellow
                    
                }
                
                print(pointerDot.backgroundColor)
                return;
            }
            
            
            print("got hit")
            
            //pointerPosition = pointerDot.center
            //if(self.thisIsAHit != true){
            //self.thisIsAHit = true
            //}
            
            
            DispatchQueue.main.async {
                self.pointerDot.backgroundColor = UIColor.green
            }
            
            
            print(pointerDot.backgroundColor)
        } else {
            print("no dot")
        }
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("heloo:")
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        //fix this up to add 2d control sprites
        
        let rect = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
        
        let sprite = CAShapeLayer()
        sprite.backgroundColor = UIColor.black.cgColor
        sprite.path = CGPath(rect: rect, transform: nil)
        
        
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        box.materials.first?.diffuse.contents = UIColor.white.cgColor
        //let mynode = SCNNode(geometry: box)
        let mynode = SCNNode(geometry:box )
        mynode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        node.addChildNode(mynode)
        
    }
    
    
}

let arvc = ARView()

PlaygroundPage.current.liveView = arvc
