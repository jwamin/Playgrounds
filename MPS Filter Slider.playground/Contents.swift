import MetalPerformanceShaders
import MetalKit
import PlaygroundSupport

let img:()->CGImage = {
    let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
    let colors = [UIColor.red,UIColor.green,UIColor.blue]
    let context = UIGraphicsBeginImageContextWithOptions(rect.size, true, 1.0)
    
    let split = 3
    let width = rect.size.width / CGFloat(split)
    
    for i in 0..<split{
        
        let color = colors[i]
        color.setFill()
        let currentRect = CGRect(origin: CGPoint(x: CGFloat(i)*width, y: 0), size: CGSize(width: width, height: rect.height))
        UIRectFill(currentRect)
    }
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return (image?.cgImage)!
}



// Blur the input texture (in place if possible) on MTLCommandQueue q, and return the new texture.
// This is a trivial example. It is not necessary or necessarily advised to enqueue a MPSKernel on
// its own MTLCommandBuffer or using its own MTLComputeCommandEncoder. Group work together.

// Here we assume that you have already gotten a MTLDevice using MTLCreateSystemDefaultDevice() or
// MTLCopyAllDevices(), used it to create a MTLCommandQueue with MTLDevice.newCommandQueue, and
// similarly made textures with the device as needed.






//let processedImage = doblurTextureInPlace()


  
  class Changer : UIViewController{
    
    var slider:UISlider!
    var stack:UIStackView!
    var postimageview:UIImageView!
    
    static var device:MTLDevice!
    static var queue:MTLCommandQueue!
    static var buffer:MTLCommandBuffer!
    
    override func loadView() {
        super.loadView()
        stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 0
        self.view = stack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let device = MTLCreateSystemDefaultDevice(), let queue = device.makeCommandQueue(), let buffer = queue.makeCommandBuffer() else {
            fatalError()
        }
        
        Changer.device = device
        Changer.queue = queue
        Changer.buffer = buffer
        
        let cgimage = img()
        var metalTexture:MTLTexture!
        
        do{
        metalTexture = try MTKTextureLoader(device: device).newTexture(cgImage: cgimage, options: nil)
        } catch {
            fatalError()
        }
        
        let oldImage = CIImage(mtlTexture: metalTexture, options: nil)
        
        let preimageview = UIImageView(image: UIImage(cgImage: cgimage))
        preimageview.bounds.size = CGSize(width: 100, height: 100)
        
        postimageview = UIImageView()
        var transformed = Changer.doblurTextureInPlace()
        
        stack.addArrangedSubview(preimageview)
        postimageview.image = transformed
        stack.addArrangedSubview(postimageview)
        
        
        slider = UISlider(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 50)))
        slider.isContinuous = true
        slider.setValue(10, animated: false)
        slider.addTarget(self, action: #selector(change), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.layer.borderColor = UIColor.red.cgColor
        slider.layer.borderWidth = 1.0
        stack.insertArrangedSubview(slider, at: 1)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        postimageview.image = Changer.doblurTextureInPlace()
    }
    
    
      @objc func change(){
          print("changed!",Changer.buffer,slider.value)
        DispatchQueue.global(qos: .default).async {
            let image = Changer.doblurTextureInPlace(blur: self.slider.value)
            
            DispatchQueue.main.async {
                self.postimageview.image = image
            }
        }
        
        //postimageview.image = image
      }
    
    static func myBlurTextureInPlace(inTexture: MTLTexture, blurRadius: Float)
    {
        // Create the usual Metal objects.
        // MPS does not need a dedicated MTLCommandBuffer or MTLComputeCommandEncoder.
        // This is a trivial example. You should reuse the MTL objects you already have, if you have them.
        
        // Create a MPS filter.
        var blur = MPSImageGaussianBlur(device: Changer.device, sigma: blurRadius)
        var buffer = queue.makeCommandBuffer()!
        // Defaults are okay here for other MPSKernel properties (clipRect, origin, edgeMode).
        
        blur.edgeMode = .clamp
        //blur.clipRect = MTLRegion(origin: .init(x: 1, y: 1, z: 1), size: .init(width: 5, height: 5, depth: 5))
        
        // Attempt to do the work in place.  Since we provided a copyAllocator as an out-of-place
        // fallback, we don’t need to check to see if it succeeded or not.
        // See the "Minimal MPSCopyAllocator Implementation" code listing for a sample myAllocator.
        var inPlaceTexture = UnsafeMutablePointer<MTLTexture>.allocate(capacity: 1)
        inPlaceTexture.initialize(to: inTexture)
        
        print(buffer,Changer.buffer)
        
        
        //blur.encode(commandBuffer: Changer.buffer, inPlaceTexture: inPlaceTexture, fallbackCopyAllocator: myAllocator)
        
        blur.encode(commandBuffer: buffer, inPlaceTexture: inPlaceTexture, fallbackCopyAllocator: Changer.myAllocator)
        
        buffer.addCompletedHandler{ _ in
            print("done")
            inPlaceTexture.pointee
            //Changer.buffer = Changer.queue.makeCommandBuffer()
        }
        
        // The usual Metal enqueue process.
        buffer.commit()
        buffer.waitUntilCompleted()           
        //return inPlaceTexture.pointee
        
    }
    
    static func doblurTextureInPlace(blur:Float = 10)->UIImage{
        
        var myImage = img()
        
        do{ 
            var metalTexture = try MTKTextureLoader(device: Changer.device).newTexture(cgImage: myImage, options: nil)
            metalTexture.debugDescription
            
            //print(buffer,device,queue)
            
            Changer.myBlurTextureInPlace(inTexture: metalTexture, blurRadius: blur)
            
            //print("done!",blur.debugDescription)
            let image = CIImage(mtlTexture: metalTexture, options: nil)
            let context = CIContext(mtlDevice: Changer.device)
            let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            context.draw(image!, in: rect, from: rect)
            let imagefromContext = context.createCGImage(image!, from: rect)
            
            return UIImage(cgImage: imagefromContext!)
            
        } catch {
            fatalError("try catch didnt work")
        }
        
    }
    
    static var myAllocator: MPSCopyAllocator =
    {
        (kernel: MPSKernel, buffer: MTLCommandBuffer, texture: MTLTexture) -> MTLTexture in
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: texture.pixelFormat,
                                                                  width: texture.width,
                                                                  height: texture.height,
                                                                  mipmapped: false)
        
        return buffer.device.makeTexture(descriptor: descriptor)!
    }
    
  }
  
  
let viewController = Changer()
  PlaygroundPage.current.liveView = viewController
  







