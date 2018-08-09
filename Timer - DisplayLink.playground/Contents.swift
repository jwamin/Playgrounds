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

enum TimerState{
    case running
    case halted
}

class ViewController : UIViewController {
    
    var timerIsRunning = TimerState.halted
    var link:CADisplayLink!
    var timerDisplay:UILabel!
    var startButton:UIButton!
    var stopButton:UIButton!
    var startTime:Date!
    
    override func loadView(){
        view = MyView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        print("view loaded")
        
        layoutButtonsAndLabels()
        
        link = CADisplayLink(target: self, selector: #selector(updateFired))
        link.add(to: .main, forMode: .defaultRunLoopMode)
    }
    
    func layoutButtonsAndLabels(){
        print("called", view.constraints)
        if(view.constraints.count == 0){
            //layout subviews
            print("laying out")
            startButton = UIButton(type: .roundedRect)
            startButton.setTitle("Start", for: .normal)
            stopButton = UIButton(type: .roundedRect)
            stopButton.setTitle("Stop", for: .normal)
            startButton.addTarget(self, action: #selector(startTimer), for: UIControlEvents.touchUpInside)
            stopButton.addTarget(self, action: #selector(stopTimer), for: UIControlEvents.touchUpInside)
            
            startButton.translatesAutoresizingMaskIntoConstraints = false
            stopButton.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(startButton)
            view.addSubview(stopButton)
            
            let rect = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 30.0))
            
            timerDisplay = UILabel(frame: rect)
            timerDisplay.translatesAutoresizingMaskIntoConstraints = false
            timerDisplay.numberOfLines = 0
            timerDisplay.text = "Not Running"
            timerDisplay.textAlignment = .center
            //timerDisplay.backgroundColor = UIColor.red
            view.addSubview(timerDisplay)
            
                //label constraints
            
            NSLayoutConstraint(item: timerDisplay, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
            
            NSLayoutConstraint(item: timerDisplay, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
            
            NSLayoutConstraint(item: timerDisplay, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
            
            //button constraints
            
                //start
            NSLayoutConstraint(item: startButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 25).isActive = true
            
            NSLayoutConstraint(item: startButton, attribute: .bottom, relatedBy: .equal, toItem: view , attribute: .bottomMargin, multiplier: 1.0, constant: -25).isActive = true
            
                //stop
            NSLayoutConstraint(item: stopButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1.0, constant: -25).isActive = true
            
            NSLayoutConstraint(item: stopButton, attribute: .bottom, relatedBy: .equal, toItem: view , attribute: .bottomMargin, multiplier: 1.0, constant: -25).isActive = true
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch began!")
        if(timerIsRunning == .running){
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    
    @objc func updateFired(){
        switch timerIsRunning {
        case .running:
            //print("running")
            updateLabel()
        case .halted:
            
            if(timerDisplay.text != "Not Running"){
                timerDisplay.text = "Not Running"
            }
            
            //print("not running")
        }
    }
    
    func formatter(interval:TimeInterval)->String{
        let formatter = DateComponentsFormatter()
        //formatter.allowedUnits = [.minute,.second]
        
        guard let str = formatter.string(from: interval) else {
            return "false"
        }
        
        return str
    }
    
    func updateLabel(){
        
        let change = 1 - startTime.timeIntervalSinceNow;
        timerDisplay.text = formatter(interval: change)
        
    }
    
    @objc func startTimer(){
        timerIsRunning = .running
        startTime = Date()
    }
    
    @objc func stopTimer(){
        timerIsRunning = .halted
    }
    
}


let viewC = ViewController()

PlaygroundPage.current.liveView = viewC

