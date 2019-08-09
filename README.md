# Playgrounds

Playgrounds for iPad is an amazing app for trying out techniques and prototyping ideas. There's limited options for importing external files such as Storyboards, so all UI needs to be created, laid out and constrained in code.

Most of the following were created using Swift Playgrounds for iPad and might require some tweaking to run in Xcode Playgrounds.

## Labs

* Ladders - A work in progress. Snakes and ladders / Chutes and ladders game implemented in Playgrounds 3. 

## 3D Graphics

* Metal - Hello Triangle - A very slow but fully working example of how to implement `Metal` within Playgrounds, complete with shader! - Will Probably need Swift Playgrounds on iPad to run as Metal requires a physical device and won't run in a simulator, but could be adapted to the Mac.

* SceneKit Blender Import - Example of imported scene created with Blender and tweaked with Xcode scene editor.

* SceneKit `simd` quaternion rotation - example of using quaternions to rotate an object around a sphere.

## Metal Performance Shaders

* `MetalPerformanceShaders` implementation of Gaussian Blur function, with interactive slider.

## Augmented Reality

* ARKit ImageTracking - Setup an `ARKit` session to look for `ARReferenceImages` within Playgrounds.

## Playground Support

* Size of Liveview, a prototype updating view showing the dimensions of the `PlaygroundSupport` liveview.

## API Data

* Pokemon animation - DispatchGroup and URLSessions used to do requests to an open Pokemon data API. Presents results as looping animation when done.

## User Interface

* UIKit - Basic implementation of common controls; `UITableView`, `UICollectionView` utilising `UICollectionViewFlowLayout`

* ColorPicker - An 'app within an app'. Create RGBA colors with sliders and export via string to Swift and Objective-C `UIColor`. `UIStackView` used for layout with various `UIKit` controls for input.

* Card Screen - A Tinder style animated card screen with spring animations.

## Drawing and Animation

* CA Orrery - A solar system animation created with `Core Animation`

* Animations with layout constraints and visual layout.

* Apple Park Drawing - Core Graphics drawing with CAGradientLayer masking.

* Spring Animation vs. Ease-In-Out - Simple demo of two types of animation timing. Remember to use spring animations!

## General Techniques / Foundation

* Timers, Implemented with `Timer` and `CADisplayLink`

* Codec - Decoding and encoding of nested JSON REST API response using `Codable`

* GCD Threading - `Grand Central Dispatch` example

* `URLSession` synchronous request.

## Templates

* Starting points for Playgrounds based on `UIViewController`, `UINavigationController` and `ARKit` (`SceneKit` and `SpriteKit` Views)


### Techniques Used
`UIKit` `CoreAnimation` `CoreGraphics` `SceneKit` `ARKit` `Metal` `simd` `GLKit` `PlaygroundSupport`
