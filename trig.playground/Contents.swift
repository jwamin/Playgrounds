//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
var str = "Hello, playground"

/*
 SOH sin = opp / hyp
 CAH cos = adj / hyp
 TOA tan = opp / adj
 */

class ViewController:UIViewController{
    
    var myTriangle:Triangle!
    
    override func viewDidLoad() {
        myTriangle = Triangle(opposite: 134, adjacent: 250)
        
        self.view = DrawView(frame: self.view.frame, triangle: myTriangle)
        print(self.view.clearsContextBeforeDrawing)
        myTriangle.recalculate()
        print(myTriangle.rightAngle,myTriangle.oa!,myTriangle.aa!,myTriangle.sum!,"area = \(myTriangle.area!)")
        
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 200, height: 20 ))
        slider.maximumValue = 500
        slider.minimumValue = 10
        slider.addTarget(self, action: #selector(updateOpposite), for: UIControlEvents.valueChanged)
        self.view.addSubview(slider)
        
        let slider2 = UISlider(frame: CGRect(x: 0, y: 100, width: 200, height: 20))
            slider2.maximumValue = 500
            slider2.minimumValue = 10
            slider2.addTarget(self, action: #selector(updateAdj), for: UIControlEvents.valueChanged)
            self.view.addSubview(slider2)
    }
    
    
    func updateOpposite(sender:Any){
        let slider = sender as! UISlider
        
        
            myTriangle.o = slider.value
            view.setNeedsDisplay()
        
        
        
        
    }
    
    func updateAdj(sender:Any){
        let slider = sender as! UISlider
        
        
        myTriangle.a = slider.value
        
        
        view.setNeedsDisplay()
        
        
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
    var h:Float{
        didSet{
            self.recalculate()
        }
    }
    let rightAngle:Float = 90.0;
    
    var oa:Float?,aa:Float?
    var area:Float?
    var sum:Float?
    
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
        
        area = o * a / 2
        
        oa = Triangle.radToDegrees(asin(o / h))
        aa = Triangle.radToDegrees(atan(a / o))
        
        sum = oa! + aa! + rightAngle
        
    }
    
}

class DrawView : UIView{
    
    var triangle:Triangle!
    let debug = false;
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
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        clearLabels()

        
        //establish context
        let context = UIGraphicsGetCurrentContext()

        // Create paths
        let opath = UIBezierPath()
        let apath = UIBezierPath()
        let hpath = UIBezierPath()
        
        //Points on
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
        
        let oLabel = UILabel()
        oLabel.text = "opposite"
        oLabel.frame = CGRect(origin: startPoint,
                              size:CGSize(width: 100, height: rightPoint.y - startPoint.y)
        )
        oLabel.frame.origin.x += 5.0
        oLabel.textColor = UIColor.black
        
        
        let aLabel = UILabel()
        aLabel.text = "adjacent"
        aLabel.frame = CGRect(origin: rightPoint,
                              size:CGSize(width: thetaPoint.x - rightPoint.x, height: 20)
        )
        aLabel.textAlignment = .center
        aLabel.textColor = UIColor.black
        
        
        
        //Calculate angle with radians
        let angleRadians:CGFloat = CGFloat((360 - triangle.oa!) * Triangle.radians)

        
        //calculate lable starting point for rotation around center
        var labelPoint = centerpoint
        labelPoint.x -= (CGFloat(triangle.h) / 2) + 15
        labelPoint.y -= 15
        
        //Create hypotenuse label
        let hLabel = UILabel()
        hLabel.text = "hypotenuse"
        hLabel.frame = CGRect(origin: labelPoint,
                              size:CGSize(width: CGFloat(triangle.h), height: 20))
        hLabel.textAlignment = .center
        
        //rotate label by angle so it hugs the long edge on render
        hLabel.transform = CGAffineTransform(rotationAngle: angleRadians)
        hLabel.textColor = UIColor.black
        
        //Create angle arcs
        let arc = UIBezierPath()
        UIColor.black.setStroke()
        arc.addArc(withCenter: thetaPoint, radius: 10, startAngle:angleRadians, endAngle:0, clockwise: true)
        arc.stroke()
        
        let start = CGFloat(90 * Triangle.radians);
        let end = CGFloat(start + CGFloat(triangle.aa! * Triangle.radians))
        
        let arc2 = UIBezierPath()
        UIColor.black.setStroke()
        
        arc2.addArc(withCenter: startPoint, radius: 10, startAngle:CGFloat(90 * Triangle.radians), endAngle:end, clockwise: true)
        arc2.stroke()
        
        let arc3 = UIBezierPath()
        UIColor.black.setStroke()
        
        arc3.addArc(withCenter: rightPoint, radius: 10, startAngle:CGFloat(Double.pi), endAngle:CGFloat((3*Double.pi)/2), clockwise: true)
        arc3.stroke()
        
        
        //Create angle labels
        let angleLabel = UILabel()
        angleLabel.font = UIFont(name: "Helvetica Neue", size: 11.0)
        angleLabel.text = String(Int(round(triangle.oa!)))+"°"
        angleLabel.frame = CGRect(origin: thetaPoint,
                              size:CGSize(width: 30, height: 20))
        angleLabel.textAlignment = .center
        
        let angle2Label = UILabel()
        angle2Label.font = UIFont(name: "Helvetica Neue", size: 11.0)
        angle2Label.text = String(Int(round(triangle.aa!)))+"°"
        angle2Label.frame = CGRect(origin: startPoint,
                                  size:CGSize(width: 30, height: 20))
        angle2Label.textAlignment = .center
        
        let angle3Label = UILabel()
        angle3Label.font = UIFont(name: "Helvetica Neue", size: 11.0)
        angle3Label.text = String(Int(round(triangle.rightAngle)))+"°"
        angle3Label.frame = CGRect(origin: rightPoint,
                                   size:CGSize(width: 30, height: 20))
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

    }
}

let vc = ViewController()

PlaygroundPage.current.liveView = vc.view
