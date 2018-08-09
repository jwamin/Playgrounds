import UIKit
import PlaygroundSupport

class ScoreView : UIView {
    
    var label:UILabel!
    private var color:UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(color:UIColor){
        let frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
        self.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.color = color
        
        label = UILabel(frame: self.bounds)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.white
        updateScore(score: 0)
        self.addSubview(label)
        self.backgroundColor = UIColor.clear
        self.setNeedsDisplay()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(score:Int){
        label.text = String(score)
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 30, initialSpringVelocity: 30, options: [], animations: { 
            self.transform = .identity
        }, completion: {(complete) in
            if(complete){
                print(complete)
            }
        })
        
        
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(color.cgColor)
        context?.setFillColor(color.cgColor)
        context?.setLineWidth(1.0)
        context?.addEllipse(in: self.frame)
        context?.drawPath(using: .fill)
    }
    
}


class BackgroundView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkSkyBlue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum Position{
    case bottom
    case topLeft
    case topRight
}

class ViewController : UIViewController {
    
    var springView:UIView!
    var center:CGPoint!
    var interactionEnabled:Bool!
    
    var leftScoreView:ScoreView!
    var rightScoreView:ScoreView!
    
    //var currentPosition:Position = .bottom
    
    var swipeLeft:Int = 0{
        didSet{
            printScore()
            leftScoreView.updateScore(score: swipeLeft)
        }
    }
    var swipeRight:Int = 0 {
        didSet{
            printScore()
            rightScoreView.updateScore(score: swipeRight)
        }
    }
    
    func printScore(){
        print("left:\(swipeLeft) right:\(swipeRight)")
    }
    
    override func loadView(){
        view = BackgroundView()
    }
    
