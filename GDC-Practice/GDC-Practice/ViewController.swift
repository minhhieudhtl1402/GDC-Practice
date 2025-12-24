//
//  ViewController.swift
//  GDC-Practice
//
//  Created by Vtn_mac_mini05 on 23/12/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doComplexTask()
//        doComplexTaskV2()
    }
    
    func doComplexTask() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let group = DispatchGroup()
            
            group.enter()
            doTaskOne {
                print("Task one done")
                group.leave()
            }
            
            group.enter()
            doTaskTwoInBackground {
                print("Task two done in background")
                group.leave()
            }
            
            group.enter()
            doTaskThree {
                print("Task three done")
                group.leave()
            }
            
            group.notify(queue: .main, work: .init(block: {
                print("All things are done!")
            }))
        }
    }
    
    func doComplexTaskV2() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            doTaskOne {
                print("Task one done")
            }
            
            doTaskTwoInBackground {
                print("Task two done in background")

            }
            
            doTaskThree {
                print("Task three done")
            }
        }
    }
    
    func doTaskOne(completion: @escaping () -> Void) {
        print("\(#function) started")
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 3.0)
            completion()
        }
    }
    
    func doTaskTwoInBackground(completion: @escaping () -> Void) {
        print("\(#function) started")
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 3.0)
            completion()
        }
    }
    
    func doTaskThree(completion: @escaping () -> Void) {
        print("\(#function) started")
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 3.0)
            completion()
        }
    }
}

