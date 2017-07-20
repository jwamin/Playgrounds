//: Playground - noun: a place where people can play

import UIKit
import SceneKit
import PlaygroundSupport

//var str = "Hello, playground"

//Create SKScene and View
let skscene:SCNScene = SCNScene()
let skView:SCNView = SCNView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
skView.allowsCameraControl = true
skView.scene = skscene

//Create Text Node
let textGeo = SCNText(string: "hello, world!!", extrusionDepth: 4.0)

    textGeo.font = UIFont(name: "Helvetica", size: 12)
    textGeo.firstMaterial?.diffuse.contents  = UIColor.red.cgColor
    textGeo.firstMaterial?.specular.contents = UIColor.white.cgColor
    textGeo.firstMaterial?.shininess = 72.0
let node = SCNNode(geometry: textGeo)

//node.position = SCNVector3Make(0, 0, 0)

//Add Node (geometry and material to scene)
skscene.rootNode.addChildNode(node)

//General Ambient Lighting
let ambientLightNode = SCNNode()
ambientLightNode.light = SCNLight()
ambientLightNode.light!.type = .ambient
ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
skscene.rootNode.addChildNode(ambientLightNode)

//add spotlight for shinyness
let spotLightNode = SCNNode()
spotLightNode.light = SCNLight()
spotLightNode.light!.type = .spot
spotLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
spotLightNode.light!.castsShadow = true
spotLightNode.position = SCNVector3Make(-5, 0, 50)

skscene.rootNode.addChildNode(spotLightNode)

//create our own camera
let cameraNode = SCNNode()
cameraNode.camera = SCNCamera()
cameraNode.position = SCNVector3Make(0,0,75)
skscene.rootNode.addChildNode(cameraNode)

//make this our camera
skView.pointOfView = cameraNode

//Set pivot point, animates around center of bounding box
let x = (node.boundingBox.max.x - node.boundingBox.min.x) / 2
let y = (node.boundingBox.max.y - node.boundingBox.min.y) / 2
let z = (node.boundingBox.max.z - node.boundingBox.min.z) / 2

//sets pivot point
node.pivot = SCNMatrix4MakeTranslation(x, y, z)

//sets animation to rotate y angle linearly
node.rotation = SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: 0.0)
let spin = CABasicAnimation(keyPath: "rotation.w") // only animate the angle
spin.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
spin.toValue = 2.0*Double.pi
spin.duration = 2
spin.repeatCount = HUGE // for infinity
node.addAnimation(spin, forKey: "spin around") 

//A
PlaygroundPage.current.liveView = skView
