//
//  ViewController.swift
//  GDC-Practice
//
//  Created by Vtn_mac_mini05 on 23/12/25.
//

import UIKit

class ViewController: UIViewController {
    
    let urls: [String] = [
        "https://api.example.com/1",
        "https://api.example.com/2",
        "https://api.example.com/3"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doHeavyWork()
    }
}

enum APIError: Error {
    case networkError
    case invalidData
}
// MARK: Use Dispatch group on Some queues
extension ViewController {
    func doHeavyWork() {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            
            // Work items
            let miniWork1 = DispatchWorkItem {
                print("miniWork1 start")
                Thread.sleep(forTimeInterval: 5)
                print("miniWork1 completed")
            }
            
            let miniWork2 = DispatchWorkItem {
                print("miniWork2 start")
                Thread.sleep(forTimeInterval: 3)
                print("miniWork2 completed")
            }
            
            let miniWork3 = DispatchWorkItem {
                print("miniWork3 start")
                Thread.sleep(forTimeInterval: 4)
                print("miniWork3 completed")
            }
            
            // Queues
            let queue1 = DispatchQueue(label: "com.vmhieu.queue1")
            let queue2 = DispatchQueue(label: "com.vmhieu.queue2")
            let queue3 = DispatchQueue(label: "com.vmhieu.queue3")
            
            // Dispatch work items with group
            queue1.async(group: group, execute: miniWork1)
            queue2.async(group: group, execute: miniWork2)
            queue3.async(group: group, execute: miniWork3)
            
//            // Notify on main when all done
//            group.notify(queue: .main) {
//                print("✅ All work items completed")
//            }
            /// cách này biểu thị hơi khó hiểu
//            if group.wait(timeout:  .now() + 60) == .timedOut {
//                print("The jobs didn’t finish in 60 seconds")
//            }
            let result = group.wait(timeout: .now() + DispatchTimeInterval.seconds(60))
            switch result {
            case .success:
                print("✅ All jobs finished in time")
            case .timedOut:
                print("⏰ The jobs didn’t finish in 60 seconds")
            }
        }
    }
}


// MARK: Fetch Data
extension ViewController {
    func fetchData(from url: String, completion: @escaping (Result<String, APIError>) -> Void) {
        print("Start \(#function) url \(url)")
        Thread.sleep(forTimeInterval: 3)
        let isOk = Bool.random()
        if isOk {
            completion(.success("Data from \(url)"))
        } else {
            completion(.failure(.invalidData))
        }
    }
    
    func fetchV2() {
        var results: [String: Result<String, APIError>] = [:]
        let group = DispatchGroup()
        let executeQueue = DispatchQueue(label: "com.vmhieu.v2",qos: .utility, attributes: .concurrent)
        let writeSerialQueue = DispatchQueue(label: "com.vmhieu.serial")
        for url in urls {
            group.enter()
            let workItem = DispatchWorkItem {
                self.fetchData(from: url) { result in
                    /// Concept:
                    /// Serialization / Serializing access
                    /// Thread confinement
                    /// Queue-based synchronization
                    
                    writeSerialQueue.async {
                        results[url] = result
                        group.leave()
                    }
                }
            }
            executeQueue.async(execute: workItem)
        }
        
        group.notify(queue: .main) {
            print("fetch done")
            for (url, result) in results {
                switch result {
                case .success(let data):
                    print("✅ \(url) -> \(data)")
                case .failure(let error):
                    print("❌ \(url) -> \(error)")
                }
            }
        }
    }
    
    func fetchV1() {
        var results: [String: Result<String, APIError>] = [:]
        let lock = NSLock()
        let group = DispatchGroup()
        
        let executeQueue = DispatchQueue(label: "com.vmhieu", attributes: .concurrent)
        for url in urls {
            group.enter()
            let workItem = DispatchWorkItem {
                self.fetchData(from: url) { result in
                    /// Wrap in lock.lock() & lock.unlock to guarantee write in only one thread
                    lock.lock()
                    results[url] = result
                    lock.unlock()
                    group.leave()
                }
            }
            executeQueue.async(execute: workItem)
        }
        
        group.notify(queue: .main) {
            print("fetch done")
            for (url, result) in results {
                switch result {
                case .success(let data):
                    print("✅ \(url) -> \(data)")
                case .failure(let error):
                    print("❌ \(url) -> \(error)")
                }
            }
        }
    }
}

