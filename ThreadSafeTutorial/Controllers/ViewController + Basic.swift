//
//  ViewController + Basic.swift
//  ThreadSafeTutorial
//
//  Created by Koh Jia Rong on 2019/1/25.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import Foundation

extension ViewController {
    
    //MARK:- Basic Thread Safe
    
    func threadSafe1() {
        let queue = DispatchQueue.global(qos: .default)
        
        var total = 1
        let lock = NSLock()
        
        for i in 0..<3 {
            queue.async {
                print("Executing \(i)")
                
                lock.lock() //Lock will hold the thread until the execution is finished
                total += 1
                print("Total + \(i): ", total, Thread.current)
                
                total -= 1
                print("Total - \(i): ", total, Thread.current)
                lock.unlock() //Whenver there is lock(), there must be unlock()
            }
        }
    }
    
    func threadSafe2() {
        let queue = DispatchQueue.global(qos: .default)
        
        let lock = NSLock()
        var array = [Int]()
        
        for x in 0..<3 {
            queue.async {
                lock.lock() //Removing lock() will crash the app
                for y in 0..<10 {
                    array.append(y)
                    print("\(x) \(y) + :", array, Thread.current)
                }
                
                for i in (0..<array.count).reversed() {
                    array.remove(at: i)
                    print("\(x) \(i) - :", array, Thread.current)
                }
                lock.unlock()
            }
        }
    }
    
}
