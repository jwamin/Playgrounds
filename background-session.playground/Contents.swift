//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    var requester:BTCPriceModel!
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidLoad() {
       requester = BTCPriceModel()
        let button = UIButton(type: .roundedRect)
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        
        button.setTitle("do requests", for: .normal)
        
        button.setTitleColor(UIColor.brown, for: .normal)
        
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 20)
        
        view.addSubview(button)
        
    }
    
    @objc func action(){
        print("doing requests!")
        requester.getUpdateBitcoinPrice()
        
    }
    
    
}





// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
