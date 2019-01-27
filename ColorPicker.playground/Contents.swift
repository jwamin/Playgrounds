import UIKit
import PlaygroundSupport

#if targetEnvironment(TARGET_IPHONE_SIMULATOR)
let envSim = true
#else
let envSim = false
#endif

print(envSim)

let stretchLayout:UIView.AutoresizingMask = [.flexibleWidth,.flexibleHeight] 

class MyView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ViewController : UIViewController {
    
    let spaces = ["R","G","B","A"]
    
    var mainStackView:UIStackView!
    var uiStackView:UIStackView!
    var sliders:[UISlider]!
    var segmentedControl:UISegmentedControl!
    var textView:UITextView!
    var colorview:UIView!
    var colorSpace:(CGFloat,CGFloat,CGFloat,CGFloat) = (0,0,0,0){
        didSet{
            drawColor()

        }
    }
    
    override func loadView(){
        view = MyView()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        print("view loaded")
        
        //stack.backgroundColor = UIColor.red
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let newview = UIImageView(frame: rect)
        newview.image = #imageLiteral(resourceName: "IMG_2189.JPG")
        newview.image
        newview.contentMode = .scaleAspectFill 
        newview.backgroundColor = UIColor.blue
        //stack.addArrangedSubview(newview)
        colorview = UIView(frame: newview.bounds)
        colorview.translatesAutoresizingMaskIntoConstraints = false
        newview.addSubview(colorview)
        var secondview = UIView(frame: rect)
        secondview.backgroundColor = UIColor.yellow
        
        let views = [newview,secondview]
        
        mainStackView = UIStackView(arrangedSubviews: views)
        
        mainStackView.autoresizingMask = stretchLayout
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill
        //mainStackView.spacing = 10
        uiStackView = UIStackView()
        uiStackView.autoresizingMask = stretchLayout
        
        
        uiStackView.axis = .vertical
        uiStackView.distribution = .fillEqually
        uiStackView.spacing = 0
        uiStackView.alignment = .fill
        
        view.addSubview(mainStackView!)
        mainStackView.arrangedSubviews[1].addSubview(uiStackView)
        uiStackView.frame = mainStackView.arrangedSubviews[1].frame
        setupConstraints()

        setupSliders()
        setupLabels()
        setupSegmented()
        updateColor(nil)


    }

    func setupConstraints(){
        NSLayoutConstraint(item: mainStackView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStackView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: colorview, attribute: .height, relatedBy: .equal, toItem: mainStackView.arrangedSubviews[0], attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: colorview, attribute: .width, relatedBy: .equal, toItem: mainStackView.arrangedSubviews[0], attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        
    }
    
    
    @objc func updateText(){
        for subview in uiStackView.arrangedSubviews{
            if(subview is UITextView){
                if(segmentedControl.selectedSegmentIndex == 0){
                    (subview as! UITextView).text = "UIColor.init(red: \(colorSpace.0/255), green: \(colorSpace.1/255), blue: \(colorSpace.2/255), alpha: \(colorSpace.3/255))"
                } else {
                    (subview as! UITextView).text = "[[UIColor alloc] initWithRed:\(colorSpace.0/255) green:\(colorSpace.1/255) blue:\(colorSpace.2/255) alpha:\(colorSpace.3/255)];";
                }
                
            }
        }
    }
    
    
    func setupSegmented(){
        
        
        
        let segmentedControl = UISegmentedControl(items: ["Swift","Objective-C"])
        //segmentedControl.insertSegment(withTitle: "Swift", at: 0, animated: false)
        //segmentedControl.insertSegment(withTitle: "Objective-C", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
            
        let viewForCOntrol = UIView(frame: segmentedControl.frame)
        viewForCOntrol.addSubview(segmentedControl)
        
        uiStackView.insertArrangedSubview(viewForCOntrol, at: 0)
        //uiStackView.addArrangedSubview(viewForCOntrol)
        self.segmentedControl = segmentedControl
        self.segmentedControl.isEnabled = true 
        self.segmentedControl.addTarget(self, action: #selector(updateText), for: UIControl.Event.valueChanged)
        
        let textView = UITextView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: 10)))
        textView.font = UIFont(name: "Menlo", size: 11.0)
        textView.text = "hello world"
        textView.isEditable = false
        textView.isSelectable = true
        //textView.backgroundColor = UIColor.black
        uiStackView.addArrangedSubview(textView)
        //uiStackView.insertArrangedSubview(segmentedControl, at: 0)
        uiStackView.layoutIfNeeded()

    }
    
    
    
    func setupLabels(){
        for colorspace in spaces{
            let label = UILabel()
            label.text = colorspace
            uiStackView.addArrangedSubview(label)
        }
    }
    
    func setupSliders(){
        
        
        var sliders:[UIView] = []
        for space in spaces{
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 20.0)))
            view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            let slider = UISlider(frame: view.bounds)
            slider.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            view.addSubview(slider)
            slider.minimumValue = 0
            slider.maximumValue = 255
            
            slider.addTarget(self, action: #selector(updateColor(_:)), for: UIControl.Event.valueChanged)
            
            //slider.layer.backgroundColor = UIColor.red.cgColor
            slider.isContinuous = false
            sliders.append(slider)
            print(sliders.count)
            self.sliders = self.sliders ?? []
            self.sliders.append(slider)
            uiStackView.addArrangedSubview(view)
            //uiStackView.arrangedSubviews.count
        }
        //uiStackView.addArrangedSubview(sliders[0])
        //uiStackView.addArrangedSubview(sliders[1])
        //uiStackView.addArrangedSubview(sliders[2])
        //uiStackView.addArrangedSubview(sliders[3])
        self.sliders[sliders.count-1].value = 255.0
        
        //self.sliders = sliders
        uiStackView.arrangedSubviews.count
        uiStackView.backgroundColor = UIColor.blue
        
    }

    @objc func updateColor(_ sender:Any?){
        
        var space:[CGFloat] = []
        guard let sliders = sliders else {
            return
        }
        for slider in sliders{
            let cgFloat = CGFloat(slider.value)
            space.append(cgFloat)
        }
        
        colorSpace = (space[0],space[1],space[2],space[3])
        
    }
    
    func drawColor(){
        
        let color = (traitCollection.displayGamut==UIDisplayGamut.P3) ? UIColor.init(displayP3Red: colorSpace.0/255, green: colorSpace.1/255, blue: colorSpace.2/255, alpha: colorSpace.3/255) : UIColor.init(red: colorSpace.0/255, green: colorSpace.1/255, blue: colorSpace.2/255, alpha: colorSpace.3/255)
        
        var index = 0
        for subview in uiStackView.arrangedSubviews{
            if(subview is UILabel){
                (subview as! UILabel).text = spaces[index]+" "+String(round(Double(sliders[index].value)))
                index += 1
            }
        }
        
        colorview.backgroundColor = color
        
        updateText()

        
    }
    
}



let viewC = ViewController()

PlaygroundPage.current.liveView = viewC

