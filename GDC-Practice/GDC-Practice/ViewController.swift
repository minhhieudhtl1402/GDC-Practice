//
//  ViewController.swift
//  GDC-Practice
//
//  Created by Vtn_mac_mini05 on 23/12/25.
//

import UIKit

class ViewController: UIViewController {
    private var sharedValue: Int = 0
    
    private var number: Int = 0
    private var strings: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        raceConditionV2()
    }
    
    func raceCondition() {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            
            let someQueue = DispatchQueue(label: "someQueue", attributes: .concurrent)
            group.enter()
            someQueue.async {
                for _ in 0...10 {
                    self.sharedValue += 1
                    print("❤️ shareValue \(self.sharedValue)")
                }
                group.leave()
            }
            
            let anotherQueue = DispatchQueue(label: "anotherQueue", attributes: .concurrent)
            group.enter()
            anotherQueue.async {
                for _ in 0...10 {
                    self.sharedValue += 1
                    print("🥥 shareValue \(self.sharedValue)")
                }
                group.leave()
            }
            group.wait()
            print("Shared after alter \(self.sharedValue)")
        }
    }
    
    func raceConditionV2() {
        let concurrentQueue = DispatchQueue(label: "", attributes: .concurrent)
        // Thread 1
        concurrentQueue.async {
            for _ in 0...10 {
                self.number += 1
                self.strings["🔴 \(self.number)"] = self.number
                print("🔴: \(self.number)")
            }
        }
        
        // Thread 2
        concurrentQueue.async {
            for _ in 0...10 {
                self.number += 1
                self.strings["🔵 \(self.number)"] = self.number
                print("🔵: \(self.number)")
            }
        }
        
        // show result after 3.0 secs
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Number = \(self.number)")
            for item in self.strings {
                print(item)
            }
        }
    }
}

