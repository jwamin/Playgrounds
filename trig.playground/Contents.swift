//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
var str = "Hello, playground"

/*
 SOH sin(theta) = opp / hyp (asin for angle)
 CAH cos(theta) = adj / hyp (acos for angle)
 TOA tan(theta) = opp / adj (atan for angle)
 */

class ViewController:UIViewController{
    
    var myTriangle:Triangle!
    
    override func viewDidLoad() {
        
        myTriangle = Triangle(opposite: 134, adjacent: 250)
        
        self.view = DrawView(frame: self.view.frame, triangle: myTriangle)

        myTriangle.recalculate()
        
        //create sliders
        
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 20 ))
        slider.maximumValue = 500
        slider.minimumValue = 10
        slider.tag = 1
        slider.value = myTriangle.o
        slider.addTarget(self, action: #selector(updateDimension), for: UIControlEvents.valueChanged)
        self.view.addSubview(slider)
        
        let slider2 = UISlider(frame: CGRect(x: 0, y: 100, width: 200, height: 20))
            slider2.maximumValue = 500
            slider2.minimumValue = 10
            slider2.value = myTriangle.a
            slider2.tag = 2
            slider2.addTarget(self, action: #selector(updateDimension), for: UIControlEvents.valueChanged)
            self.view.addSubview(slider2)
    }
    
    
    @objc func updateDimension(sender:Any){
        let slider = sender as! UISlider
        
        switch (slider.tag){
        case 1:
            myTriangle.o = slider.value
        case 2:
            myTriangle.a = slider.value
        default:
            print("issue")
        }
        
            view.setNeedsDisplay()
        
    }
    

    
}

enum Triangles{
    case Equilateral
    case Isoceles
    case Scalene
    case RightAngle
    case Acute
    case Obtuse
}

class CGTriangle{
    
    var A:CGPoint = CGPoint(x: 0, y: 0)
    var B:CGPoint = CGPoint(x: 0, y: 0)
    var C:CGPoint = CGPoint(x: 0, y: 0)
    
    init(a:CGPoint,b:CGPoint,c:CGPoint){
        A = a
        B = b
        C = c
    }
}


class Triangle {
    
    var o:Float{
        didSet{
            self.recalculate()
        }
    }
    var a:Float{
        didSet{
            self.recalculate()
        }
    }

    var h:Float = 0
    
    static let rightAngle:Float = 90.0;
    
    var oa:Float = 0,aa:Float = 0
    var oaRad:Float = 0,aaRad:Float = 0
    var mid:Float = 0
    var area:Float = 0
    var sum:Float = 0
    
    static let radians:Float = Float(Double.pi / 180);
    
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
        
        oa = Triangle.radToDegrees(asin(o / h))
        aa = Triangle.radToDegrees(atan(a / o))
        
        mid = 180 - oa - aa
        
        if(mid != Triangle.rightAngle){
            print("obtuse triangle, \(mid)")
            let midTest = mid / 2
            print(midTest+Triangle.rightAngle+oa)
            print(midTest+Triangle.rightAngle+aa)
            return
        } else {
            area = o * a / 2
            h = Triangle.doHyp(o: o, a: a)
            
            oaRad = oa * Triangle.radians
            aaRad = aa * Triangle.radians
            sum = oa + aa + mid
        }
    
        

        
            print(mid,oa,aa,sum,"area = \(area)")
        
        
        
    }
    
}

class DrawView : UIView{
    
    var triangle:Triangle!
    
    let debug = true;
    
    var angleLabel:UILabel = UILabel(), angle2Label:UILabel = UILabel(), angle3Label:UILabel = UILabel(), oLabel:UILabel = UILabel(), aLabel:UILabel = UILabel(), hLabel:UILabel = UILabel()
    
