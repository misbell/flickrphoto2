//
//  MyExtensions.swift
//  FlickrSearch
//
//  Created by prenez on 4/15/15.
//  Copyright (c) 2015 Prenezsoft. All rights reserved.
//

import UIKit

protocol MyView {
    func a()
    func b()
}

extension Double {
        var km: Double {return self * 1_000.0 }
}

extension UIView: MyView {
    

    
    
    func printMyName(name: String) {
        print(" name is \(name)")
    }
    
    func a() {
        
    }
    
    func b() {
        
    }
    
}

class aa {

    var x: String?
    var xx: String
    
    init () {
        
        xx = ""
        
    }
    
    init(red rred: String) {
        
        var x = rred
        xx = ""
    }

}

var ax = aa(red: "ok")




class ab {
    var xx: String?
    
}

class ad {
      var width = 0.0, height = 0.0

}

// no memberwise init on classes, must be defined
//let tbt  = ad(width: 2.0, height: 2.0)



// structure types have memberwise initializers
// even if they dont' define custom initializers
//initializes the properties of new structure instances

struct Size {
    var width = 0.0, height = 0.0

}

struct Point {
    var x = 0.0, y = 0.0
    
}

// notice, defining the properties defines the memberwise initializer
let twobytwo = Size(width: 2.0, height: 2.0)
let zerosize = Size()

struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    
    init (origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    init (center: Point, size: Size) {
        
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // notice it's calling the initializer here
        self.init (origin: Point(x: originX, y: originY), size: size)
        
    }
    
}

// back to classes
// default initializer
// designated initializers
// convenienve initializers

// designated are primary initializers for the class
// usually only one per class

// convenience are secondary supporting


// designated
// 1. initialized all properites
// 2. calls a superclass initializer
// delegates up

// convenience
// can call designated initializer
// not required if not needed
// delegates across

class an {
    var width: Double, height: Double
    
    init (width: Double, height: Double) {
        
        // root class, no super init
        
        self.width = width
        self.height = height
        
    }
    
    convenience init (w: Double, h: Double) {
        
        // do other stuff
        // but no calls to super
        
        self.init (width: w , height: h )
    }
    
    
}

// next two phase intitialization









































