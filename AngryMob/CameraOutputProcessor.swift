//
//  CameraOutputProcessor.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 27/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


public class CameraOutputProcessor {
    private let processInterval:CFTimeInterval
    private var isProcessingFrame: Bool
    private var startProcessingTime: CFAbsoluteTime;
    
    
    public init (processInterval:CFTimeInterval) {
        self.processInterval = processInterval
        self.isProcessingFrame = false
        self.startProcessingTime = 0.0
    }
    
    
    public func processFrameToJpg(sampleBuffer: CMSampleBuffer!, complitionClosure: @escaping (Data)->(Void)) {
        
        let now = CFAbsoluteTimeGetCurrent()
        
        if (!isProcessingFrame && now - startProcessingTime > processInterval) {
            startProcessingTime = now
            isProcessingFrame = true
            let data = fromBufferToJpg(sampleBuffer: sampleBuffer);
            
            DispatchQueue.main.async {
                complitionClosure(data)
            }
            isProcessingFrame = false
        }
    }
    
    private func fromBufferToJpg(sampleBuffer: CMSampleBuffer!) -> Data {
        let frameTime = CFAbsoluteTimeGetCurrent();
        
        let pixelBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        
        let pixelBufferWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let pixelBufferHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let imageRect:CGRect = CGRect(x: 0,
                                      y: 0,
                                      width: pixelBufferWidth,
                                      height: pixelBufferHeight)
        let ciContext = CIContext.init()
        let cgimage = ciContext.createCGImage(ciImage, from: imageRect )!
        
        let image = UIImage(cgImage: cgimage)
        
        let data = UIImageJPEGRepresentation(image, 0.9)!
        
        print("Processing took: \(CFAbsoluteTimeGetCurrent() - frameTime)")
        
        return data
    }
}
