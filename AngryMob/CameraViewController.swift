//
//  CameraViewController.swift
//  AngryMob
//
//  Created by Radoslaw Halski on 27/05/2017.
//  Copyright © 2017 AngryMobTeam. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    @IBOutlet weak var cameraHolderView: UIView!
    
    let api = APIClient()
//    var previewView : UIView!
    var boxView:UIView!
    let myButton: UIButton = UIButton()
    
    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    
    let cameraProcessor = CameraOutputProcessor(processInterval: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        previewView = UIView(frame: CGRect(x: 0,
//                                           y: 0,
//                                           width: UIScreen.main.bounds.size.width,
//                                           height: UIScreen.main.bounds.size.height))
        cameraHolderView.contentMode = UIViewContentMode.scaleAspectFit
        
        //Add a view on top of the cameras' view
        boxView = UIView(frame: self.view.frame)
        
        view.addSubview(boxView)
        view.addSubview(myButton)
        
        self.setupAVCapture()
    }
    
    deinit {
        stopCamera()
    }
}

// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
extension CameraViewController:  AVCaptureVideoDataOutputSampleBufferDelegate{
    func setupAVCapture(){
        session.sessionPreset = AVCaptureSessionPreset1920x1080
        guard let device = AVCaptureDevice
            .defaultDevice(withDeviceType: .builtInWideAngleCamera,
                           mediaType: AVMediaTypeVideo,
                           position: .back) else{
                            return
        }
        captureDevice = device
        beginSession()
    }
    
    func beginSession(){
        var err : NSError? = nil
        var deviceInput:AVCaptureDeviceInput?
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            err = error
            deviceInput = nil
        }
        if err != nil {
            print("error: \(err?.localizedDescription)");
        }
        if self.session.canAddInput(deviceInput){
            self.session.addInput(deviceInput);
        }
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames=true
        videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
        videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)
        if session.canAddOutput(self.videoDataOutput){
            session.addOutput(self.videoDataOutput)
        }
        videoDataOutput.connection(withMediaType: AVMediaTypeVideo).isEnabled = true
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        let rootLayer :CALayer = self.cameraHolderView.layer
        rootLayer.masksToBounds = true
        self.previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(self.previewLayer)
        session.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
//        print("capture")
        cameraProcessor.processFrameToJpg(sampleBuffer: sampleBuffer) { (data) -> (Void) in
            
            self.api.uploadImage(image: data, fileName: "file-001.jpg")
            
            
        }
        // do stuff here
    }
    
    // clean up AVCapture
    func stopCamera(){
        session.stopRunning()
    }
    
}