    init(frame: CGRect, triangle: Triangle) {
        super.init(frame: frame)
        self.clearsContextBeforeDrawing = true
        self.backgroundColor = UIColor.white
        self.triangle = triangle
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func clearLabels(){
        let views = self.subviews
        
        for view in views{
            //is keyword, really cool IsKindOfClass in Swift!
            if view is UILabel {
                let label = view as! UILabel
                label.text = nil
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        

        //establish context
        let context = UIGraphicsGetCurrentContext()

        // Create paths, separate one for each color
        let opath = UIBezierPath()
        let apath = UIBezierPath()
        let hpath = UIBezierPath()
        
        //Points of triangle
        let startPoint = CGPoint(x: self.frame.width/2, y: frame.height/4)
        
        var rightPoint = startPoint
        rightPoint.y += CGFloat(triangle.o)
        
        var thetaPoint = rightPoint
        thetaPoint.x -= CGFloat(triangle.a)
        
        
        //Debug Points
        let squarePoint = CGPoint(x: thetaPoint.x, y: startPoint.y)
        
        let yHalf:CGFloat = (thetaPoint.y - squarePoint.y) / 2
        
        let xHalf:CGFloat = (startPoint.x - squarePoint.x) / 2
        
        let centerpoint = CGPoint(x: squarePoint.x + xHalf, y: squarePoint.y + yHalf)
        let cgRect = CGRect(x: startPoint.x-5.0, y: startPoint.y-5.0, width: 10, height: 10)
        let squareRect = CGRect(x: squarePoint.x-5.0, y: squarePoint.y-5.0, width: 10, height: 10)
        
        if debug {
            context?.setFillColor(UIColor.yellow.cgColor)
            context?.setLineWidth(2.0)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.fill(cgRect)
            context?.stroke(cgRect)
            context?.setFillColor(UIColor.cyan.cgColor)
            context?.fill(squareRect)
            context?.stroke(squareRect)
        }

        //Draw Lines
        opath.move(to: startPoint)
        apath.move(to: rightPoint)
        hpath.move(to: thetaPoint)
        
        opath.addLine(to: rightPoint)
        apath.addLine(to: thetaPoint)
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
        
        
        clearLabels()
        
        //oLabel = UILabel()
        oLabel.text = "opposite"
        oLabel.frame = CGRect(origin: startPoint,
                              size:CGSize(width: 100, height: rightPoint.y - startPoint.y)
        )
        oLabel.frame.origin.x += 5.0
        oLabel.textColor = UIColor.black
        
        
        //aLabel = UILabel()
        aLabel.text = "adjacent"
        aLabel.frame = CGRect(origin: rightPoint,
                              size:CGSize(width: thetaPoint.x - rightPoint.x, height: 20)
        )
        aLabel.textAlignment = .center
        aLabel.textColor = UIColor.black
        
        
        
        //Calculate angle with radians
        let angleRadians:CGFloat = CGFloat((360 - triangle.oa) * Triangle.radians)

        
        //calculate lable starting point for rotation around center
        var labelPoint = centerpoint
        labelPoint.x -= (CGFloat(triangle.h) / 2) + 15
        labelPoint.y -= 15
        
        //Create hypotenuse label
        //hLabel = UILabel()
        hLabel.text = "hypotenuse"
        hLabel.frame = CGRect(origin: labelPoint,
                              size:CGSize(width: CGFloat(triangle.h), height: 20))
        hLabel.textAlignment = .center
        
        //rotate label by angle so it hugs the long edge on render
        hLabel.transform = CGAffineTransform(rotationAngle: angleRadians)
        hLabel.textColor = UIColor.black
        
        
        /**  Angle Arcs
         ------------------*/
        
        //Create angle arcs
        let arc = UIBezierPath()
        let arc2 = UIBezierPath()
        
        
        UIColor.black.setStroke()
        
        arc.addArc(withCenter: thetaPoint, radius: 10, startAngle:angleRadians, endAngle:0, clockwise: true)
        arc.stroke()
        
        let start = CGFloat(90 * Triangle.radians);
        let end = CGFloat(start + CGFloat((triangle.aa) * Triangle.radians))
        
        arc2.addArc(withCenter: startPoint, radius: 10, startAngle:CGFloat(90 * Triangle.radians), endAngle:end, clockwise: true)
        arc2.stroke()
        
        let arc3 = UIBezierPath()
        arc3.addArc(withCenter: rightPoint, radius: 10, startAngle:CGFloat(Double.pi), endAngle:CGFloat((3*Double.pi)/2), clockwise: true)
        arc3.stroke()
        
        /**  Labels
         ------------------*/
        
        //Create angle labels
        let angleFont = UIFont(name: "Helvetica Neue", size: 11.0)
        let angleRect = CGRect(origin: thetaPoint,
                               size:CGSize(width: 30, height: 20))
        
        angleLabel.font = angleFont
        angleLabel.text = String(Int(round(triangle.oa)))+"°"
        angleLabel.frame = angleRect
        angleLabel.textAlignment = .center
        
        angle2Label.font = angleFont
        angle2Label.text = String(Int(round(triangle.aa)))+"°"
        angle2Label.frame = angleRect
        angle2Label.frame.origin = startPoint
        angle2Label.textAlignment = .center
        
        angle3Label.font = angleFont
        angle3Label.text = String(Int(round(Triangle.rightAngle)))+"°"
        angle3Label.frame = angleRect
        angle3Label.frame.origin = rightPoint
        angle2Label.textAlignment = .center
        
        if debug {
            let centerRect = CGRect(x: centerpoint.x-5.0, y: centerpoint.y-5.0, width: 10, height: 10)
            context?.setFillColor(UIColor.green.cgColor)
            context?.setLineWidth(2.0)
            context?.setStrokeColor(UIColor.black.cgColor)
            context?.fill(centerRect)
            context?.stroke(centerRect)
        }
        
        //add Labels
        self.addSubview(oLabel)
        self.addSubview(hLabel)
        self.addSubview(aLabel)
        self.addSubview(angleLabel)
        self.addSubview(angle2Label)
        self.addSubview(angle3Label)

        //Create arithmetic label
        let arithLabel = UILabel()
        
        
        arithLabel.text = "\(String(Int(round(triangle.oa))))° + \(String(Int(round(triangle.aa))))° + \(String(Int(round(Triangle.rightAngle))))° = \(String(Int(triangle.sum)))°"
        
        arithLabel.frame = CGRect(origin: thetaPoint,
                                  size:CGSize(width: Int(triangle.a), height: 20))
        
        arithLabel.frame.origin.y += CGFloat(100.0)
        arithLabel.textAlignment = .center
        self.addSubview(arithLabel)
        
    }
}

let vc = ViewController()

PlaygroundPage.current.liveView = vc.view

let brokenTriangle = Triangle(opposite: 34, adjacent: 56)
brokenTriangle.recalculate()
