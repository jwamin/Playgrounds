import UIKit
import PlaygroundSupport

//CA Orrery display

/*TODO: 
 *
 * Detailed Comments
 *
 * Tidy Model
 *
 * Add Relative Sizing
 * Fix Speeds
 * 
 * Add Moon?
 * Blue/ Green CGGradient on earth
 *
 * Add Comet on Elliptical orbit
 * 
 *
 */


let sunSize:CGFloat = 450.0

enum SolarSystem {
    case space
    case sun
    case mercury
    case venus
    case earth
    case mars
    case saturn
    case uranius
    case jupiter
    case neptune
    case pluto
    func getColor()->UIColor{
        switch self {
        case .sun:
            return UIColor.init(red: 1.0, green: 0.783783796721814, blue: 0.0, alpha: 1.0)
        case .space:
            return UIColor.init(red: 0.133333333333333, green: 0.25625, blue: 0.394791666666667, alpha: 1.0)
        case .earth:
            return UIColor.init(red: 0.0770833333333333, green: 0.708333333333333, blue: 0.482291666666667, alpha: 1.0)
        case .mercury:
            return UIColor.orange
        case .venus:
            return UIColor.init(red: 0.971042468501072, green: 0.96283784754136, blue: 0.606660251991422, alpha: 1.0)
        case .mars:
            return UIColor.init(red: 0.897916666666667, green: 0.329166666666667, blue: 0.0, alpha: 1.0)
        case .jupiter:
            return UIColor.init(red: 0.866666666666667, green: 0.363541666666667, blue: 0.0614583333333333, alpha: 1.0)
        case .saturn:
            return UIColor.init(red: 0.95752898571538, green: 0.650096519320619, blue: 0.320945949180453, alpha: 1.0)
        case .uranius:
            return UIColor.init(red: 0.039575288809982, green: 0.596042468501072, blue: 0.451737437528722, alpha: 1.0)
        case .neptune: 
            return UIColor.cyan
        case .pluto:
            return UIColor.lightGray
        default:
            return UIColor.white
        }
    }
    
}

struct Planet{
    let color:SolarSystem
    var diameter:CGFloat
    let duration:TimeInterval
    var radius:CGFloat {
        get{
            return diameter / 2
        }
    }
    var planetRadius:CGFloat
}

func sunSizeMultiple(_ multiple:CGFloat)->CGFloat{
    return sunSize + (sunSize * multiple)
}

let mercury = Planet(color: .mercury, diameter: sunSizeMultiple(0.2),duration:2.0, planetRadius: 5)
let venus = Planet(color: .venus, diameter: sunSizeMultiple(0.5),duration:5.0, planetRadius: 10)
let earth = Planet(color: .earth, diameter: sunSizeMultiple(0.7), duration: 5.8, planetRadius: 10)
let mars = Planet(color: .mars, diameter: sunSizeMultiple(0.85                                                                       ), duration: 6.2, planetRadius: 6)
let jupiter = Planet(color: .jupiter, diameter: sunSizeMultiple(1.2), duration: 8, planetRadius: 15)
let saturn = Planet(color: .saturn, diameter: sunSizeMultiple(1.5), duration: 7, planetRadius: 13)
let uranus = Planet(color: .uranius, diameter: sunSizeMultiple(1.7), duration: 9, planetRadius: 7)
let neptune = Planet(color: .neptune, diameter: sunSizeMultiple(1.8), duration: 10, planetRadius: 6)
let pluto = Planet(color: .pluto, diameter: sunSizeMultiple(2), duration: 15, planetRadius: 2)


let planets = [mercury,venus,earth,mars,jupiter,saturn,uranus,neptune,pluto]

print(mercury.diameter,venus.diameter)

class ViewController : UIViewController{
    
    var displayLink:CADisplayLink!
    var animView:PathView!
    
    /// Minimum scale to which the user may 'pinch to zoom'
    private let maxScaleLimit: CGFloat = 4
    /// Maximum scale to which the user may 'pinch to zoom'
    private let minScaleLimit: CGFloat = 0.3
    /// Variable to track how far the spiralView has been cumulatively scaled
    private var animViewCumulativeScale: CGFloat = 1.0
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = SolarSystem.getColor(.space)()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraintsOnAnimationView()
        
        print("view loaded",view!)
        print(animView.bounds)
        
