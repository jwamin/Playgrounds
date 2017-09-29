//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

enum Triangles{
    case Equilateral
    case Isoceles
    case Scalene
    case RightAngle
    case Acute
    case Obtuse
}

class CGTriangle {
    
    private var A:CGPoint = CGPoint(x: 0, y: 0)
    private var B:CGPoint = CGPoint(x: 0, y: 0)
    private var C:CGPoint = CGPoint(x: 0, y: 0)
    
    private var la:CGFloat = 0.0
    private var lb:CGFloat = 0.0
    private var lc:CGFloat = 0.0
    
    private var aa:CGFloat = 0.0
    private var ab:CGFloat = 0.0
    private var ac:CGFloat = 0.0
    
    var longestSide:CGFloat = 0.0
    
    init(ia:CGPoint,ib:CGPoint,ic:CGPoint){
        A = ia
        B = ib
        C = ic
        
        recalculate()
        
    }
    
    func recalculate(){
        
        la = CGTriangle.distance(A, B)
        lb = CGTriangle.distance(B, C)
        lc = CGTriangle.distance(C, A)
        
        longestSide = max(la, lb)
        longestSide = max(longestSide,lc)
        
        aa = acos((pow(la, 2) + pow(lb, 2) - pow(lc, 2)) / (2 * la*lb))
        ab = acos((pow(lb, 2) + pow(lc, 2) - pow(la, 2)) / (2 * lb*lc))
        ac = acos((pow(lc, 2) + pow(la, 2) - pow(lb, 2)) / (2 * lc*la))
        
        print("\(CGTriangle.radToDegrees(aa)) + \(CGTriangle.radToDegrees(ab)) + \(CGTriangle.radToDegrees(ac)) = \(CGTriangle.radToDegrees(aa)+CGTriangle.radToDegrees(ab)+CGTriangle.radToDegrees(ac))")
        
    }
    
    func getPoints()->(CGPoint,CGPoint,CGPoint){
        return (A,B,C)
    }
    
    func getSides()->(CGFloat,CGFloat,CGFloat){
        return (la,lb,lc)
    }
    
    func getAngles()->(CGFloat,CGFloat,CGFloat){
        return (aa,ab,ac)
    }
    
    static func radToDegrees(_ radians:CGFloat)->CGFloat{
        return (radians * 180 / .pi) // = degrees
    }
    
    static func degreesToRadians(_ degrees:CGFloat)->CGFloat{
        
        return (.pi * degrees / 180)
        
    }
    
    static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    func returnTestPoint()->CGPoint{
        
        let x:CGFloat = longestSide * sin(.pi / 2) + A.x
        let y:CGFloat = longestSide * cos(.pi / 2) + A.y
        return CGPoint(x: x, y: y)
        
    }
    
}

class MyViewController : UIViewController {
    
    var triangles:[CGTriangle] = [CGTriangle]()
    
    override func viewDidLoad() {
        print("view loaded")
//        let pointA = CGPoint(x: 250, y: 250)
//        let pointB = CGPoint(x: 150, y: 200)
//        let pointC = CGPoint(x: 200, y: 200)

        let pointA = CGPoint(x: 375, y: 375)
        let pointB = CGPoint(x: 250, y: 200)
        let pointC = CGPoint(x: 300, y: 400)
        
        let myTriangle = CGTriangle(ia: pointA, ib: pointB, ic: pointC)
        triangles.append(myTriangle)
        print(myTriangle)
        
        let view = DrawView(frame: self.view.frame, triangles: triangles)
        view.backgroundColor = UIColor.black
        self.view = view
    }
    
    func appendTriangle(triangle:CGTriangle){
        self.triangles.append(triangle)
        view.setNeedsDisplay()
    }
    
    
    
}
// Present the view controller in the Live View window


class DrawView : UIView{

    var triangles:[CGTriangle] = [CGTriangle]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, triangles: [CGTriangle]) {
        super.init(frame: frame)
        self.clearsContextBeforeDrawing = true
        self.backgroundColor = UIColor.white
        self.triangles = triangles
    }
    
    func updateTriangles(triangles:[CGTriangle]){
        self.triangles = triangles
    }
    
    override func draw(_ rect: CGRect) {
        
        for triangle in triangles{
        
            let context = UIGraphicsGetCurrentContext()
            
            let points = triangle.getPoints()
            //context?.translateBy(x: points.0.x, y: points.0.y)
            let startPoint = points.0
            let midPoint = points.1
            let endPoint = points.2
            context?.beginPath()
            context?.move(to: startPoint)
            context?.addLine(to: midPoint)
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.setLineWidth(2)
            context?.closePath()
            context?.drawPath(using: .stroke)
            
            context?.beginPath()
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.setLineWidth(2)
            context?.move(to: midPoint)
            context?.addLine(to: endPoint)
            context?.closePath()
            context?.drawPath(using: .stroke)
            
            context?.beginPath()
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.setLineWidth(2)
            context?.move(to: endPoint)
            context?.addLine(to: startPoint)
            context?.closePath()
            context?.drawPath(using: .stroke)
            
            context?.setLineWidth(2)
            context?.setLineJoin(.round)
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.drawPath(using: .stroke)
            
            let startangle = CGFloat(-( Double.pi / 2))
            
            let sides = triangle.getSides()
            let firstDistance = sides.0
            let lastDistance = sides.2
            
            let radius = triangle.longestSide
            
            
            
            //Circle
            
           let circle = UIBezierPath(arcCenter: startPoint, radius: radius, startAngle: 0, endAngle: CGFloat(3 * Double.pi)/2, clockwise: true)
            circle.lineWidth = 2.0
            circle.stroke()
            
            let angles = triangle.getAngles()
            
            /**  Angle Arcs
             ------------------*/
            
            //Create angle arcs
            let arc = UIBezierPath()
            let arc2 = UIBezierPath()
            
            
            UIColor.white.setStroke()
            
            arc.addArc(withCenter: startPoint, radius: 10, startAngle:angles.0, endAngle:0, clockwise: false)
            arc.stroke()
            
//            let start = CGFloat(90 * Triangle.radians);
//            let end = CGFloat(start + CGFloat((triangle.aa) * Triangle.radians))
//
//            arc2.addArc(withCenter: startPoint, radius: 10, startAngle:CGFloat(90 * Triangle.radians), endAngle:end, clockwise: true)
//            arc2.stroke()
//
//            let arc3 = UIBezierPath()
//            arc3.addArc(withCenter: rightPoint, radius: 10, startAngle:CGFloat(Double.pi), endAngle:CGFloat((3*Double.pi)/2), clockwise: true)
//            arc3.stroke()
            
            //
            
            context?.move(to: startPoint)
            context?.setLineWidth(1)
            context?.addLine(to: triangle.returnTestPoint())
            context?.drawPath(using: .stroke)
            
            
            
            
            
        }
        
//        context?.setLineWidth(1.0)
//        context?.move(to: startPoint)
//        context?.addLine(to: <#T##CGPoint#>)
        
    }
    
}

let vc = MyViewController()

//let pointA = CGPoint(x: 550, y: 450)
//let pointB = CGPoint(x: 250, y: 200)
//let pointC = CGPoint(x: 300, y: 400)
//
//let newTriangle = CGTriangle(ia: pointA, ib: pointB, ic: pointC)
//
//vc.appendTriangle(triangle: newTriangle)

PlaygroundPage.current.liveView = vc.view
