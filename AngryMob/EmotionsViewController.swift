//
//  EmotionsViewController.swift
//  AngryMob
//
//  Created by Wiktor Wielgus on 28.05.2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import PieCharts



class EmotionsViewController: UIViewController {
    
    @IBOutlet weak var emotionsChart: PieChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emotionsChart.models = [
            PieSliceModel(value: 60, color: Colors.afraidColor),
            PieSliceModel(value: 40, color: Colors.amusedColor),
            PieSliceModel(value: 60, color: Colors.astonishedColor),
            PieSliceModel(value: 40, color: Colors.boredColor),
            PieSliceModel(value: 60, color: Colors.confusedColor),
            PieSliceModel(value: 40, color: Colors.happyColor),
            PieSliceModel(value: 60, color: Colors.sadColor)
        ]
    }
}
