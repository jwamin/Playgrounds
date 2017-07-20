import UIKit
import PlaygroundSupport

let TOTAL = 180
let EQANGLE = TOTAL / 3

enum triangleType {
    case isoceles
    case rightAngle
    case equilateral
    case other
}

class Triangle:Lengthupdator{
    
    var type:triangleType!
    
    func updateLength(updatedSide: Side) {
        print(updatedSide.length)
    }
    
    //Sides
    var h:Side?
    var o:Side?
    var a:Side?
    
    //Angles
    var ho:Angle?
    var oa:Angle?
    var ha:Angle?
    // maybe do angle manager to handle 180 overflow and readjustment from points and lengths
    
    //Points
    //var h:CGPoint?
    //var o:CGPoint?
    //var a:CGPoint?
    
    init(sideA:Float?,sideO:Float?,sideH:Float?){
        
        a = Side()
        o = Side()
        h = Side()
        
        ha = Angle(angle: 45)
        oa = Angle(angle: 90)
        ho = Angle(angle: 45)
        
        //delegation setup
        a?.delegate = self
        o?.delegate = self
        h?.delegate = self
        
        type = getTriangleType()
        
    }
    
    func getTriangleType()->triangleType {
        return .other
    }
    
    
    func printStats() {
        print(a?.length!,
              o?.length!,
              h?.length!,
              ho?.degrees!,
              oa?.degrees!,
              ha?.degrees!,
              ho?.checkIsRight(),
              oa?.checkIsRight(),
              ha?.checkIsRight()
        )
        
    }
    
    func update() {
        // angle moving adjust size of other angles
        //angle point adjust adjacent side lengths and updates angles with SOHCAHTOA
    }
    
}

protocol Lengthupdator {
    func updateLength(updatedSide:Side)
}

struct Side{
    var delegate:Lengthupdator?
    var square:Float?
    var length:Float?{
        didSet {
            print("err hello?")
            updateSquare()
            delegate?.updateLength(updatedSide: self)
        }
    }
    
    init(length:Float?=32){
        self.length = length
        print("initialised angle to \(self.length)")
    }
    
    mutating func updateSquare() {
        if let lengthAvailable = length {
            square = (lengthAvailable*lengthAvailable)
        } else {
            square = nil
        }
    }
    
}

struct Angle{
    
    private var isRight:Bool = false
    
    var degrees:Int?{
        willSet{
            print("will set")
        }
        didSet{
            print("err hello from angle")
            if (degrees! == 90) {
                self.isRight = true
                print("right angle")
            }
        }
    }
    
    init(angle:Int? = EQANGLE){
        print(angle)
        degrees = angle
        print(degrees)
        print("initialised angle to \(degrees)")
    }
    
    func checkIsRight()->Bool {
        return isRight
    }
    
}



var mytriangle = Triangle(sideA: nil, sideO: nil, sideH: nil)

mytriangle.a?.length = 48
mytriangle.oa?.degrees = 90

mytriangle.printStats()

let view = UIView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
view.backgroundColor = UIColor.white

var A = CGPoint(x: 20, y: 20)
var B = CGPoint(x: 20, y: 200)
var C = CGPoint(x: 100, y: 200)

//var point = UIView(frame: CGRect(origin: A, size: CGSize(width: 20, height: 20)))
//point.backgroundColor = UIColor.red
//point.center = A
//point.layer.cornerRadius = 10
//view.addSubview(point)

var layer = CAShapeLayer()

    // brush up on Core Graphics
var path = CGMutablePath();
var ipath = CGPath(ellipseIn: CGRect(x: 20, y: 20, width: 50, height: 100), transform: nil)
path.move(to: A)
var ellayer = CAShapeLayer()
ellayer.path = ipath
ellayer.lineJoin = kCALineCapRound
ellayer.fillColor = UIColor.green.cgColor
ellayer.strokeColor = UIColor.blue.cgColor
ellayer.opacity = 0.2
//CGPathMoveToPoint(path, NULL,10, 100);
//CGPathAddLineToPoint(path, NULL,100,10);
path.addLine(to: B)
path.addLine(to: C)
//CGPathAddLineToPoint(path, NULL,200,100);
//CGPathAddLineToPoint(path, NULL,100,100);
//CGPathCloseSubpath(path);
path.closeSubpath()
layer.path = path
//let context = UIGraphicsGetCurrentContext()
//context?.addPath(path)
layer.lineWidth = 1.0
layer.strokeColor = UIColor.blue.cgColor
layer.fillColor = UIColor.red.cgColor
layer.backgroundColor = UIColor.black.cgColor
layer.setAffineTransform(CGAffineTransform(rotationAngle:50.0))
//CGContextSetFillColorWithColor(context, white);
//CGContextAddPath(context, path);
//CGContextFillPath(context);

view.layer.addSublayer(layer)
view.layer.addSublayer(ellayer)
view.setNeedsDisplay()

PlaygroundPage.current.liveView = view

//print((mytriangle.oa?.checkIsRight())! ? "angle is right" : "not right angle")

//print("hello, world")





