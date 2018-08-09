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
    case paused
    case reset
    case ran
}

class ViewController : UIViewController {
    
    var timerIsRunning = TimerState.reset {
        didSet{
            handleStateChanges()
        }
    }
    var timerDisplay:UILabel!
    var startButton:UIButton!
    var stopButton:UIButton!
    var startTime:Date!
    var timePicker:UIDatePicker!
    var timer:Timer!
    var elapsed:TimeInterval! = 0.0
    
    override func loadView(){
        view = MyView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func viewDidLoad() {
        print("view loaded")
        
        layoutButtonsAndLabels()
        timer = Timer()
        //timerIsRunning = .reset
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
            timerDisplay.font = UIFont(name: "Helvetica Neue", size: 72.0)
            timerDisplay.numberOfLines = 0
            timerDisplay.text = "Not Running"
            timerDisplay.textAlignment = .center
            //timerDisplay.backgroundColor = UIColor.red
            view.addSubview(timerDisplay)
            
            timePicker = UIDatePicker()
            timePicker.frame = rect
            timePicker.datePickerMode = UIDatePickerMode.countDownTimer
            timePicker.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(timePicker)
            
            NSLayoutConstraint(item: timePicker, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant:-40).isActive = true
            
            //NSLayoutConstraint(item: timePicker, attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0).isActive = true
            
            NSLayoutConstraint(item: timePicker, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
            
            //NSLayoutConstraint(item: timePicker, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1.0, constant: 0).isActive = true
            
            NSLayoutConstraint(item: timePicker, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
            
            NSLayoutConstraint(item: timePicker, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
            
            
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
    
    @objc private func handleStateChanges(){
        switch(timerIsRunning){
            case .paused:
                startButton.isEnabled = true
                startButton.setTitle("Resume", for: .normal)
                stopButton.setTitle("Reset", for: .normal)
                stopButton.isEnabled = true
            case .reset:
                if(timer.isValid){
                    timer.invalidate()
                }
                elapsed = 0.0
                timePicker.isEnabled = true
                if(timerDisplay.text != "Not Running"){
                    timerDisplay.text = "Not Running"
                }
                startButton.isEnabled = true
                startButton.setTitle("Start", for: .normal)
                stopButton.setTitle("Stop", for: .normal)
                stopButton.isEnabled = false
            case .running:
                startButton.setTitle("Pause", for: .normal)
                stopButton.isEnabled = true
            case .ran:
                stopButton.setTitle("Reset", for: .normal)
                startButton.isEnabled = false
        }
    }
    
    @objc private func calculateElapsed(){
        
        let change = Date().timeIntervalSince(startTime)+elapsed;
        if(change>=timePicker.countDownDuration){
            timer.invalidate()
            timerIsRunning = .ran
            updateLabel(change:
                timePicker.countDownDuration)
        } else {
            updateLabel(change: change)
        }
        
    }
    
    private func updateLabel(change:Double){
        
        let hours = Int(change) / 3600
        let minutes = Int(change) / 60 % 60
        let seconds = Int(change) % 60
        
        timerDisplay.text = String(format: "%02i:%02i:%02i", hours,minutes,seconds)
        
    }
    
    private func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calculateElapsed), userInfo: nil, repeats: true)
    }
    
    @objc func startTimer(){
        
        if timerIsRunning == .running{
            timer.invalidate()
            elapsed = Date().timeIntervalSince(startTime) + elapsed 
            timerIsRunning = .paused
            return
        }
        startTime = Date()
        updateLabel(change: Date().timeIntervalSince(startTime)+elapsed)
        timerIsRunning = .running
        timePicker.isEnabled = false
        runTimer()
        
    }
    
    @objc func stopTimer(){
        timerIsRunning = .reset
    }
    
}


let viewC = ViewController()

PlaygroundPage.current.liveView = viewC

