//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
var str = "Hello, playground"

/*
 SOH sin = opp / hyp
 CAH cos = adj / hyp
 TOA tan = opp / adj
 */

class Triangle {
    
    var o:Float,a:Float,h:Float
    let rightAngle:Float = 90.0;
    
    var oa:Float?,aa:Float?
    var area:Float?
    var sum:Float?
    
    var view:DrawView?
    
    init(opposite:Float,adjacent:Float) {
        o = opposite
        a = adjacent
        h = Triangle.doHyp(o: o, a: a)
        
    }
    
    static func doHyp(o:Float,a:Float)->Float{
        let h2 = pow(o, 2) + pow(a,2)
        return sqrt(h2)
    }
    
    static func radToDegrees(_ degrees:Float)->Float{
        return (degrees * 180 / .pi)
    }
    
    func recalculate(){
        
        area = o * a / 2
        
        oa = Triangle.radToDegrees(asin(o / h))
        aa = Triangle.radToDegrees(atan(a / o))
        
        sum = oa! + aa! + rightAngle
        
        view = DrawView(frame: CGRect(x: 0, y: 0, width: 640, height: 480),triangle: self)
        view!.backgroundColor = UIColor.white
    }
    
}

class DrawView : UIView{
    
    var triangle:Triangle!
    
    init(frame: CGRect, triangle: Triangle) {
        super.init(frame: frame)
        self.triangle = triangle
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let opath = UIBezierPath()
        let apath = UIBezierPath()
        let hpath = UIBezierPath()
        let startPoint = CGPoint(x: self.frame.width/2, y: frame.height/4)
        var rightPoint = startPoint
        rightPoint.y += CGFloat(triangle.o)
        var thetapoint = rightPoint
        thetapoint.x -= CGFloat(triangle.a)
        
        let squarePoint = CGPoint(x: thetapoint.x, y: startPoint.y)
        
        print("\(squarePoint.y) \(thetapoint.y)")
        
        let yHalf:CGFloat = (thetapoint.y - squarePoint.y) / 2
        
        let xHalf:CGFloat = (startPoint.x - squarePoint.x) / 2
        
        let centerpoint = CGPoint(x: squarePoint.x + xHalf, y: squarePoint.y + yHalf)
        let cgRect = CGRect(x: startPoint.x-5.0, y: startPoint.y-5.0, width: 10, height: 10)
        let squareRect = CGRect(x: squarePoint.x-5.0, y: squarePoint.y-5.0, width: 10, height: 10)
        
        context?.setFillColor(UIColor.yellow.cgColor)
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.fill(cgRect)
        context?.stroke(cgRect)
        context?.setFillColor(UIColor.cyan.cgColor)
        context?.fill(squareRect)
        context?.stroke(squareRect)
        
        opath.move(to: startPoint)
        apath.move(to: rightPoint)
        hpath.move(to: thetapoint)
        
        opath.addLine(to: rightPoint)
        apath.addLine(to: thetapoint)
        hpath.addLine(to: startPoint)
        
        opath.lineWidth = 2.0
        opath.lineCapStyle = .round
        
        apath.lineWidth = 2.0
        apath.lineCapStyle = .round
        
        hpath.lineWidth = 2.0
        hpath.lineCapStyle = .round
        
        UIColor.red.setStroke()
        opath.stroke()
        
        UIColor.blue.setStroke()
        apath.stroke()
        
        UIColor.green.setStroke()
        hpath.stroke()
        
        let oLabel = UILabel()
        oLabel.text = "opposite"
        oLabel.frame = CGRect(origin: startPoint,
                              size:CGSize(width: 100, height: rightPoint.y - startPoint.y)
        )
        oLabel.frame.origin.x += 5.0
        oLabel.textColor = UIColor.black
        self.addSubview(oLabel)
        
        let aLabel = UILabel()
        aLabel.text = "adjacent"
        aLabel.frame = CGRect(origin: rightPoint,
                              size:CGSize(width: thetapoint.x - rightPoint.x, height: 20)
        )
        aLabel.textAlignment = .center
        aLabel.textColor = UIColor.black
        
        self.addSubview(aLabel)
        
        let radians:Float = Float(Double.pi / 180);
        print(radians)
        let angleRadians:CGFloat = CGFloat((360 - myTriangle.oa!) * radians)
        print(angleRadians)
        
        var labelPoint = centerpoint
        labelPoint.x -= (CGFloat(triangle.h) / 2) + 15
        labelPoint.y -= 15
        let hLabel = UILabel()
        hLabel.text = "hypotenuse"
        hLabel.frame = CGRect(origin: labelPoint,
                              size:CGSize(width: CGFloat(triangle.h), height: 20)
        )
        hLabel.textAlignment = .center
        
        //hLabel.layer.anchorPoint = centerpoint
        
        hLabel.transform = CGAffineTransform(rotationAngle: angleRadians)
        
        //hLabel.backgroundColor = UIColor.cyan
        hLabel.textColor = UIColor.black
        self.addSubview(hLabel)
        
        let arc = UIBezierPath()
        UIColor.black.setStroke()
        print(myTriangle.oa!)
        arc.addArc(withCenter: thetapoint, radius: 10, startAngle:angleRadians, endAngle:0, clockwise: true)
        arc.stroke()
        
        let centerRect = CGRect(x: centerpoint.x-5.0, y: centerpoint.y-5.0, width: 10, height: 10)
        context?.setFillColor(UIColor.green.cgColor)
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.fill(centerRect)
        context?.stroke(centerRect)
        
        
    }
}

var myTriangle = Triangle(opposite: 200, adjacent: 200)
myTriangle.recalculate()
print(myTriangle.rightAngle,myTriangle.oa!,myTriangle.aa!,myTriangle.sum!,"area = \(myTriangle.area!)")
PlaygroundPage.current.liveView = myTriangle.view