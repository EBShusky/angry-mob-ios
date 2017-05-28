//
//  FlashView.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 27/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import UIKit

public class FlashView : UIView {
    
    public override func draw(_ rect: CGRect) {
        let border = UIBezierPath(rect: rect)
        border.lineWidth = 6
        UIColor.white.setStroke()
        border.stroke()
    }
}
