import UIKit
import SceneKit
import simd
import GLKit
import PlaygroundSupport

class MyView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.cyan
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MyScene : SCNScene{
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ViewController : UIViewController {
    
    var frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    
    var scene:SCNScene!
    var degreeAngle:Float = 0.0
    
    var node:SCNNode!
    var subnode:SCNNode!
    
    var link:CADisplayLink!
    
    var startPoint:SCNVector3!
    
    override func loadView(){
        //view = MyView(frame: frame)
        scene = MyScene()
        let thisView = SCNView(frame: frame)
        
        let geo = SCNSphere(radius: 2)
        let secondSphere = SCNSphere(radius: 0.1)
        
        subnode = SCNNode(geometry: secondSphere)
        secondSphere.materials.first?.diffuse.contents = UIColor.blue.cgColor
        
        geo.materials.first?.diffuse.contents = UIColor.darkGray.cgColor
        
        node = SCNNode(geometry: geo)
        node.addChildNode(subnode)
        
        subnode.position = SCNVector3Make(0.0, 0.0, 2.0)
        
        
        
        //let neworientation = SCNQuaternion([0.0,0.0,0.0,1.0])
        
        scene.rootNode.addChildNode(node)
        scene.background.contents = UIColor.gray.cgColor
        thisView.scene = scene
        thisView.autoenablesDefaultLighting = true
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 6)
        
        let light = SCNLight()
        light.type = .omni
        light.intensity = 100
        
        let omnilight = SCNLight()
        omnilight.type = .ambient
        
        scene.rootNode.light = omnilight
        
        let lightNode = SCNNode()
        //lightNode.light = light
        lightNode.position = SCNVector3(3.0,3.0,-3.0)
        scene.rootNode.addChildNode(lightNode)
        
        scene.rootNode.addChildNode(cameraNode)
        thisView.pointOfView = cameraNode
        thisView.allowsCameraControl = true
        
        view = thisView
        
        startPoint = subnode.position
        
    }
    
    override func viewDidLoad() {
        print("view loaded")
        link = CADisplayLink(target: self, selector: #selector(update))
        link.preferredFramesPerSecond = 60
        link.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //degreeAngle = 0
        //let orientation = node.orientation
        
        //let orientation = subnode.orientation
        
        
//          let animation = CABasicAnimation(keyPath: "position")
//          animation.fromValue = subnode.position
//          animation.toValue = vector
//          animation.duration = 2.0
//          animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
//          animation.fillMode = kCAFillModeForwards
//          
//          //subnode.position = vector
        
//          CATransaction.begin()
//          CATransaction.disableActions()
//          subnode.addAnimation(animation, forKey: nil)
//          CATransaction.setCompletionBlock( { 
//              self.subnode.position = vector
//          })
//          CATransaction.commit()

        
    }
    
    @objc func update(){
        
        if(degreeAngle<90){
            degreeAngle += 1.0
        } else {
            degreeAngle = 0
        }
        
        print(degreeAngle)
        let angle = GLKMathDegreesToRadians(degreeAngle)
        
        let q1 = simd_quatf(angle:angle,axis:simd_float3(1.0,0.0,0.0))
        
        let q2 = simd_quatf(angle:angle,axis:simd_float3(0,1.0,0.0))
        
        let finalRotation = q1 * q2 
        
        let resolved = finalRotation.act(simd_float3(startPoint))
        
        let vector = SCNVector3(resolved)
        print(subnode.position,vector)
        
        subnode.position = vector
        
        
    }
    
    
}


let viewC = ViewController()
//viewC.loadView()

PlaygroundPage.current.liveView = viewC
