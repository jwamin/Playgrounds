//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"

class ViewController : UIViewController{
    var mainImage:UIImageView?
    var tempImage:UIImageView?
    var swiped:Bool!
    var pinched:Bool!
    var gr:UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.red
        mainImage = UIImageView(frame: self.view.frame)
        self.view.addSubview(mainImage!)
        tempImage = UIImageView(frame: self.view.frame)
        self.view.addSubview(tempImage!)
        swiped = false
        pinched = false;
        
        gr = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(clear))
        gr.edges = .right
        self.view.addGestureRecognizer(gr)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //draw(point: touches.first!.location(in: self.view))
        //print(touches.first!.location(in: self.view))
        lastPoint = touches.first!.location(in: self.view)
        //tickTock(point: touches.first!.location(in: self.view))
        swiped = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true;
        let point = touches.first!.location(in: self.view)
        drawLine(point: point)
        lastPoint = point
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(point: lastPoint!)
        }
        let opacity = 1.0 as CGFloat;
        // Merge tempImageView into mainImageView
        
        UIGraphicsBeginImageContext(mainImage!.frame.size)
        mainImage!.image?.draw(in:CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: 1.0)
        tempImage!.image?.draw(in:CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: opacity)
        //tempImage?.layer.backgroundColor = UIColor.red.cgColor
        mainImage!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImage!.image = nil
        lastPoint = nil
        
    }
    
    var lastPoint:CGPoint?
    
    func drawLine(point:CGPoint){
        if let gotLastPoint = lastPoint{
            //print(point.x,point.y)
            UIGraphicsBeginImageContext(view.frame.size)
            let context = UIGraphicsGetCurrentContext()
            //print(mainImage!.frame.size)
            //tempImage?.layer.backgroundColor = UIColor.blue.cgColor
            tempImage?.image?.draw(in:
                CGRect(x: 0.0,
                       y: 0.0,
                       width: mainImage!.frame.size.width,
                       height: mainImage!.frame.size.height)
            )
            
            context!.beginPath()
            context!.move(to: gotLastPoint)
            context!.addLine(to: point)
            context?.setLineWidth(10.0)
            
            context!.setLineCap(.round)
            context!.setStrokeColor(UIColor.green.cgColor)
            context!.setFillColor(UIColor.green.cgColor)
            context!.setBlendMode(.normal)
            
            context!.strokePath()
            self.tempImage!.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        
    }
    
    func reset(){
        print("got reset")
        mainImage?.image = nil
        mainImage?.frame = self.view.frame
        pinched = false
        gr.addTarget(self, action: #selector(clear))
    }
    
    func clear(sender: UIScreenEdgePanGestureRecognizer){
        if(sender.state == .ended){
            if let hasPinched = pinched{
                if(hasPinched == false){
                    gr.removeTarget(self, action: #selector(clear))
                    pinched = true
                    print("got a gesture")
                    var newframe = self.mainImage!.frame
                    newframe.origin.x = -newframe.width
                    print(self.mainImage!.frame,newframe)
                    UIView.animate(withDuration: 1.0, animations: {
                        
                        self.mainImage?.frame = newframe
                        
                    }, completion: {
                        finished in
                        self.reset()
                    })
                }
                
                
            }
        }
        
    }
    
}


let myViewController = ViewController()

PlaygroundPage.current.liveView = myViewController
