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
    
    init(aa:CGPoint,ab:CGPoint,ac:CGPoint){
        A = aa
        B = ab
        C = ac
    }
    
    func getTriangle()->(CGPoint,CGPoint,CGPoint){
        return (A,B,C)
    }
    
}

class MyViewController : UIViewController {
    
    override func viewDidLoad() {
        print("view loaded")
        let pointA = CGPoint(x: 50, y: 50)
        let pointB = CGPoint(x: 50, y: 100)
        let pointC = CGPoint(x: 100, y: 50)
        
        let myTriangle = CGTriangle(aa: pointA, ab: pointB, ac: pointC)
        
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
        let points = triangle.getTriangle()

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
        
    }
    
}

let vc = MyViewController()

PlaygroundPage.current.liveView = vc.view
