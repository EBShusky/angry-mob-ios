//
//  AgeViewController.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 28.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import UIKit
import Charts

class AgeViewController: UIViewController {
    @IBOutlet var progressBarViews: [HorizontalProgressView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func showAge(ageObject: Age) {
        let ageArray = ageObject.ageArray
        var total = 0
        
        for age in ageArray {
            total += age
        }
        
        let startAge = 5
        let endAge = 65
        let dAge = 5
        
        var index = 0
        for progressBar:HorizontalProgressView in progressBarViews {
            let result = ageArray[startAge + index * 5 + 1]
            + ageArray[startAge + index * 5 + 2]
            + ageArray[startAge + index * 5 + 3]
            + ageArray[startAge + index * 5 + 4]
            + ageArray[startAge + index * 5 + 5]
            
            let percentage = Float(result) / Float(total)
            
            progressBar.percentage = percentage
            
            index += 1
        }
    }
}
