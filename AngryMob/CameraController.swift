//
//  CameraController.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 27/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


public enum CameraMode {
    case modeAuto
    case modeManual
}

public class CameraController {
    var currentMode = CameraMode.modeManual {
        didSet {
            started = false
            shouldTakePhoto = false
        }
    }
    
    private var startProcessingTime: CFAbsoluteTime = 0.0
    private var processInterval:CFTimeInterval = 0.0
    private var shouldTakePhoto:Bool = false
    var started:Bool = false
    
    
    init() {
        
    }
    
    public func requestPhoto() {
        shouldTakePhoto = true
    }
    
    public func start(timeInterval: CFTimeInterval) {
        processInterval = timeInterval
        started = true
    }
    
    public func stop() {
        started = false
    }
    
    public func canProcessFrame() -> Bool {
        switch currentMode {
        case .modeManual:
            if shouldTakePhoto {
                shouldTakePhoto = false
                return true
            }
            return false
        case .modeAuto:
            let now = CFAbsoluteTimeGetCurrent()
            
            if started && now - startProcessingTime > processInterval {
                startProcessingTime = now
                return true
            }
            return false
            break;
        }
    }
}
