//: Playground - noun: a place where people can play

import UIKit
import SceneKit
import PlaygroundSupport

//Establish Scene, frame, view
var scnScene = SCNScene()
var frame = CGRect(x: 0, y: 0, width: 640, height: 480)
var skview = SCNView(frame: frame, options: nil)

//Crrate geometry with material
var geo = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)

//set color of geometry
var tex = SCNMaterial()
//tex.lightingModel = .physicallyBased
tex.diffuse.contents = UIColor.red.cgColor
geo.firstMaterial = tex

//attach geometry to node
var node = SCNNode(geometry: geo)
node.position = SCNVector3.init(0.0, 0.0, 3.0)

//create custom omnidirectional light
var light = SCNLight()
light.type = .omni
light.color = UIColor(white: 0.75, alpha: 1.0)
light.castsShadow = true
light.intensity = 2000.0
var lightnode = SCNNode()
lightnode.light = light
lightnode.position = SCNVector3.init(0, 0, 0)

//Creat custom camera
let cameraNode = SCNNode()
cameraNode.camera = SCNCamera()
cameraNode.position = SCNVector3.init(0, 0, 6.0)
scnScene.rootNode.addChildNode(cameraNode)


//define and apply rotation around center animation
let orbitAnimation = CABasicAnimation(keyPath: "rotation")
orbitAnimation.fromValue = SCNVector4.init(0.0, 0.0, 0.0, 0.0)
orbitAnimation.toValue = SCNVector4.init(0.0, 1.0, 0.0, Double.pi*2)
orbitAnimation.duration = 10
orbitAnimation.repeatCount = .infinity

//define and apply box animation (Z axis rotation)
let rotationZ = CABasicAnimation(keyPath: "rotation")
rotationZ.fromValue = SCNVector4.init(0.0, 0.0, 0.0, 0.0)
rotationZ.toValue = SCNVector4.init(0.0, 0.0, 1.0, Double.pi)
rotationZ.duration = 2.5
rotationZ.repeatCount = .infinity

//Add orbit animation to lightnode
lightnode.addAnimation(orbitAnimation, forKey: "rotation")

//add z axis animation to  geometry node
node.addAnimation(rotationZ, forKey: "rotationZ")

//add light node to scene
scnScene.rootNode.addChildNode(lightnode)
//CRUCIALLY, add geometry node as child of lightnode
lightnode.addChildNode(node)
//rotation animation applies but tethered, causing circular orbit around parent node

skview.backgroundColor = UIColor.black
skview.allowsCameraControl = true;
skview.scene = scnScene

PlaygroundPage.current.liveView = skview
