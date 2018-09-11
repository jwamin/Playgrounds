/*
 * Apple Park Drawing
 * or "How i learned to stop worrying and love 
 * CAGradientLayer Masks"
 * by Joss Manger
 */

import UIKit
import PlaygroundSupport
import GLKit
struct Ring{
    let radius:CGFloat
    let width:CGFloat
}

protocol DrawingProtocol{
    func drawingUpdated()
}

struct Settings{
    static let multiplier:CGFloat = 1.3
    static let initialRadius:CGFloat = 99.0
    static let rings:[RingThickness] = [
    .thin,.thick,.medium,.thick,.thin
    ]
    static let gaps:[CGFloat] = [
        0,15,10,10,15
    ]
    static let DEBUG = false
    
    static let park:String = " Park"
    static let round:String = "Gather round."
    
    static let styles:[Style] = [
        Style(presentationStyle: .gradient, backgroundColor: nil, gradientColors: [UIColor.init(red: 0.909375, green: 0.780208333333333, blue: 0.733333333333333, alpha: 1.0),UIColor.init(red: 0.677083333333333, green: 0.497916666666667, blue: 0.417708333333333, alpha: 1.0)], labelText: Settings.round),
        Style(presentationStyle: .color, backgroundColor: #colorLiteral(red: 0.364705890417099, green: 0.0666666701436043, blue: 0.968627452850342, alpha: 1.0), gradientColors: nil, labelText: Settings.park),
        Style(presentationStyle: .color, backgroundColor: #colorLiteral(red: 0.466666668653488, green: 0.764705896377563, blue: 0.266666680574417, alpha: 1.0), gradientColors: nil, labelText: Settings.park),
        Style(presentationStyle: .color, backgroundColor: #colorLiteral(red: 0.960784316062927, green: 0.705882370471954, blue: 0.200000002980232, alpha: 1.0), gradientColors: nil, labelText: Settings.park),
        Style(presentationStyle: .color, backgroundColor: #colorLiteral(red: 0.745098054409027, green: 0.156862750649452, blue: 0.0745098069310188, alpha: 1.0), gradientColors: nil, labelText: Settings.park),
        Style(presentationStyle: .color, backgroundColor: #colorLiteral(red: 0.556862771511078, green: 0.352941185235977, blue: 0.968627452850342, alpha: 1.0), gradientColors: nil, labelText: Settings.park),
        Style(presentationStyle: .gradient, backgroundColor: nil, gradientColors: [UIColor.red,UIColor.orange,UIColor.yellow,UIColor.green,UIColor.blue,UIColor.purple], labelText: Settings.park)
        
    ]
    
}

enum PresentationStyle{
    case color
    case gradient
}

struct Style{
    let presentationStyle:PresentationStyle!
    let backgroundColor:UIColor?
    let gradientColors:[UIColor]?
    let gradientAngle:Float? = -45.0
    let labelText:String
}

enum RingThickness{
    case thin
    case thick
    case medium
    func getThickness(with multiplier:CGFloat?)->CGFloat{
        
        var multiplier:CGFloat = (multiplier != nil) ? multiplier! : 1.0
        
        switch self {
        case .medium:
            return 5.0 * multiplier
        case .thick:
            return 12.0 * multiplier
        case .thin:
            return 1.0 * multiplier
        }
    }
}

func ringAssembly() -> [Ring]{
    var rings:[Ring] = []
    
    var runningRadius = Settings.initialRadius * Settings.multiplier
    
    for (index,ring) in Settings.rings.enumerated(){
        print(index)
        
        let radius = radialiser(startRadius: runningRadius, gap: Settings.gaps[index])
        runningRadius = radius
        
        let thickness = Settings.rings[index].getThickness(with: Settings.multiplier)
        
        let newRing = Ring(radius: radius, width: thickness)
        rings.append(newRing)
    }
    
    return rings
}



func radialiser(startRadius:CGFloat,gap:CGFloat) -> CGFloat{
    let newRadius = (gap*Settings.multiplier) + startRadius
    return newRadius
}

class AppleParkView : UIView {
    
    let strokeColor:CGColor = UIColor.white.cgColor
    var masking = false
    var gradient:CAGradientLayer!
    var shapelayer:CAShapeLayer!
    var centered:CGPoint!
    var delegate:DrawingProtocol?
    private var firstRun:Bool = true
    
    init(frame: CGRect,style:Style,passedDelegate:DrawingProtocol?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        centered = center
        gradient = CAGradientLayer()
        if(passedDelegate != nil){
            delegate = passedDelegate
        }
        
        //update(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cgAlizer(iuColors:[UIColor])->[CGColor]{
        var cgColors:[CGColor] = []
        for color in iuColors{
            cgColors.append(color.cgColor)
        }
        return cgColors
    }
    
    func update(style:Style){
        // loop through styles
        //set masking
        
        if(style.presentationStyle == .gradient){
            masking = true
            gradient.colors = AppleParkView.cgAlizer(iuColors: style.gradientColors!)
            gradient.transform = CATransform3DIdentity
            gradient.transform = CATransform3DMakeRotation(CGFloat(GLKMathDegreesToRadians(style.gradientAngle!)), 0, 0, 1)
        } else {
            masking = false
        }
        
        print(center)
        self.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        print(center)
    }
    
    override func draw(_ rect: CGRect) {
        
        if(shapelayer != nil){
            gradient.removeFromSuperlayer()
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(bounds)
            
        var ringsToDraw = ringAssembly()
        print(ringsToDraw)
        
        if (masking){
            //let maskpath = UIBezierPath()
            
            if (shapelayer == nil){
                shapelayer = CAShapeLayer()
                shapelayer.position = centered
                shapelayer.bounds = bounds
            }
            
            
            
            if(shapelayer.sublayers?.count == nil){
            for ring in ringsToDraw{
                let path = UIBezierPath()
                path.addArc(withCenter: centered, radius: ring.radius, startAngle: 0.0, endAngle: 2.0 * .pi, clockwise: true)
                let newlayer = CAShapeLayer()
                newlayer.position = centered
                newlayer.lineWidth = ring.width
                newlayer.strokeColor = strokeColor
                newlayer.fillColor = UIColor.clear.cgColor
                newlayer.bounds = path.bounds
                newlayer.path = path.cgPath
                shapelayer.addSublayer(newlayer)
            }
                
        } else {
                print(shapelayer.sublayers?.count)
            }
            
            gradient.mask = shapelayer
            print(centered)
            gradient.position = centered
            gradient.bounds = shapelayer.bounds
            
            layer.addSublayer(gradient)
            
        } else {
            
            context?.setLineCap(CGLineCap.round)
            context?.setStrokeColor(strokeColor)
            print(center)
            for ring in ringsToDraw{
                context?.setLineWidth(ring.width)
                context?.addArc(center: centered, radius: ring.radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                context?.strokePath()
            }
        }
        
        // colored / block color drawing
        if(!firstRun){
            delegate?.drawingUpdated()
        }
        
        firstRun = false
        
    }
    
    
}

class ViewController : UIViewController,DrawingProtocol {
    
    var apView:AppleParkView!
    var currentStyle = 0
    var backgroundLayer:CALayer!
    var label:UILabel!
    var labelContainer:UIView!
    var gradient:CAGradientLayer!
    
    private let constraintDimension = 300 * Settings.multiplier
    
    override func loadView() {
        self.view = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        
        let labelRect = CGRect(origin: .zero, size: CGSize(width: 300, height: 100))
        
        labelContainer = UIView(frame: labelRect)
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        label = UILabel(frame: labelRect)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = UIColor.white
        label.text = ""
        labelContainer.addSubview(label)
        
        
        let frame = CGRect(origin: .zero, size: CGSize(width: constraintDimension, height: constraintDimension))
        
        let initialStyle = Settings.styles[currentStyle]
        
        apView = AppleParkView(frame: frame,style:initialStyle,passedDelegate:nil)
        self.view.addSubview(apView)
        apView.translatesAutoresizingMaskIntoConstraints = false
        
        apView.delegate = self
        
        backgroundLayer = CALayer()
        backgroundLayer.bounds = view.frame
        backgroundLayer.position = .zero
        
        
        
        //gradient = CAGradientLayer()
        
        doDebugBlock {
            labelContainer.layer.borderColor = UIColor.green.cgColor
            label.backgroundColor = UIColor.blue
            labelContainer.backgroundColor = UIColor.red
            labelContainer.layer.borderWidth = 1.0
            print(labelContainer.bounds)
        }
        
        view.addSubview(labelContainer)
        
        setupInitialConstraints()
        
        
        //backgroundLayer.backgroundColor = UIColor.red.cgColor
        
        self.view.layer.insertSublayer(backgroundLayer, below: self.apView.layer)
        
        doDebugBlock {
            apView.layer.borderWidth = 1.0
            apView.layer.borderColor = UIColor.red.cgColor
            print(apView)
            backgroundLayer.borderColor = UIColor.yellow.cgColor
            backgroundLayer.borderWidth = 2.0
        }
        
        //view.layoutIfNeeded()

        //apView.layoutIfNeeded()
        //apView.setNeedsDisplay()
        //apView.update(style: initialStyle)
    }
    
    func setupInitialConstraints(){
        if(view.constraints.count == 0){
            
            //Drawing View Constraints
            
            NSLayoutConstraint(item: apView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: constraintDimension).isActive = true
            
            NSLayoutConstraint(item: apView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: constraintDimension).isActive = true
            
            NSLayoutConstraint(item: apView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
            
            NSLayoutConstraint(item: apView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
            
            //Label Container Constraints
            
            NSLayoutConstraint(item: labelContainer, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: labelContainer, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.2, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: labelContainer, attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: labelContainer, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1.0, constant: 0.0).isActive = true
            
            NSLayoutConstraint(item: labelContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0).isActive = true
            
            setupLabelConstraints()
            
        }
    }
//      
//          private var oldBounds = CGRect()
//          private let padding: CGFloat = 20.0
//          
//          override public func viewDidLayoutSubviews() {
//              super.viewDidLayoutSubviews()
//              // If we need to update based on the layoutGuide changing.
//              if oldBounds != liveViewSafeAreaGuide.layoutFrame {
//                  oldBounds = liveViewSafeAreaGuide.layoutFrame
//                  backgroundLayer.bounds = self.view.bounds
//                  backgroundLayer.position = self.view.center
//                  view.layoutIfNeeded()
//              } else {
//                  print("no update")
//              }
//              
//              
//          }
    
    override func viewDidLayoutSubviews() {
        print("laid out subviews")
        //label.text = "test"
        backgroundLayer.bounds = self.view.bounds
                          backgroundLayer.position = self.view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          
          let thisStyle = Settings.styles[currentStyle]
          
          apView.update(style: thisStyle)
          
      }
    
    
    
    func setupLabelConstraints(){
        
        //Label Constraints
        
        NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: labelContainer, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: labelContainer, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: labelContainer, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(labelContainer.subviews)
        currentStyle += 1
        if(currentStyle==Settings.styles.count){
            currentStyle = 0
        }
        let thisStyle = Settings.styles[currentStyle]
        apView.update(style: thisStyle)
    }
    
    func drawingUpdated() {
        let thisStyle = Settings.styles[currentStyle]
        
        labelContainer.mask = nil
        if(gradient != nil){
            gradient.removeFromSuperlayer()
            gradient = nil
        }
        
        if(thisStyle.presentationStyle == .color){
            self.backgroundLayer.backgroundColor = thisStyle.backgroundColor?.cgColor
            
            label.textColor = UIColor.white
                
            print(labelContainer.subviews)

            label.text = thisStyle.labelText
            labelContainer.addSubview(label)
            setupLabelConstraints()

            
        } else {
            
            labelContainer.addSubview(label)
            setupLabelConstraints()
            
            labelContainer.layoutIfNeeded()

            label.text = thisStyle.labelText
            self.backgroundLayer.backgroundColor = UIColor.black.cgColor
            
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.clear
            
            gradient = CAGradientLayer()
            gradient.colors = AppleParkView.cgAlizer(iuColors:thisStyle.gradientColors!)
            
            gradient.frame = labelContainer.bounds
            labelContainer.layer.addSublayer(gradient)
            setupLabelConstraints()

            labelContainer.mask = label
            


        }
        labelContainer.layer.sublayers
        labelContainer.subviews
    }
    
}

func doDebugBlock(_ block:(()->Void)){
    if(Settings.DEBUG){
        block()
    }
}

let viewC = ViewController()

PlaygroundPage.current.liveView = viewC
