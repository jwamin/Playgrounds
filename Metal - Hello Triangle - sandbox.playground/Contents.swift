import UIKit
import Metal
import MetalKit
import simd
import PlaygroundSupport

let DEBUG = false;

let debug_shader = """
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
struct VertexIn {
packed_float3 position;
packed_float3 color;
};
struct VertexOut {
float4 position [[position]];
float4 color;
};
vertex VertexOut vertex_main(uint vertexId [[vertex_id]], constant VertexIn *vertices [[buffer(0)]]) {

VertexOut out;

out.position = float4(vertices[vertexId].position, 1);

out.color = float4(vertices[vertexId].color, 1);

return out;

}
fragment float4 fragment_main(VertexOut in [[stage_in]]) {
return in.color;
}
"""


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
vertex VertexOut vertex_main(uint vertexId [[vertex_id]], constant VertexIn *vertices [[buffer(0)]], constant vector_uint2 *viewportSizePointer [[buffer(1)]]) {

VertexOut out;

float2 pixelSpacePosition = vertices[vertexId].position;

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

class MetalRenderer:NSObject,MTKViewDelegate {
    
    var mtkview:MTKView!
    var device:MTLDevice!
    var drawableSize:vector_int2!
    var commandQueue:MTLCommandQueue!
    var pipelineState:MTLRenderPipelineState!
    private var touchInProgress:Bool = false
    
    func setTouchInProgress(){
        touchInProgress = !touchInProgress
    }
    
    
    init(metalView:MTKView,device:MTLDevice){
        super.init()
        self.mtkview = metalView
        self.device = device
        self.mtkview.device = device
        print(device.name)
        
        commandQueue = device.makeCommandQueue()
        do {
            
            let shader = (DEBUG) ? debug_shader : shaders
            
            let library = try device.makeLibrary(source: shader, options: nil)
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.colorAttachments[0].pixelFormat = mtkview.colorPixelFormat
            pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
            pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("error loading shader lib")
        }
        self.mtkview.delegate = self
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        drawableSize = vector_int2(Int32(size.width), Int32(size.height))
        print(drawableSize)
    }

    func draw(in view: MTKView) {
        
        print(pipelineState)
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let passDescriptor = view.currentRenderPassDescriptor else { return }
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else { return }
        
//          var triangleVertices:[Float] = [-250,-250,1,0,0,1,
//                                          250,-250,0,1,0,1
//              ,0,250,0,0,1,1]
//          
//          var whitetriangleVertices:[Float] = [
//              250,-250,1,1,1,1,
//              -250,-250,1,1,1,1,
//              0,250,1,1,1,1
//          ]
        
        var swiftVertices:[vertex] = [
            vertex(position: (-250,-250), color: (1.0, 0.0, 0.0, 1.0)),
            vertex(position: (250, -250), color: (1.0,1.0,0.0,1.0)),
            vertex(position:(0,250),color:(1.0,0.0,1.0,1.0))
        ]
        
        
        var swiftVerticesWhite:[vertex] = [
            vertex(position: (-250,-250), color: (1.0, 1.0, 1.0, 1.0)),
            vertex(position: (250, -250), color: (1.0,1.0,1.0,1.0)),
            vertex(position:(0,250),color:(1.0,1.0,1.0,1.0))
        ]
        
        var swiftVertexData = Array<Float>()
        var swiftWhiteVertexData = Array<Float>()
        
        for (index,vertex) in swiftVertices.enumerated(){
            swiftVertexData += vertex.floatBuffer()
            swiftWhiteVertexData += swiftVerticesWhite[index].floatBuffer()
        }
        print(swiftWhiteVertexData)
        //print(swiftVertexData,triangleVertices, swiftVertexData==triangleVertices)
        let pointer = withUnsafeMutablePointer(to: &swiftVertices, {UnsafeMutablePointer<Void>($0)})
        
        print(pointer)
        
        let vertexData: [Float] = [ 
            -0.5, -0.5, 0, 1, 0, 0,
            0.5, -0.5, 0, 0, 1, 0,
            0,  0.5, 0, 0, 0, 1 ];
        
        //let vertices = (DEBUG) ? vertexData : triangleVertices
        
        let color = (touchInProgress) ? swiftVertexData : swiftWhiteVertexData
        
        encoder.setVertexBytes(color, length: swiftVertexData.count * MemoryLayout.size(ofValue: swiftVertexData), index: 0)
        
        //encoder.setVertexBytes(pointer, length: MemoryLayout.size(ofValue: pointer), index: 0)
        
        encoder.setVertexBytes(&drawableSize, length: MemoryLayout.size(ofValue: drawableSize), index: 1)
        
        //print(drawableSize!)
        //print(MemoryLayout<Float>.stride,vertexData.count * MemoryLayout<Float>.stride)
        //print(triangleVertices,triangleVertices.count*MemoryLayout.size(ofValue: triangleVertices))
        
        encoder.setRenderPipelineState(pipelineState)
        
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
        
    }
    
}

class ViewController:UIViewController{
    
    var renderer:MetalRenderer?
    
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
        
            renderer = MetalRenderer(metalView: metalView, device: device)
        renderer?.mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        renderer?.mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
    
    var touchInProgress = false {
        didSet{
            renderer?.setTouchInProgress()
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

