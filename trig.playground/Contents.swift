//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 SOH sin = opp / hyp
 CAH cos = adj / hyp
 TOA tan = opp / adj
 */

class Triangle {
    
    var o:Float,a:Float,h:Float
    let rightAngle:Float = 90.0;
    
    var oa:Float?,aa:Float?
    var area:Float?
    var sum:Float?
    
    init(_ so:Float,_ sa:Float) {
        o = so
        a = sa
        h = Triangle.doHyp(o: o, a: a)
    }
    
    static func doHyp(o:Float,a:Float)->Float{
        let h2 = pow(o, 2) + pow(a,2)
        return sqrt(h2)
    }
    
    static func radToDegrees(_ degrees:Float)->Float{
        return (degrees * 180 / .pi)
    }
    
    func recalculate(){
        
        area = o * a / 2
        
        oa = Triangle.radToDegrees(asin(o / h))
        aa = Triangle.radToDegrees(atan(a / o))
        
        
        sum = oa! + aa! + rightAngle
        
    }
    
}

var myTriangle = Triangle(20,34)
myTriangle.recalculate()
print(myTriangle.oa!,myTriangle.aa!,myTriangle.sum!,"area = \(myTriangle.area!)")
