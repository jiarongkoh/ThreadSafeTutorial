//
//  ViewController + ReadWrite.swift
//  ThreadSafeTutorial
//
//  Created by Koh Jia Rong on 2019/1/25.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import Foundation

extension ViewController {
    
    //MARK:- Read and Write
    
    // http://basememara.com/creating-thread-safe-arrays-in-swift/
    // Classic Read Write Lock.
    // Implement writes asynchronously with a barrier before reading synchronously or asynchronously
    @objc func threadSafeReadWrite() {
        let queue = DispatchQueue(label: "MyArrayQueue", qos: .background, attributes: .concurrent)
        let array = NSMutableArray()
        
        //Background
        queue.async(flags: .barrier) {
            for i in 0..<50000 {
                array.add(i)
                print("write", i, Thread.current)
            }
        }
        
        //This performs on main if called sync
        //But performs on background if called async
        queue.async {
            for i in 0..<array.count {
                print("read", array[i], Thread.current)
            }
        }
    }
    
    //Writes on different background thread
    //Read from another background thread
    //Note that queue3 can be replaced with locks to acheive similar results
    //This function waits for all write operations to complete prior to executing the read operation
    func multipleAsyncsWritesDispatchGroup() {
        let queue1 = DispatchQueue(label: "com.test.queue1", qos: .background, attributes: .concurrent)
        let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, attributes: .concurrent)
        let queue3 = DispatchQueue(label: "com.test.queue3")
        
        let array = NSMutableArray()
        
        let downloadGroup = DispatchGroup()
        
        downloadGroup.enter()
        queue1.async {
            for i in 0..<5000 {
                queue3.sync {
                    array.add(i)
                    print("queue1: ", i, Thread.current)
                }
            }
            downloadGroup.leave()
        }
        
        downloadGroup.enter()
        queue2.async {
            for i in 5000..<10000 {
                queue3.sync {
                    array.add(i)
                    print("queue2: ", i, Thread.current)
                }
            }
            
            downloadGroup.leave()
        }
        
        downloadGroup.notify(queue: DispatchQueue.global(qos: .background)) {
            for i in 0..<array.count {
                print("read", array[i], Thread.current)
            }
        }
    }
    
    //This function attempts to simulate reading while writing to a shared resource.
    //A asyncAfter is implemented to simulate another thread reading the shared resource
    func readAndWriteConcurrently() {
        let queue1 = DispatchQueue(label: "com.test.queue1", qos: .background, attributes: .concurrent)
        let queue2 = DispatchQueue(label: "com.test.queue2", qos: .background, attributes: .concurrent)
        
        let array = NSMutableArray()
        //        let lock = NSLock()
        
        queue1.async {
            for i in 0..<500 {
                self.synchronized(array, closure: {
                    array.add(i)
                    print("queue1", i, Thread.current)
                })
            }
        }
        
        queue2.async {
            for i in 500..<1000 {
                self.synchronized(array, closure: {
                    array.add(i)
                    print("queue2", i, Thread.current)
                })
            }
        }
        
        //Note that by applying locks outside the for loop, the read access will cluster together, almost appearing
        //that the writing has paused until the read operation completes.
        //Applying lockcs inside the for loop will appear that read and write are still happening concurrently.
        let delay: TimeInterval = 0.001
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + delay) {
            self.synchronized(array, closure: {
                for i in 0..<array.count {
                    //                    objc_sync_enter(array)
                    //                    lock.lock()
                    
                    print("Access", array[i], Thread.current)
                    //                    lock.unlock()
                    //                    objc_sync_exit(array)
                }
            })
        }
    }
    
    //Courtesy of Liu Hui
    func synchronized(_ lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    func myMethodLocked(anObj: AnyObject!) {
        synchronized(anObj) {
            // 在括号内 anObj 不会被其他线程改变
        }
    }
    
    
}
