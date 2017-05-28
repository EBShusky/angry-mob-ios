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
    @IBOutlet weak var flashView: FlashView!
    @IBOutlet weak var cameraHolderView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var modeButton: UIButton!

    let api = APIClient.sharedInstance

    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()

    let cameraProcessor = CameraOutputProcessor()
    let cameraController = CameraController()

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraHolderView.contentMode = UIViewContentMode.scaleAspectFit

        self.setupAVCapture()

        backButton.bringSubview(toFront: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func modeButtonClicked(_ sender: Any) {
        switch cameraController.currentMode {
        case CameraMode.modeAuto:
            modeButton.setTitle("M", for: .normal)
            cameraController.currentMode = .modeManual
        break;
        case CameraMode.modeManual:
            modeButton.setTitle("A", for: .normal)
            cameraController.currentMode = .modeAuto
        break;
        }
    }

    @IBAction func actionButton(_ sender: Any) {
        if cameraController.currentMode == .modeManual {
            cameraController.requestPhoto()
        } else {
            if cameraController.started {
                cameraController.stop()
            } else {
                cameraController.start(timeInterval: 4)
            }
        }
    }

    deinit {
        stopCamera()
    }

    func playTakeShotAnimation() {
        AudioServicesPlaySystemSound(1108);
        flashView.alpha = 1.0

        UIView.animate(withDuration: 0.6) {
            self.flashView.alpha = 0.0
        }
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
        if cameraController.canProcessFrame() {
            let result = cameraProcessor.processFrameToJpg(sampleBuffer: sampleBuffer) { (data) -> (Void) in
                let currentDate = Date()
                let since1970 = currentDate.timeIntervalSince1970
                let name = "img_\(UInt64((since1970 * 1000).rounded())).jpg"

                            self.api.uploadImage(image: data, fileName: name)
            }

            if (result) {
                DispatchQueue.main.async {
                    self.playTakeShotAnimation()
                }
            }
        }
    }

    // clean up AVCapture
    func stopCamera(){
        session.stopRunning()
    }

}
