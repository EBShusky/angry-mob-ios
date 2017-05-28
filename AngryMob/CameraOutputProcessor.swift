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
    private var isProcessingFrame: Bool
    
    public init () {
        self.isProcessingFrame = false
    }
    
    public func processFrameToJpg(sampleBuffer: CMSampleBuffer!, complitionClosure: @escaping (Data)->(Void)) -> Bool {        
        if (!isProcessingFrame) {
            isProcessingFrame = true
            let data = fromBufferToJpg(sampleBuffer: sampleBuffer);
            
            DispatchQueue.main.async {
                complitionClosure(data)
            }
            isProcessingFrame = false
            
            return true
        }
        
        return false
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
