//
//  ViewController.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 26.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    let api = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "istock_businessman")
        let data = UIImageJPEGRepresentation(image!, 1.0)
        
        api.uploadImage(image: data!, fileName: "")
    }

}
