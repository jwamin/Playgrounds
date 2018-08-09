
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

let limit = 20


class ViewController : UIViewController {
    
    var textArea:UITextView!
    
    override func loadView(){
        view = MyView()
        view.backgroundColor = UIColor.white
        textArea = UITextView()
        textArea.frame = view.frame
        textArea.autoresizingMask = [
            //.flexibleBottomMargin,
            .flexibleWidth,
            .flexibleHeight,
            //.flexibleTopMargin,
            //.flexibleLeftMargin,
            //.flexibleRightMargin
        ]
        textArea.backgroundColor = UIColor.cyan
        view.addSubview(textArea)
        calculatePrimes()

    }
    
    override func viewDidLoad() {
        print("view loaded")
    }
    
    func resetTextArea(){
        textArea.text = ""
        //textArea.text = String(arc4random_uniform(30))+"\n"
    }
    
    var dict:[Int:String] = [Int:String]()
    
    func addToTextArea<T>(str:T,_ nilindex:Int?){
        
        let str = str as! String
        
        textArea.textColor = UIColor.red
        textArea.text = textArea.text+str+" \n"
        
        
    }
    
    func printFinally(){
    
        textArea.backgroundColor = UIColor.cyan
        
        let dictSorted = dict.sorted(by:  { (key1,key2) -> Bool in return key1.key<key2.key })
        
        let str = textArea.text
        
    for (index,item) in dictSorted{
    textArea.text = textArea.text + "\(index) || \(item)\n"
    } 
        //textArea.text = textArea.text + String(arc4random_uniform(32))
    }
    
    func calculatePrimes(){
        
        dict = [Int:String]()
        
        resetTextArea()
        //addToTextArea(str: "another world\n", nil)
        //addToTextArea(str: "another line\n", nil)
        
        textArea.backgroundColor = UIColor.green
            DispatchQueue.global(qos: .background).async {
                
                
                for i in 0...limit{
                    var s = 0
                    print("loop \(i)")
                    print("running on background queue")
                s = i+10
                    
                    self.dict[i] = String(s)
                    
                    DispatchQueue.main.async {
                        
                        self.addToTextArea(str: String(s), i)
                        
                    }
                    
                }
                    
                    DispatchQueue.main.async {
                        print("back to main queue, calling once")
                        self.printFinally()
                
                }
                
            
        }
        
        
    }
    
}


let viewC = ViewController()

PlaygroundPage.current.liveView = viewC
