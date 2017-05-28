//
//  HorizontalProgressBarView.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 28/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import UIKit

public class HorizontalProgressView : UIView {
    private let progressColor: UIColor
    
    var percentage: Float {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public required init?(coder: NSCoder) {
        percentage = 0.3
        progressColor = UIColor(red: 228.0 / 256.0,
                                green: 134.0 / 256.0,
                                blue: 36.0 / 256.0,
                                alpha: 1.0)
        
        super.init(coder: coder)
    }
    
    override public func draw(_ rect: CGRect) {
//        super.draw(rect)
        
        let border = UIBezierPath(rect: CGRect(x: rect.size.width * CGFloat(1.0 - percentage),
                                               y: rect.origin.y,
                                               width: CGFloat(percentage) * rect.size.width,
                                               height: rect.size.height))
        progressColor.setFill()
        border.fill()
    }
}
