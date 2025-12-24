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
        delayTask()
    }
    
}

// MARK: Delay Task
extension ViewController {
    func delayTask() {
        let queue = DispatchQueue(label: "vmhieu-delay", qos: .userInitiated)
        
        print("Current time \(Date())")
        let additionalTimeInterval: DispatchTimeInterval = .seconds(5)
        let additionalTime: DispatchTime = .now()  + additionalTimeInterval
        queue.asyncAfter(deadline: additionalTime, execute: .init(block: {
            print("after additional time \(Date())")
        }))
    }
}

// MARK: Initial Activate
extension ViewController {
    func initialActivateConcurrentQueue() {
        print(#function)
        let queue = DispatchQueue(label: "vmhieuios", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
        // dự đoán deadlock không vì là concurrent queue?
        // Dự đoán : Vẫn deadlock,vì gọi sync sẽ block thread đang gọi và queue sẽ chờ block thực thi xong,nhưng queue chưa dc activate // lời giải thích này chưa đúng 100%
        //Giải thích đúng: Deadlock xảy ra vì lời gọi sync sẽ chặn thread hiện tại cho đến khi block được thực thi,trong khi đó queue được tạo với .intitiatedActivate nên không thể thực thi block cho đến khi được activate().. Do thread đang bị chặn nên activate() không bao giờ được gọi -> Deadlock  => Nghĩa là đang chờ 1 thằng ko bao giờ thực thi
        queue.sync {
            for i in 0...10 {
                print("😎 \(i)")
            }
        }
        
        queue.sync {
            for i in 20...30 {
                print("🥶 \(i)")
            }
        }
        
        queue.activate()
    }
}
