import UIKit
import PlaygroundSupport

class ViewController : UIViewController{
    
    var animated:(Bool,Bool) = (false,false);
    var animating:Bool = false;
    var complete:Bool = false;
    //var topConstraint:NSLayoutConstraint
    //var bottomLayoutConstraint:NSLayoutConstraint
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        
        let view1 = DrawView()
        view1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view1.backgroundColor = UIColor.red
        view1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(view1)
        
        let view2 = DrawView()
        view2.frame = CGRect(x: 100, y: 0, width: 100, height: 100)
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.backgroundColor = UIColor.blue
        view.addSubview(view2)
        
        print(view.frame.height)
        
        //apply constraints
        addInitialConstraints()

    }
    
    func addInitialConstraints(){
    
        for subview in view.subviews{
            
            //set position from top
            NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1.0, constant: 100).isActive = true
            
            //constrain dimensions
            NSLayoutConstraint(item: subview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 100).isActive = true
            
            NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: subview, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
            
            
        }
        
        //set left constraint for red view
        NSLayoutConstraint(item: self.view.subviews[0], attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 100).isActive = true
        
            //set right constraint with blue view
        NSLayoutConstraint(item: self.view.subviews[1], attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1.0, constant: -100).isActive = true
        
        //link both views?
        //NSLayoutConstraint(item: self.view.subviews[0], attribute: .right, relatedBy: .equal, toItem: self.view.subviews[1], attribute: .left, multiplier: 1.0, constant: -75).isActive = true
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!animating){
            animateViews()
            animating = true
        }
    }
    
    
    
    func animateViews(){
        //detatch constraints
        //perform animations
        var translateBy:CGFloat = 300.0
        if(complete==true){
            translateBy = -300.0
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 20, initialSpringVelocity: 10, options: .beginFromCurrentState, animations: {
            
            self.view.subviews[0].center = CGPoint(x: self.view.subviews[0].center.x, y: self.view.subviews[0].center.y+translateBy)
            
            if(self.complete){
                self.view.subviews[0].transform = CGAffineTransform.identity
            } else {
                self.view.subviews[0].transform = CGAffineTransform(rotationAngle: 1)
            }
            
            
            
        }, completion: {
            (complete) in
            if(complete){
                self.animated.0 = !self.animated.0
                self.animationCallback()

            }
        })
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.view.subviews[1].center = CGPoint(x: self.view.subviews[1].center.x, y: self.view.subviews[1].center.y+translateBy)
            
        }, completion: {
            (complete) in
            if(complete){
                self.animated.1 = !self.animated.0
                self.animationCallback()
                
            }
            
        })
        
        //attach new constraints?
    
    }
    
    func animationCallback(){
        //set animated flags
        let (test1,test2) = animated
        if (test1&&test2){
            animating = false
            animated = (false,false)
            complete = !complete
        }
    }
    
}

class DrawView : UIView{
    
    override func draw(_ rect: CGRect) {
        
    }
    
}


PlaygroundPage.current.liveView = ViewController()
