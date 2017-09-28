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
    
    init(ia:CGPoint,ib:CGPoint,ic:CGPoint){
        A = ia
        B = ib
        C = ic
        
        recalculate()
        
    }
    
    func recalculate(){
        
        la = distance(A, B)
        lb = distance(B, C)
        lc = distance(C, A)
        
        aa = 0.0
        ab = 0.0
        ac = 0.0
        
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
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
}

class MyViewController : UIViewController {
    
    override func viewDidLoad() {
        print("view loaded")
        let pointA = CGPoint(x: 250, y: 250)
        let pointB = CGPoint(x: 150, y: 200)
        let pointC = CGPoint(x: 200, y: 200)
        
        let myTriangle = CGTriangle(ia: pointA, ib: pointB, ic: pointC)
        
        print(myTriangle)
        
        let view = DrawView(frame: self.view.frame, triangle: myTriangle)
        view.backgroundColor = UIColor.black
        self.view = view
    }
    

}
// Present the view controller in the Live View window


class DrawView : UIView{

    var triangle:CGTriangle!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(frame: CGRect, triangle: CGTriangle) {
        super.init(frame: frame)
        self.clearsContextBeforeDrawing = true
        self.backgroundColor = UIColor.white
        self.triangle = triangle
    }
    

    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        let points = triangle.getPoints()

        let startPoint = points.0
        let midPoint = points.1
        let endPoint = points.2

        context?.move(to: startPoint)
        context?.addLine(to: midPoint)
        context?.addLine(to: endPoint)
        context?.addLine(to: startPoint)
        context?.closePath()
        context?.setLineWidth(2)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.drawPath(using: .stroke)
        
        let startangle = CGFloat(-( Double.pi / 2))
        
        let sides = triangle.getSides()
        let firstDistance = sides.0
        let lastDistance = sides.2
        
        var radius = (firstDistance > lastDistance) ? sides.0 : sides.2
        
       let circle = UIBezierPath(arcCenter: startPoint, radius: radius, startAngle: startangle, endAngle: CGFloat(CGFloat(2 * Double.pi) + startangle), clockwise: true)
        
        circle.stroke()
        
//        context?.setLineWidth(1.0)
//        context?.move(to: startPoint)
//        context?.addLine(to: <#T##CGPoint#>)
        
    }
    
}

let vc = MyViewController()

PlaygroundPage.current.liveView = vc.view
