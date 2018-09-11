import UIKit
import Metal
import MetalKit
import simd
import GLKit
import PlaygroundSupport

let shaders = """
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
struct VertexIn {
packed_float2 position;
packed_float4 color;
};
struct VertexOut {
float4 position [[position]];
float4 color;
};
vertex VertexOut vertex_main(uint vertexId [[vertex_id]], constant VertexIn *vertices [[buffer(0)]], constant vector_uint2 *viewportSizePointer [[buffer(1)]], constant float4x4 &transformation [[buffer(2)]]) {

VertexOut out;

float4 position = float4(vertices[vertexId].position,0.0,1.0);

float4 transformed = position * transformation;

float2 pixelSpacePosition = transformed.xy;

vector_float2 viewportSize = vector_float2(*viewportSizePointer);

out.position = vector_float4(0.0,0.0,0.0,1.0);

out.position.xy = pixelSpacePosition.xy / (viewportSize / 2.0);

out.color = vertices[vertexId].color;

return out;

}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {

return in.color;

}
"""

struct vertex {
    let position: (Float,Float)
    let color: (Float,Float,Float,Float)
    func floatBuffer()->[Float]{
        return [position.0,position.1,color.0,color.1,color.2,color.3] 
    }
}
5
class MetalRenderer:NSObject,MTKViewDelegate {
    
    var mtkview:MTKView!
    var device:MTLDevice!
    var drawableSize:vector_int2!
    var commandQueue:MTLCommandQueue!
    var pipelineState:MTLRenderPipelineState!
    var link:CADisplayLink!
    let identity:matrix_float4x4 = matrix_float4x4(diagonal: float4(1,1,1,1))
    var rotationMatrix:matrix_float4x4 = matrix_float4x4(diagonal: float4(1,1,1,1))
    var transformationUniform:MTLBuffer!
    var rotationAngle:Float = 0.0
    
    var swiftVertexData = Array<Float>()
    var swiftwhitevertexdata = Array<Float>()
    
    private var touchInProgress:Bool = false
    
    var swiftVertices:[vertex] = [
        vertex(position: (-250,-250), color: (1.0, 0.0, 0.0, 1.0)),
        vertex(position: (250, -250), color: (0.0,1.0,0.0,1.0)),
        vertex(position:(0,250),color:(0.0,0.0,1.0,1.0))
    ]
    
    var swiftVerticesWhite:[vertex] = [
        vertex(position: (-250,-250), color: (1.0, 1.0, 1.0, 1.0)),
        vertex(position: (250, -250), color: (1.0,1.0,1.0,1.0)),
        vertex(position:(0,250),color:(1.0,1.0,1.0,1.0))
    ]
    
    
    
    func setTouchInProgress(_ touchStatus:Bool){
        touchInProgress = touchStatus
    }
    
    
    
    @objc func animationStep(){
        
        rotationAngle += 1.0
        if(rotationAngle>360.0){
            rotationAngle = 0.0
        }
        //rotationAngle
        let glrotationMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(rotationAngle), 1.0, 1.0, 1.0)
        
        //let quart = simd_quatf(rotationMatrix)
        
        let axis:simd_float3 = simd_float3(0.0, 0.0, 1.0)
        
        let originVector = simd_float3(x: 0, y: 0, z: 1)
        
        let angle = GLKMathDegreesToRadians(rotationAngle)
        
        let quaternion = simd_quatf(angle: angle, axis: axis)
        
        let rotated = simd_act(quaternion, axis)
        
        //let transormedVertex = swiftVertexData.map{return quart.act($0)}
        
        //let quart2 = simd_quatf(angle: .pi * GLKMathDegreesToRadians(rotationAngle), axis: )
        
        //rotationMatrix = simd_act(rotated, rotationMatrix)
        
        //reincorporate matrix here
        // assigning the matrix appears to be the expensive operation
        
        rotationMatrix = unsafeBitCast(glrotationMatrix, to: float4x4.self)
        
        //rotationMatrix = identity
        
    }
    
    init(metalView:MTKView,device:MTLDevice){
        super.init()
        self.mtkview = metalView
        self.device = device
        self.mtkview.device = device
        print(device.name)
        metalView.isPaused = true
        commandQueue = device.makeCommandQueue()
        do {
            
            let library = try device.makeLibrary(source: shaders, options: nil)
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.colorAttachments[0].pixelFormat = mtkview.colorPixelFormat
            pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
            pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("error loading shader lib")
        }
        self.mtkview.delegate = self
        
            //not sure cadisplaylink is updating gpu draw method synchronously
        link = CADisplayLink(target: self, selector: #selector(animationStep))
        //link.preferredFramesPerSecond = 5
        link.add(to: .current, forMode: .defaultRunLoopMode)
        
        //var swiftVertexData = Array<Float>()
        //var swiftWhiteVertexData = Array<Float>()
        
        for (index,vertex) in swiftVertices.enumerated(){
            swiftVertexData += vertex.floatBuffer()
            swiftwhitevertexdata += swiftVerticesWhite[index].floatBuffer()
        }
        metalView.isPaused = false
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        drawableSize = vector_int2(Int32(size.width), Int32(size.height))
        print(drawableSize)
    }

    func draw(in view: MTKView) {
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let passDescriptor = view.currentRenderPassDescriptor else { return }
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else { return }
        
        let color = (touchInProgress) ? swiftVertexData : swiftwhitevertexdata
        
        encoder.setVertexBytes(color, length: swiftVertexData.count * MemoryLayout.size(ofValue: swiftVertexData), index: 0)
        
        encoder.setVertexBytes(&drawableSize, length: MemoryLayout.size(ofValue: drawableSize), index: 1)
        
        encoder.setVertexBytes(&rotationMatrix, length: MemoryLayout.size(ofValue: rotationMatrix), index: 2)
        
        encoder.setRenderPipelineState(pipelineState)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
        
    }
    
}

class ViewController:UIViewController{
    
    var renderer:MetalRenderer?
    var link:CADisplayLink!
    
    
    var metalView:MTKView!{
        get{
            return self.view as! MTKView
        }
    }
    
    override func loadView() {
        self.view = MTKView()
        
    }
    
    override func viewDidLoad() {
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            print("no metal")
            return
        }
        
        //setup label
        
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 100)))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = device.name
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 50.0)
        metalView.addSubview(label)
        label.frame
        
        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: metalView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: metalView, attribute: .width, multiplier: 1.0, constant: 0)
            .isActive = true
        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: metalView, attribute: .bottomMargin, multiplier: 1.0, constant: -30).isActive = true
        //metalView.isPaused = true
        //metalView.enableSetNeedsDisplay = false
            renderer = MetalRenderer(metalView: metalView, device: device)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        renderer?.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
    
    var touchInProgress = false {
        didSet{
            renderer?.setTouchInProgress(touchInProgress)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchInProgress = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchInProgress = false
    }
    
}

PlaygroundPage.current.liveView = ViewController()