        //animView.startAnimation()
        print(animView.constraints)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoom(gestureRecognizer:)))
        self.view.addGestureRecognizer(pinchGesture)
        
        let tapgestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
        self.view.addGestureRecognizer(tapgestureRecogniser)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGesture)
        
    }
    
    @objc func tap(tap:UITapGestureRecognizer){
        print("tap")
        animView.showLine = !animView.showLine
    }
    
    @objc func pan(gestureRecognizer: UIPanGestureRecognizer) {
        guard let animView = animView else { return }
        
        let translation = gestureRecognizer.translation(in: view)
        
        animView.center = CGPoint(x: animView.center.x + translation.x,
                                    y: animView.center.y + translation.y)
        
        gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
        
    }
    
    let tempConstantForLayoutScaling:CGFloat = 700.0
    
    func setupConstraintsOnAnimationView(){
        
        animView = PathView(frame: self.view.frame)
        self.view.addSubview(animView)
        animView.translatesAutoresizingMaskIntoConstraints = false
        // Always reset the spiralScale when we reset the spiral
        //spiralViewCumulativeScale = 1.0
        
        // Constrain `spiralView` to a square whose size matches the shorter of width and height.
        let widthConstraint: NSLayoutConstraint
        let heightConstraint: NSLayoutConstraint
        
        // Set initial constraint values—from here we will only scale up or down
        widthConstraint = animView.widthAnchor.constraint(equalToConstant: tempConstantForLayoutScaling)
        heightConstraint = animView.heightAnchor.constraint(equalToConstant: tempConstantForLayoutScaling)
        
        let centerYConstraint = animView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let centerXConstraint = animView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([widthConstraint,
                                     heightConstraint,
                                     centerYConstraint,
                                     centerXConstraint])
        print(animView.bounds)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//          displayLink = CADisplayLink(target: self, selector: #selector(update(_:)))
//          displayLink.add(to: .main, forMode: .defaultRunLoopMode)
//          displayLink.preferredFramesPerSecond = 60
//      
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(animView.bounds)
    }
    
    
    @objc func update(_ sender:CADisplayLink){
    print("updated")
        //animView.update()
    }
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //(self.view as! PathView).togglewidth()
    }
    
    // MARK: Gesture recognizer handling
    
    @objc func zoom(gestureRecognizer: UIPinchGestureRecognizer) {
        guard let animView = animView else { return }
        
        if gestureRecognizer.state == .changed || gestureRecognizer.state == .ended {
            
            // Ensure the cumulative scale is within the set range
            if animViewCumulativeScale > minScaleLimit && animViewCumulativeScale < maxScaleLimit {
                
                // Increment the scale
                animViewCumulativeScale *= gestureRecognizer.scale
                
                // Execute the transform
                animView.transform = animView.transform.scaledBy(x: gestureRecognizer.scale,
                                                                     y: gestureRecognizer.scale);
            } else {
                // If the cumulative scale has extended beyond the range, check
                // to see if the user is attempting to scale it back within range
                let nextScale = animViewCumulativeScale * gestureRecognizer.scale
                
                if animViewCumulativeScale < minScaleLimit && nextScale > minScaleLimit
                    || animViewCumulativeScale > maxScaleLimit && nextScale < maxScaleLimit {
                    
                    // If the user is trying to get back in-range, allow the transform
                    animViewCumulativeScale *= gestureRecognizer.scale
                    animView.transform = animView.transform.scaledBy(x: gestureRecognizer.scale,
                                                                         y: gestureRecognizer.scale);
                }
            }
        }
        
        //gestureRecognizer.scale = 1;
    }
    
}

class TriangleShapeLayer : CAShapeLayer {
    override func action(forKey event: String) -> CAAction? {
        return nil
    }
}



class PathView : UIView {
    
    let sunLayer = CAShapeLayer()
//      let mercury = CAShapeLayer()
//      let venus = CAShapeLayer()
//      let earth = CAShapeLayer()
    
    let parentLayer = CAShapeLayer()
    
    var orbitSublayers:[CAShapeLayer] = []
    
    var showLine:Bool = true {
        didSet{
            for layer in orbitSublayers{
                layer.lineWidth = showLine ? 0.2 : 0.0
            }
        }
    }
    
