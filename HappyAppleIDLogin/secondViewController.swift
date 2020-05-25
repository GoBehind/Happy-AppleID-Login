//
//  secondViewController.swift
//  HappyAppleIDLogin
//
//  Created by 王冠之 on 2020/5/24.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = user?.debugDescription ?? ""
    }
}
