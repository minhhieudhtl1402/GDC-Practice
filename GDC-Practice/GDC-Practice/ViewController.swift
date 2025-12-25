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
        taskStatus = .cancelled
    }
    
    @IBAction func startTask(_ sender: Any) {
        work = DispatchWorkItem {
            self.taskStatus = .running
            Thread.sleep(forTimeInterval: 10)
            self.taskStatus = .completed
        }
        guard let work else { return }
        DispatchQueue.global().async(execute: work)
    }
}

