
import UIKit
import PlaygroundSupport

class MyView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
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


let navigationController = UINavigationController()
let viewC = ViewController()
navigationController.pushViewController(viewC, animated: true)
viewC.navigationItem.title = "Hello"
PlaygroundPage.current.liveView = navigationController