    override func viewDidLoad() {
        print("view loaded")
        
        leftScoreView = ScoreView(color: UIColor.sunYellow)
        view.addSubview(leftScoreView)
        
        rightScoreView = ScoreView(color: UIColor.angryRed)
        view.addSubview(rightScoreView)
        
        addConstraints()

        
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: 300, height: 350))
        springView = UIView(frame: rect)
        //springView.backgroundColor = UIColor.white
        springView.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleBottomMargin
        ]
        
        let image:UIImage = #imageLiteral(resourceName: "IMG_2214.JPG")
        let imageview = UIImageView(frame: springView.frame)
        imageview.image = image
        imageview.contentMode = .scaleAspectFit
        springView.addSubview(imageview)
        view.addSubview(springView)
        
        imageview.layer.cornerRadius = 50
        imageview.layer.masksToBounds =  true
        springView.layer.cornerRadius = 40
        springView.layer.masksToBounds = true
        
        let gr = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gr.maximumNumberOfTouches = 1
        springView.addGestureRecognizer(gr)
        print(springView.center)
    }
    
    
    
    func addConstraints(){
        NSLayoutConstraint(item: leftScoreView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 20).isActive = true
        
        NSLayoutConstraint(item: leftScoreView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: -20).isActive = true
        
        NSLayoutConstraint(item: leftScoreView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        NSLayoutConstraint(item: leftScoreView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        NSLayoutConstraint(item: rightScoreView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1.0, constant: -20).isActive = true
        
        NSLayoutConstraint(item: rightScoreView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: -20).isActive = true
        
        NSLayoutConstraint(item: rightScoreView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        NSLayoutConstraint(item: rightScoreView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50).isActive = true
        
        
        rightScoreView.frame
        leftScoreView.frame
    }
    
    func drawInSubview(){
        var shapeLayer:CAShapeLayer?
//          if(springView.layer.sublayers == nil){
//              shapeLayer = CAShapeLayer()
//          } else {
//              shapeLayer = springView.layer.sublayers![0] as! CAShapeLayer
//              
//          }
        
        guard let shape = shapeLayer else {
            return
        }
        
        let pathWidth = CGFloat(2.0)
        //let bez = UIBezierPath(ovalIn: springView.bounds.insetBy(dx: pathWidth, dy: pathWidth))
        //shape.path = bez.cgPath
        //shape.position = springView.or
        
        shape.frame = springView.bounds.insetBy(dx: 10, dy: 10)
        shape.backgroundColor = UIColor.white.cgColor
        
        let path = UIBezierPath(rect: shape.frame).cgPath
        
        shape.shadowPath = path
        shape.shadowRadius = 10.0
        shape.shadowColor = UIColor.red.cgColor
        shape.shadowOffset = CGSize(width: -10, height: -10)
        shape.shadowOpacity = 1.0
        
        shape.lineWidth = pathWidth
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.niceGreen.cgColor
        springView.layer.addSublayer(shape)
    }
    
    @objc func handlePan(_ recogniser:UIPanGestureRecognizer){
        print()
        switch(recogniser.state){
            case .began:
            print("began")
            case .changed:
            print("moved")
            let translation = recogniser.translation(in: view)
            let point = CGPoint(x: center.x+translation.x , y: center.y+translation.y)
            recogniser.view!.center = point
            case .ended:
            print("ended")
            let translation = recogniser.translation(in: view)
            let position = calculateRelativePosition(point: translation)
            handleAnimation(position)
            case .cancelled:
            print("cancelled?")
            default:
            print("something else")
        }
        
    }
    
    func calculateRelativePosition(point:CGPoint)->Position{
        
        
        
        switch point {
        case _ where (point.x < 0 && point.y<0):
            return Position.topLeft
            case _ where (point.x > 0 && point.y < 0):
            return Position.topRight
        default:
            return Position.bottom
        }
    }
    
    func handleAnimation(_ position:Position){
        switch position {
        case .topLeft:
            springToTopLeft()
        case .topRight:
            springToTopRight()
        default:
            springBackToCenter()
        }
    }
    
    //:- Animation functions
    
    func springBackToCenter(){
        UIView.animate(withDuration: 1, 
                       delay: 0, 
                       usingSpringWithDamping: 5, 
                       initialSpringVelocity: 30, 
                       options:[.allowUserInteraction,
                                .beginFromCurrentState], 
                       animations: { 
                        
                        self.springView.center = self.center
        }, completion: { (complete) in
            if(complete){
                print("springback complete")
                
            }
        })
    }
    
    func resetView(){
        springView.layer.opacity = 0
        springView.center = view.center
        springView.transform = CGAffineTransform.init(rotationAngle: 70)
        UIView.animate(withDuration: 0.5, animations: { 
            self.springView.layer.opacity = 1
            self.springView.center = self.center
            self.springView.transform = .identity
        }, completion: { (complete) in
            if(complete){
                print("complete")
            }
        })
        
    }
    
    func springToTopLeft(){
        
        var targetPoint = self.view.frame.origin
        //targetPoint.x = targetPoint.x - (springView.bounds.width / 2)
        //targetPoint.y = targetPoint.y - (springView.bounds.height / 2)
        self.springView.layer.opacity = 1
        UIView.animate(withDuration: 0.5, 
                       delay: 0, 
                       usingSpringWithDamping: 10, 
                       initialSpringVelocity: 20, 
                       options:[.allowUserInteraction,
                                .beginFromCurrentState], 
                       animations: { 
                        
                        self.springView.center = targetPoint
                        
                        self.springView.transform = CGAffineTransform(rotationAngle: 0.5)
                        self.springView.layer.opacity = 0
                        
        }, completion: { (complete) in
            if(complete){
                print("left complete")
                self.swipeLeft += 1
                self.resetView()

            }
        })
        
    }
    
    func springToTopRight(){
        
        var targetPoint = CGPoint(x: self.view.frame.width, y: 0)
        //targetPoint.x = targetPoint.x + (springView.bounds.width / 2)
        //targetPoint.y = targetPoint.y - (springView.bounds.height / 2)
        targetPoint
        UIView.animate(withDuration: 0.5, 
                       delay: 0, 
                       usingSpringWithDamping: 10, 
                       initialSpringVelocity: 20, 
                       options:[.allowUserInteraction,
                                .beginFromCurrentState], 
                       animations: { 
                        
                        
                        self.springView.center = targetPoint
                        self.springView.layer.opacity = 0
                        
                        self.springView.transform = CGAffineTransform(rotationAngle: -0.5)
                        
                        
                        
        }, completion: { (complete) in
            if(complete){
                print("right complete")
                self.swipeRight += 1
                self.resetView()

            }
        })
        
    }
    
    override func viewWillLayoutSubviews() {
        //drawInSubview()
    }
    
    override func viewDidLayoutSubviews() {
        center = springView.center
    }
    
}

//Extend UIColor w/ static properties to create custom static color palette.
extension UIColor {
    
    static let darkSkyBlue = UIColor.init(red: 0.23125, green: 0.498958333333333, blue: 0.688541666666667, alpha: 1.0)
    static let niceGreen = UIColor.init(red: 0.298958333333333, green: 0.875, blue: 0.346875, alpha: 1.0)
    static let sunYellow = UIColor.init(red: 0.936458333333333, green: 0.938541666666667, blue: 0.0, alpha: 1.0)
    static let angryRed = UIColor.init(red: 0.895833333333333, green: 0.209375, blue: 0.0833333333333333, alpha: 1.0)
    
}

let viewC = ViewController()

PlaygroundPage.current.liveView = viewC
