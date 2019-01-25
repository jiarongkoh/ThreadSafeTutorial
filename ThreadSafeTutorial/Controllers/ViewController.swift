//
//  ViewController.swift
//  ThreadSafeTutorial
//
//  Created by Koh Jia Rong on 2019/1/23.
//  Copyright © 2019 Koh Jia Rong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Safe Array Test", style: .plain, target: self, action: #selector(safeArrayTest))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Safe Read/Write", style: .plain, target: self, action: #selector(safeReadWrite))
        
        view.addSubview(slider)
        slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(toolBar)
        toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
//        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let toolBarItems = [UIBarButtonItem(title: "Basic Thread Safe", style: .plain, target: self, action: #selector(basicTest))
                            ]
        toolBar.items = toolBarItems
    }
    
    @objc func safeReadWrite() {
        let alertController = UIAlertController(title: "Safe Read/Write", message: nil, preferredStyle: .actionSheet)
        let method1 = UIAlertAction(title: "One async", style: .default) { (_) in
            self.threadSafeReadWrite()
        }
        
        let method2 = UIAlertAction(title: "Two asyncs, downloadGroup", style: .default) { (_) in
            self.multipleAsyncsWritesDispatchGroup()
        }
        
        let method3 = UIAlertAction(title: "Read Write Concurrently", style: .default) { (_) in
            self.readAndWriteConcurrently()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [method1, method2, method3, cancelAction].forEach { (action) in
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
        
    }

    @objc func safeArrayTest() {
        let alertController = UIAlertController(title: "Safe Array Test", message: nil, preferredStyle: .actionSheet)
        let method1 = UIAlertAction(title: "Method 1", style: .default) { (_) in
            self.safeArrayTestMethod1()
        }
        
        let method2 = UIAlertAction(title: "Method 2", style: .default) { (_) in
            self.safeArrayTestMethod2()
        }
        
        //Using locks inside async operations
        let method3 = UIAlertAction(title: "Method 3", style: .default) { (_) in
            self.safeArrayTestMethod3()
        }
        
        //Wrapping sync operations inside async operations
        let method4 = UIAlertAction(title: "Method 4", style: .default) { (_) in
            self.safeArrayTestMethod4()
        }
        
        let method5 = UIAlertAction(title: "Method 5", style: .default) { (_) in
            self.safeArrayTestMethod5()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [method1, method2, method3, method4, method5, cancelAction].forEach { (action) in
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func basicTest() {
        let alertController = UIAlertController(title: "Basic Thread Safe Test", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let method1 = UIAlertAction(title: "Thread Safe 1", style: .default) { (_) in
            self.threadSafe1()
        }
        
        let method2 = UIAlertAction(title: "Thread Safe 2", style: .default) { (_) in
            self.threadSafe2()
        }

        [cancelAction, method1, method2].forEach { (action) in
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
}

