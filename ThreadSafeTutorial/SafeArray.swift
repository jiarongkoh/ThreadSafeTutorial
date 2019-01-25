//
//  SafeArray.swift
//  ThreadSafeTutorial
//
//  Created by Koh Jia Rong on 2019/1/23.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

// NOT COMPLETE
import Foundation

class SafeArray: NSMutableArray {
    
    var array: [AnyObject] = []
    let queue = DispatchQueue(label: "concurrentQueue", qos: .default, attributes: .concurrent)
    
    override var count: Int {
        get {
            return array.count
        }
    }
    
    override func object(at index: Int) -> Any {
        return array[index]
    }
    
    override func insert(_ anObject: Any, at index: Int) {
        
    }
    
    override func removeObject(at index: Int) {
        
    }
    
    override func add(_ anObject: Any) {
        queue.sync {
            array.append(anObject as AnyObject)
        }
    }
    
    override func removeLastObject() {
        
    }
    
    override func remove(_ anObject: Any) {
        
    }
    
}
