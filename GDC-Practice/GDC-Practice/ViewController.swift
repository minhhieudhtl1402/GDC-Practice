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
        let concurrentQueue = DispatchQueue.global()
        let backgroundWorkItem = DispatchWorkItem(block: {})
        let updateWorkItem = DispatchWorkItem(block: {})
        
        backgroundWorkItem.notify(queue: .main, execute: updateWorkItem)
        concurrentQueue.async(execute: backgroundWorkItem)
    }
}

