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
        //        /// việc gọi sync thế này đang block main thread,dễ gây ảnh hưởng UI
        DispatchQueue.global().sync {
            Thread.sleep(forTimeInterval: 5)
            DispatchQueue.main.async {
                UIView.animate(withDuration: 2.0) { // 2 giây animation
                    self.view.backgroundColor = .red
                }
            }
        }

    }
}

