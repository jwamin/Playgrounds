import UIKit
import PlaygroundSupport
import GLKit

enum AnimState:Int{
    case start
    case first
    case second
    case third
    case fourth
}

struct Pattern{
    let h:String
    let v:String
}

let top = "V:|-50-[view0(100)]"
let left = "|-50-[view0(100)]"
let bottom = "V:[view0(100)]-50-|"
let right = "[view0(100)]-50-|"

let topLeft = Pattern(h: left, v:top)
let bottomRight = Pattern(h:right, v:bottom)
let bottomLeft = Pattern(h:left , v:bottom)
let topRight = Pattern(h:right , v:top)

let positions:[String:[AnimState:Pattern]] = [
    "view0":[
        .start: topLeft,
        .first: bottomRight,
        .second: topRight,
        .third: bottomRight,
        .fourth:bottomLeft
    ],
    "view1":[
        .start:bottomRight,
        .first:topLeft,
        .second:bottomLeft,
        .third:topLeft,
        .fourth:topRight
    ],
    "view2":[
        .start:topRight,
        .first:bottomLeft,
        .second:bottomRight,
        .third:bottomLeft,
        .fourth:topLeft
    ],
    "view3":[
        .start:bottomLeft,
        .first:topRight,
        .second:topLeft,
        .third:topRight,
        .fourth:bottomRight
    ]
]



class MyView : UIView {
    
    var myConstraints:[NSLayoutConstraint]? = nil 
    var namedSubviews:[String:UIView] = [:]
    
    var animState:AnimState = .start
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        if(self.myConstraints != nil){NSLayoutConstraint.deactivate(self.myConstraints!)
        self.myConstraints?.removeAll()
        }
        
        var constraints = [NSLayoutConstraint]()
        
        //animState = AnimState(rawValue: animState.rawValue+1) ?? .start
        
        for (key,view) in namedSubviews{
            let views = ["view0":view]
            print(views,key,animState)
            guard let position = positions[key], let format = position[animState] else{
                fatalError("error")
            }
            constraints += NSLayoutConstraint.constraints(withVisualFormat: format.h, options: [], metrics: nil, views: views)
            constraints += NSLayoutConstraint.constraints(withVisualFormat: format.v, options: [], metrics: nil, views: views)
        }
        
        //NSLayoutConstraint.activate(constraints)
        print(constraints)
        
        if(self.myConstraints==nil){
            NSLayoutConstraint.activate(constraints)
        }
        
        self.myConstraints = constraints
            
        super.updateConstraints()
        
        }
        
    
//          func changeConstraints(){
//              NSLayoutConstraint.deactivate(self.myConstraints!)
//              self.myConstraints?.removeAll()
//              
//              var constraints = [NSLayoutConstraint]()
//              
//              animState = AnimState(rawValue: animState.rawValue+1) ?? .start
//              
//              for (key,view) in namedSubviews{
//                  let views = ["view0":view]
//                  guard let position = positions[key], let format = position[animState] else{
//                      return
//                  }
//                  constraints += NSLayoutConstraint.constraints(withVisualFormat: format.h, options: [], metrics: nil, views: views)
//                  constraints += NSLayoutConstraint.constraints(withVisualFormat: format.v, options: [], metrics: nil, views: views)
//              }
//              
//              //NSLayoutConstraint.activate(constraints)
//              print(constraints)
//              self.myConstraints = constraints
//  
//  }
    
        func animateConstraints(callback: @escaping ()->Void){
            guard let constraints = self.myConstraints else {
                return
            }
            self.backgroundColor = UIColor.darkGray
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 20, initialSpringVelocity: 30, options: [], animations: { 
                
                
                for view in self.subviews{
                    view.transform = CGAffineTransform(rotationAngle: CGFloat(GLKMathDegreesToRadians(90.0)))
                }
                NSLayoutConstraint.activate(constraints)
                self.layoutIfNeeded()
                
                
            }, completion: { (done) in
                if(done){
                    print("done")
                    for view in self.subviews{
                        view.transform = .identity
                    } 
                    self.backgroundColor = UIColor.black;
                    callback()
                }
            })
        }
    
}
        
    

class MySubview : UIView {
    convenience init(){
        let frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        self.init(frame: frame)
        self.backgroundColor = UIColor.blue
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

class ViewController : UIViewController {
    
    var myview:MyView!
    
    
    //var myConstraints:[NSLayoutConstraint]? = nil
    var animating = false
    override func loadView(){
        
        let rect = CGRect(origin: .zero, size: CGSize(width: 800, height: 600))
        
        self.view = MyView(frame: rect)
        self.view.backgroundColor = UIColor.black
        myview = (view as! MyView)
    }
    
    override func viewDidLoad() {
        print("view loaded")
        
        let colors = [
            UIColor.red,
            UIColor.blue,
            UIColor.green,
            UIColor.yellow
        ]
        
        for (index,color) in colors.enumerated(){
            let id = "view\(index)"
            myview.namedSubviews[id] = MySubview()
            guard let subview = myview.namedSubviews[id] else {
                return
            }
            subview.backgroundColor = color
            self.myview.addSubview(subview)
        }
        
        myview.animateConstraints {
            { [unowned self] vc in 
                print(vc,"hello")
                vc.animating = false
                }(self)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!animating){
            
            animating = true
            myview.animState = AnimState(rawValue: myview.animState.rawValue+1) ?? .start
            
            print(myview.animState)
            myview.updateConstraints()
            myview.animateConstraints {
                { [unowned self] vc in 
                    print(vc,"hello")
                    vc.animating = false
                    }(self)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("subviews laid out")
    }
    
    override func viewLayoutMarginsDidChange() {
        print("changed")
    }
    
}


let viewC = ViewController()

PlaygroundPage.current.liveView = viewC
