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
    
    let api = APIClient.sharedInstance
    
    func presentEmotion(emotion: EmotionModel) {
        
        self.emotionsChart.removeSlices()
        emotionsChart.models = [
            PieSliceModel(value: Double(emotion.angry ?? 0), color: Colors.afraidColor),
            PieSliceModel(value: Double(emotion.calm ?? 0), color: Colors.amusedColor),
            PieSliceModel(value: Double(emotion.confused ?? 0), color: Colors.astonishedColor),
            PieSliceModel(value: Double(emotion.disgusted ?? 0), color: Colors.boredColor),
            PieSliceModel(value: Double(emotion.happy ?? 0), color: Colors.confusedColor),
            PieSliceModel(value: Double(emotion.sad ?? 0), color: Colors.happyColor),
            PieSliceModel(value: Double(emotion.surprised ?? 0), color: Colors.sadColor)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
