//: Playground - noun: a place where people can play

import UIKit

if let url = Bundle.main.url(forResource:"VerbsImported", withExtension: "plist") {
    do {
        let data = try Data(contentsOf:url)
        let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
        // do something with the dictionary
        if let value = swiftDictionary["New item"] as? [String:String]{
            print(value)
        }
    } catch {
        print(error)
    }
}




