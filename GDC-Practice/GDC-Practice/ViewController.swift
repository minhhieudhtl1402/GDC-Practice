//
//  ViewController.swift
//  GDC-Practice
//
//  Created by Vtn_mac_mini05 on 23/12/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        performWorkItemInQueue()
        //        performWorkItemInQueueV2()
        //        performWorkItemInQueueV3()
//        performWorkItemInQueueV4()
        performWorkItemInQueueV5()
    }
    
    func performWorkItem() {
        var value = 5
        let dispatchWorkItem = DispatchWorkItem {
            print("adjust value.....")
            value += 5
        }
        print("before adjust \(value)")
        dispatchWorkItem.perform()
        print("after adjust \(value)")
    }
    
    // Cách này tương đương với việc gọi update ui ở background thread
    func performWorkItemInQueue() {
        let workItem = DispatchWorkItem {
            print("DO heavy work")
            Thread.sleep(forTimeInterval: 5.0)
            print("DO heavy work completed")
            self.displayLabel.text = "Completed"
        }
        let queue = DispatchQueue.global()
        queue.async {
            workItem.perform()
        }
    }
    
    // Chưa được rõ ràng lắm
    func performWorkItemInQueueV2() {
        let workItem = DispatchWorkItem {
            print("DO heavy work")
            Thread.sleep(forTimeInterval: 5.0)
            print("DO heavy work completed")
            DispatchQueue.main.async {
                self.displayLabel.text = "Completed"
            }
        }
        let queue = DispatchQueue.global()
        queue.async {
            workItem.perform()
        }
    }
    
    // rõ ràng hơn tí
    func performWorkItemInQueueV3() {
        let workItem = DispatchWorkItem {
            print("DO heavy work")
            Thread.sleep(forTimeInterval: 5.0)
            print("DO heavy work completed")
        }
        let queue = DispatchQueue.global()
        queue.async {
            workItem.perform()
        }
        
        workItem.notify(queue: .main, execute: .init(block: {
            print("Work item completed,notify main thread")
            self.displayLabel.text = "Completed"
        }))
    }
    
    // Ổn định, chuẩn GDC
    func performWorkItemInQueueV4() {
        let workItem = DispatchWorkItem {
            print("DO heavy work")
            Thread.sleep(forTimeInterval: 5.0)
            print("DO heavy work completed")
        }
        DispatchQueue.global().async(execute: workItem)
        workItem.notify(queue: .main, execute: .init(block: {
            print("Work item completed,notify main thread")
            self.displayLabel.text = "Completed"
        }))
    }
    
    func performWorkItemInQueueV5() {
        let workItem = DispatchWorkItem {
            print("Work start")
            Thread.sleep(forTimeInterval: 1)
            print("Work end")
        }
        
        DispatchQueue.global().async(execute: workItem)
        
        // ⏳ đợi cho workItem xong
        Thread.sleep(forTimeInterval: 5)
        
        // đăng ký notify QUÁ MUỘN
        workItem.notify(queue: .main) {
            print("Notify called")
        }
    }
}

