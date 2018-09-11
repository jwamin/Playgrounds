# Playgrounds

Playgrounds for iPad is an amazing app for trying out techniques and prototyping ideas. There's limited options for importing external files such as Storyboards, so all UI needs to be created, laid out and constrained in code.

Most of the following were created using Swift Playgrounds for iPad and might require some tweaking to run in Xcode Playgrounds.

## 3D Graphics

* Metal - Hello Triangle - A very slow but fully working example of how to implement `Metal` within Playgrounds, complete with shader! - Will Probably need Swift Playgrounds on iPad to run as Metal requires a physical device and won't run in a simulator, but could be adapted to the Mac.

* SceneKit Blender Import - Example of imported scene created with Blender and tweaked with Xcode scene editor.

* SceneKit `simd` quaternion rotation - example of using quaternions to rotate an object around a sphere.

## Augmented Reality

* ARKit ImageTracking - Setup an `ARKit` session to look for `ARReferenceImages` within Playgrounds.

## User Interface

* ColorPicker - An 'app within an app'. Create RGBA colors with sliders and export via string to Swift and Objective-C `UIColor`. `UIStackView` used for layout with various `UIKit` controls for input.

* Card Screen - A Tinder style animated card screen with spring animations.

## Drawing and Animation

* CA Orrery - A solar system animation created with `Core Animation`

* Apple Park Drawing - Core Graphics drawing with CAGradientLayer masking.

* Spring Animation vs. Ease-In-Out - Simple demo of two types of animation timing. Remember to use spring animations!

## General Techniques

* Timers, Implemented with `Timer` and `CADisplayLink`

* GCD Threading - `Grand Central Dispatch` example

* `URLSession` synchronous request.

## Templates

* Starting points for Playgrounds based on `UIViewController`, `UINavigationController` and `ARKit` (`SceneKit` and `SpriteKit` Views)


### Techniques Used
`UIKit` `CoreAnimation` `CoreGraphics` `SceneKit` `ARKit` `Metal` `simd` `GLKit` `PlaygroundSupport`
