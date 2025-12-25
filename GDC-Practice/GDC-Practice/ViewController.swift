//
//  ViewController.swift
//  GDC-Practice
//
//  Created by Vtn_mac_mini05 on 23/12/25.
//

import UIKit
/// Xem xét vì hoạt động chưa đúng
enum TaskStatus: String {
    case notRunning
    case running
    case cancelled
    case completed
}

class ViewController: UIViewController {
    
    var taskStatus: TaskStatus = .notRunning {
        didSet {
            DispatchQueue.main.async {
                self.taskStatusLabel.text = self.taskStatus.rawValue
            }
        }
    }
    @IBOutlet weak var taskStatusLabel: UILabel!
    var work: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskStatus = .notRunning
    }
    
    @IBAction func stopTask(_ sender: Any) {
        work?.cancel()
    }
    
    @IBAction func startTask(_ sender: Any) {
        work = DispatchWorkItem {
            self.taskStatus = .running
            for _ in 0..<10 {
                Thread.sleep(forTimeInterval: 1)
                if self.work?.isCancelled == true {
                    self.taskStatus = .cancelled
                    return
                }
            }
            self.taskStatus = .completed
        }
        guard let work else { return }
        DispatchQueue.global().async(execute: work)
    }
}

