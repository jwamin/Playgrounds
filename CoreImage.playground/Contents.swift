//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport





class ViewController : NSViewController{
    
    var transMogrificatonDone:Bool = false
    var imageView:NSImageView!
    let path = Bundle.main.urlForImageResource(NSImage.Name(rawValue:"IMG_0495"))!
    
    var context:CIContext!
    
    let filters = CIFilter.filterNames(inCategory: kCICategoryDistortionEffect)
    var filter:CIFilter!
    var size:NSSize!
    
    
    var image:CIImage!
    
    
    
    
    
   
    
    var currentLocation:NSPoint! {
        didSet{
            transMogrify(currentLocation)
        }
    }
    
    override func loadView() {
        let nibFile = NSNib.Name(rawValue:"MyView")
        var topLevelObjects : NSArray?
        
        Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
        let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
        
        //let imgPath = Bundle.main.path(forResource: "CoreImage", ofType: "xcassets", inDirectory: "Resources")
        
        let view = views[0] as! NSView
        
        //print(view.bounds.h)
        for view in views as! [NSView] {
            for subview in view.subviews{
                if subview is NSImageView{
                    imageView = subview as! NSImageView
                }
            }
        }
        print(imageView.bounds)
        
        
        
        self.view = view
    }
    
    
    override func viewDidLoad() {

        size = imageView.bounds.size
        context = CIContext()
        image = CIImage(contentsOf: path)
        filter = CIFilter(name: filters[0])
        transMogrify(nil)
        imageView.layer?.borderWidth = 1.0
        imageView.layer?.backgroundColor = NSColor.green.cgColor
        imageView.layer?.borderColor = NSColor.black.cgColor
    }
    
    override func mouseDragged(with event: NSEvent) {
       currentLocation = view.convert(event.locationInWindow, to: nil)
    }
    
    
    func transMogrify(_ point:NSPoint?){
//        if(!transMogrificatonDone){
//
//            transMogrificatonDone = !transMogrificatonDone
        
        
        if let point = point {
            let vector:CIVector = CIVector(cgPoint: CGPoint(x: point.x, y: point.y))
            
            print(filter?.attributes["inputCenter"],point,vector)
            filter?.setValue(vector, forKey: "inputCenter")
        }

        
            filter?.setValue(image, forKey: kCIInputImageKey)
            let result = filter?.outputImage!
            guard let cgImage = context.createCGImage(result!, from: result!.extent) else {
                return
            }

            imageView.image = NSImage(cgImage: cgImage, size: size)
            
            print("transmogrification done")
//        } else {
//            print("already transMogrified")
//            return
//        }
    }
    
}

let vc = ViewController()

// Present the view in Playground
PlaygroundPage.current.liveView = vc.view

