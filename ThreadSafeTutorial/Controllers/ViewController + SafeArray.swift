//
//  ViewController + SafeArray.swift
//  ThreadSafeTutorial
//
//  Created by Koh Jia Rong on 2019/1/25.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import Foundation

extension ViewController {
    
    //MARK:- Safe Array Test
    
    // Print lines not in order, utilises [Int]() instead of NSMutableArray, run on Main Thread, freezes UI
    // Least preferred method
    func safeArrayTestMethod1() {
        let queue1 = DispatchQueue(label: "com.test.queue1", qos: .background)
        let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background)
        var array = [Int]()
        
        queue1.sync {
            for i in 0..<50000 {
                array.append(i)
                print("queue1: ", i, Thread.current)
            }
        }
        
        queue2.sync {
            for i in 50000..<100000 {
                array.append(i)
                print("queue2: ", i, Thread.current)
            }
        }
    }
    
    // Runs on background thread, does not freeze UI
    // Print lines are in order, and queue2 waits for queue1 to complete before executing
    func safeArrayTestMethod2() {
        let queue1 = DispatchQueue(label: "com.test.queue1", qos: .background, attributes: .concurrent)
        let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, attributes: .concurrent)
        let array = NSMutableArray()
        let condition = NSCondition()
        
        queue1.async {
            for i in 0..<50000 {
                array.add(i)
                print("queue1: ", i, Thread.current)
            }
            condition.signal()
        }
        
        condition.wait()
        
        queue2.async {
            for i in 50000..<100000 {
                array.add(i)
                print("queue2: ", i, Thread.current)
            }
        }
    }
    
    // Runs on background thread, does not freeze UI
    // Print lines not in order, and both queue1 and queue2 executes concurrently
    func safeArrayTestMethod3() {
        let queue1 = DispatchQueue(label: "com.test.queue1", qos: .background, attributes: .concurrent)
        let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, attributes: .concurrent)
        let array = NSMutableArray()
        let lock = NSLock()
        
        queue1.async {
            for i in 0..<50000 {
                //                objc_sync_enter(array)
                lock.lock()
                array.add(i)
                print("queue1: ", i, Thread.current)
                lock.unlock()
                //                objc_sync_exit(array)
            }
        }
        
        queue2.async {
            for i in 50000..<100000 {
                //                objc_sync_enter(array)
                lock.lock()
                array.add(i)
                print("queue2: ", i, Thread.current)
                lock.unlock()
                //                objc_sync_exit(array)
            }
        }
    }
    
    
    // Runs on background thread, does not freeze UI
    // Sync forces the add operation to run sequentially, acheiving similar results with locks.
    func safeArrayTestMethod4() {
        let queue1 = DispatchQueue(label: "com.test.queue1", qos: .background, attributes: .concurrent)
        let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, attributes: .concurrent)
        let queue3 = DispatchQueue(label: "com.test.queue3")
        let array = NSMutableArray()
        
        queue1.async {
            for i in 0..<5000 {
                queue3.sync {
                    array.add(i)
                    print("queue1: ", i, Thread.current)
                }
            }
        }
        
        queue2.async {
            for i in 5000..<10000 {
                queue3.sync {
                    array.add(i)
                    print("queue2: ", i, Thread.current)
                }
            }
        }
    }
    
    // Runs on background thread, does not freeze UI
    // Similar results with Method 2, where queue2 waits for queue1 to complete before executing
    func safeArrayTestMethod5() {
        let queue1 = DispatchQueue(label: "com.test.queue1", qos: .background, attributes: .concurrent)
        let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, attributes: .concurrent)
        let array = NSMutableArray()
        let semaphore = DispatchSemaphore(value: 0)
        
        queue1.async {
            for i in 0..<50000 {
                array.add(i)
                print("queue1: ", i, Thread.current)
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        
        queue2.async {
            for i in 50000..<100000 {
                array.add(i)
                print("queue2: ", i, Thread.current)
            }
        }
    }
}