    var centerpoint:CGPoint! = CGPoint.zero
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
    }
    
    func addPlanetLayer(_ orbit:CAShapeLayer,planet: Planet)->CAShapeLayer{
        
        //create planet circle shape
        let subLayer = CAShapeLayer()
        subLayer.frame = CGRect(x: 0, y: 0, width: planet.planetRadius*2, height: planet.planetRadius*2)
        let layerCenter = CGPoint(x: subLayer.bounds.midX, y: subLayer.bounds.midY)
        
        let subLayerBez = UIBezierPath(arcCenter: layerCenter, radius: planet.planetRadius, startAngle: 0, endAngle: CGFloat(.pi*2.0), clockwise: true)
        
        
        subLayer.path = subLayerBez.cgPath
        //subLayer.strokeColor = UIColor.black.cgColor
        subLayer.fillColor = planet.color.getColor().cgColor
        
        //subLayer.backgroundColor = UIColor.white.cgColor
        
        let randomAngle = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(0.0 - (.pi * 2.0))
        
        
        let cos0 = CGFloat(cos(0.0))
        let sin0 = CGFloat(sin(0.0))
        let pointX = CGFloat((randomAngle + planet.radius) * cos0)
        let pointY = CGFloat((randomAngle + planet.radius) * sin0)
        
        subLayer.position = CGPoint(x: pointX, y: pointY)
        
        
        switch planet.color {
        case .saturn:
            
            let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: planet.planetRadius*4, height: planet.planetRadius))
            
            let centerOfRingLayer = CGPoint(x: rect.midX, y: rect.midY)
            
            let ringShape = CAShapeLayer()
            ringShape.frame = rect
            //ringShape.backgroundColor =  UIColor.black.cgColor
            let saturnRings = CGPath(ellipseIn: rect, transform: nil)
            
            ringShape.path = saturnRings
            ringShape.strokeColor = UIColor.white.cgColor
            ringShape.position = layerCenter
            ringShape.fillColor = nil
            
            //slightly strange line gap solution
            ringShape.lineDashPattern = [17,22,100]
            
            //ringShape.strokeStart = 0.31
            //ringShape.strokeEnd = 1
            subLayer.insertSublayer(ringShape, at: 0)
        default:
            break
        }
        
        
        print(subLayer.frame.width)
        //subLayer.fillColor = nil
        orbit.addSublayer(subLayer)
        
        return orbit
        
    }
    
    func setupLayers(){
        parentLayer.sublayers?.removeAll()
        orbitSublayers.removeAll()

        
        centerpoint = CGPoint(x: bounds.midX, y: 0)
        self.backgroundColor = SolarSystem.getColor(.space)()
        sunLayer.frame = CGRect(origin: centerpoint, size: CGSize(width: sunSize, height: sunSize))
        sunLayer.position = centerpoint
        
        let middleOfLayer = CGPoint(x: sunLayer.bounds.midX, y: sunLayer.bounds.midY)
        
        let bezPath = UIBezierPath(arcCenter: middleOfLayer, radius: sunLayer.bounds.midX, startAngle: 0.0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
        let twopi = CGFloat(.pi*2.0)
        
        for planet in planets{
            
            //let radius = planet.radius / 2
            let shape = CAShapeLayer()
            
            shape.frame = CGRect(origin: centerpoint, size: CGSize(width: planet.diameter, height: planet.diameter))
            
            let middleOfLayer = CGPoint(x: shape.bounds.midX, y: shape.bounds.midY)
            
            shape.position = centerpoint
            let bezPath = UIBezierPath(arcCenter: middleOfLayer, radius: planet.radius, startAngle: 0.0, endAngle: twopi, clockwise: true)
            
            shape.fillColor = nil
            
            shape.lineWidth = (showLine) ? 0.2 : 0.0
            
            shape.strokeColor = UIColor.white.cgColor //planet.color.getColor().cgColor
            shape.path = bezPath.cgPath
            let shapeWithPlanet = addPlanetLayer(shape,planet: planet)
            shapeWithPlanet.fillColor = nil
            parentLayer.addSublayer(shapeWithPlanet)
            orbitSublayers.append(shapeWithPlanet)
        }
        
        layer.addSublayer(parentLayer)
        sunLayer.path = bezPath.cgPath
        
        print(self.center)
        
        sunLayer.strokeColor = UIColor.white.cgColor
        sunLayer.fillColor = SolarSystem.getColor(.sun)().cgColor
        sunLayer.lineWidth = 0
        
        //sunLayer.backgroundColor = UIColor.white.cgColor
        
        self.layer.addSublayer(sunLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let restartOn:CGFloat = 60
    
    func startAnimation(){
        
        let angle = Double(.pi * 2.0)
        
        CATransaction.begin()
        print(parentLayer.sublayers?.count)
        for (index,sublayer) in orbitSublayers.enumerated(){
            sublayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            //sublayer.backgroundColor = UIColor.black.cgColor
            let mainAnim = CABasicAnimation(keyPath: "transform.rotation")
            mainAnim.fromValue = 0.0
            mainAnim.toValue = CGFloat(angle)
            mainAnim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            mainAnim.duration = planets[index].duration
            mainAnim.repeatCount = .infinity
            mainAnim.autoreverses = false
            sublayer.add(mainAnim, forKey: nil)
        }
        
        
        CATransaction.commit()

        
    }
    
    
    func update(){
        
        //update transform on triangle layer
        
//          if(tick>restartOn){
//              tick = 0
//          }
//          print(tick)
//          let normalisedTime = Double(tick / restartOn)
//          print(normalisedTime)
//          
//          let angle = Double(.pi * 2.0) * normalisedTime
//          
//          parentLayer.transform = CATransform3DRotate(parentLayer.transform, CGFloat(angle), 0, 0, 1)
//          
//          
//          tick+=1
        
        
    }
    
    override func layoutSubviews() {
        setupLayers()
        startAnimation()

    }
}

let vc = ViewController()

PlaygroundPage.current.liveView = vc
