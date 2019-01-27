import UIKit
import PlaygroundSupport

enum LabelPostion{
    case vertical
    case horizontal
}

class DimensionLabel : UILabel{
    
    private var orientation:LabelPostion?
    
    override func didMoveToSuperview() {
        self.textColor = UIColor.white
    }
    
    func setLabel(labelPostion:LabelPostion){
        guard let orientationSet = self.orientation else {
            self.orientation = labelPostion
            return
        }
        return
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let orientation = self.orientation else {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.beginPath()
        if(orientation == .horizontal){ //horizontal
            context?.move(to: CGPoint(x: 0, y: self.frame.midY-(self.frame.midY/2)))
            context?.addLine(to: CGPoint(x: self.frame.width, y: self.frame.midY-(self.frame.midY/2)))
        } else if (orientation == .vertical) { // vertical
            context?.move(to: CGPoint(x: self.frame.midX-self.frame.midX/2, y: 0))
            context?.addLine(to: CGPoint(x: self.frame.midX-self.frame.midX/2, y: self.frame.height))
        }
        
        context?.strokePath()

        
    }
}

class MyView : UIView{
    
    static let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 300))
    
    var heightLabel:DimensionLabel!
    var widthLabel:DimensionLabel!
    
    convenience init(){
        
        self.init(frame: MyView.rect)
        self.translatesAutoresizingMaskIntoConstraints = false
        print(self.frame)
        self.backgroundColor = UIColor.darkGray
        
        heightLabel = DimensionLabel()
        heightLabel.setLabel(labelPostion: .vertical)
        
        heightLabel.layer.borderColor = UIColor.red.cgColor
        heightLabel.layer.borderWidth = 1.0
        
        widthLabel = DimensionLabel()
        widthLabel.setLabel(labelPostion: .horizontal)
        
        widthLabel.layer.borderColor = UIColor.green.cgColor
        widthLabel.layer.borderWidth = 1.0
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        widthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        heightLabel.textAlignment = .center
        widthLabel.textAlignment = .center
        self.addSubview(heightLabel)
        self.addSubview(widthLabel)
        
        
        layoutLabels()

        
        //heightLabel.transform = CGAffineTransform(rotationAngle: MyView.degToRad(deg: -90.0))
        
    }
    
    func layoutLabels(){
        
        //refactor to visual?
        
        NSLayoutConstraint(item: widthLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: widthLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: widthLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 100).isActive = true
        
        //NSLayoutConstraint(item: widthLabel, attribute: .height, relatedBy: .equal, toItem: heightLabel, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: heightLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: heightLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 150).isActive = true
        
        //widthLabel.backgroundColor = UIColor.red
        //heightLabel.backgroundColor = UIColor.green
    }
    
    static func degToRad(deg:CGFloat)->CGFloat{
        return deg * (.pi / 180)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print(self.frame)
    }
    
    override func layoutSubviews() {

        widthLabel.text = "w: \(self.frame.width)"
        heightLabel.text = "h: \(self.frame.height)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began")
        //updateConstraints()
        layoutIfNeeded()

    }
}

class Controller : UIViewController{
    
    var myView:MyView!
    
    override func loadView() {
        myView = MyView()
        self.view = myView
    }
    
    override func viewDidLayoutSubviews() {
        
        //view.setNeedsDisplay()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

let con = Controller()
PlaygroundPage.current.liveView = con
