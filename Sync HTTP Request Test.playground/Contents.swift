import UIKit
import PlaygroundSupport

class ViewController:UIViewController, URLSessionDelegate, URLSessionDataDelegate{
    
    var thisData:Data?
    var session:URLSession?
    var textView:UITextView?
    var numberOfHits:Int = 0
    
    override func loadView() {
        self.view = UIView()
        //view.backgroundColor = UIColor.cyan
        //self.view = view
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.cyan
          let rect = CGRect(x: 100, y: 100, width: 100, height: 20)
         let button = UIButton(frame: rect)
          button.setTitle("start", for: .normal)
          button.addTarget(self, action: #selector(startBackgroundThingy), for: .touchUpInside)
        button.setTitleColor(UIColor.buttonBlue, for: .normal)
          button.autoresizingMask = [
              .flexibleBottomMargin,
              .flexibleHeight,
              .flexibleWidth,
              .flexibleTopMargin,
              .flexibleLeftMargin,
              .flexibleRightMargin
          ]
        
        print(button)
        view.addSubview(button)
    }
    
    @objc func startBackgroundThingy(){
        
        print("button pressed")
        
        let session = URLSession.shared.dataTask(with: URL(string:"https://api.coinbase.com/v2/prices/BTC-USD/spot")!, completionHandler: { 
            (data, response, error) in
            self.numberOfHits += 1
            if (error != nil){
                print(error?.localizedDescription)
                
                DispatchQueue.main.async {
                    self.handOffToTextView(error!.localizedDescription)
                        
                }
                return
            }
            
            guard let str = String(data: data!, encoding: .utf8) else {
                fatalError("errr fatalError, data not well formed")
            }
            
            DispatchQueue.main.async {
                self.handOffToTextView(str)
                print(str)
            }
            
            
        })
        
        
        session.resume()
        
        
    }
    
    func handOffToTextView(_ response:String){
        print(response)
        
            
        
        //DispatchQueue.main.async {
            
            if (self.textView?.text==nil){
                
            let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))
                
                self.textView = UITextView(frame: rect)
                
                self.textView?.autoresizingMask = [.flexibleBottomMargin,.flexibleLeftMargin,.flexibleRightMargin]
                
                self.textView?.text = response + "\(self.numberOfHits)"
                 
            self.view.addSubview(self.textView!)
                
        } else {
                self.textView?.text = response + "\(self.numberOfHits)"
                //return
                //print("already exists?")
                //print(self.textView!.text,response)
                //self.textView!.text = response
            }
        }
    //}
    
}

extension UIColor {
    
    static let buttonBlue = UIColor.init(red: 0.0, green: 0.322916666666667, blue: 0.935416666666667, alpha: 1.0)
    
}

PlaygroundPage.current.liveView = ViewController()


