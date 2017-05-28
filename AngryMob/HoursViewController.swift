//
//  HoursViewController.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 28/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import UIKit

class HoursViewController: UIViewController {
    
    @IBOutlet var progressBarViews: [HorizontalProgressView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func showHours(ageObject: Hours) {
        let ageArray = ageObject.hoursArray
        var total = 0
        
        for age in ageArray {
            total += age
        }
        
        let startAge = 0
        let endAge = 24
        let dAge = 5
        
        var index = 0
        for progressBar:HorizontalProgressView in progressBarViews {
            let result = ageArray[startAge + index * 2 + 0]
                + ageArray[startAge + index * 2 + 1]
            
            let percentage = Float(result) / Float(total)
            
            progressBar.percentage = percentage
            
            index += 1
        }
    }

}
