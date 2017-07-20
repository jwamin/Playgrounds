import UIKit
import PlaygroundSupport

class ViewController : UIViewController {
    
    var touchView:UIView!
    var moving:Bool!
    override func viewDidLoad() {
        
        
        
        self.view.autoresizesSubviews =  false
        moving=false
        let myview = UIView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
        self.view = myview
        myvc.view.layer.backgroundColor = UIColor.red.cgColor
        
        print("view loaded")
        touchView = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        touchView.layer.backgroundColor = UIColor.green.cgColor
        touchView.layer.cornerRadius = 50
        view.addSubview(touchView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("got first touch!!")
        let point = touches.first?.preciseLocation(in: view)
        touchView.layer.backgroundColor = UIColor.yellow.cgColor
        if (touchView.frame.contains(point!)) {
            moving = true
            
            
            updateSubviewPositionWithTouch(point: point!)
        }
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("got more touches")
        let point = touches.first?.preciseLocation(in: view)
        touchView.layer.backgroundColor = UIColor.cyan.cgColor
        updateSubviewPositionWithTouch(point: point!)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches ended")
        let point = touches.first?.preciseLocation(in: view)
        touchView.layer.backgroundColor = UIColor.green.cgColor
        if moving {
            moving = false
            print(touchView.bounds)
            
            print(touchView.frame.origin.x)
            
            touchView.bounds.origin.x = touchView.frame.origin.x
            touchView.bounds.origin.y = touchView.frame.origin.y
        }
    }
    func updateSubviewPositionWithTouch(point:CGPoint){
        
        if moving{
            touchView.center = point
        }
        
        
    }
}

var myvc = ViewController(nibName: nil, bundle: nil)



PlaygroundPage.current.liveView = myvc

