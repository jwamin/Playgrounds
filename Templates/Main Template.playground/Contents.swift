import UIKit
import PlaygroundSupport

class MyView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ViewController : UIViewController {
    
    
    
    override func loadView(){
        view = MyView()
        
    }
    
    override func viewDidLoad() {
        print("view loaded")
    }
}


let viewC = ViewController()

PlaygroundPage.current.liveView = viewC
