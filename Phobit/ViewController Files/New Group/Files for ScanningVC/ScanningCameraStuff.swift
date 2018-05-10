//
//  ScanningCameraStuff.swift
//  Phobit
//
//  Created by Paul Wiesinger on 01.05.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import AVFoundation
import UIKit
import Vision

extension ScanningViewController: AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    func checkForAuthorization() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                if success == false {
                    self.errorWithCameraAuthorization()
                }
            }
        default:
            self.errorWithCameraAuthorization()
        }
        
        return false
    }
    
    
    func checkForAutohizationSilent() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    
    func setupSession() {
        configureSession()
        setupVision()
        
        DispatchQueue.main.async {
            
            guard let _ = self.session else {
                print("session is not available.")
                return
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session!)
            
            previewLayer.frame = self.view.frame
            previewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(previewLayer)
            self.bringAllElementsToFront()
        }
        
        guard let device = device else {
            print("no device found.")
            self.session = nil
            return
        }
    
        autoCapture = AutoCaptureObservator.init(device: device)
        
        
    }
 
    
    func configureSession() {
        session?.beginConfiguration()
        
        device = AVCaptureDevice.default(for: .video)
        
        do {
            try device?.lockForConfiguration()
            
            device?.focusPointOfInterest = CGPoint.init(x: 0.5, y: 0.5)
            device?.focusMode = .continuousAutoFocus
            
            device?.exposurePointOfInterest = CGPoint.init(x: 0.5, y: 0.5)
            device?.exposureMode = .continuousAutoExposure
            
            device?.unlockForConfiguration()
            
            guard let device = device else {
                self.session = nil
                print("could not find camera.")
                return
            }
            
            let deviceInput = try AVCaptureDeviceInput.init(device: device )
            session?.addInput(deviceInput)
            
        } catch {
            print(error)
        }
        
        
        
        if (session?.canSetSessionPreset(.hd4K3840x2160))! {
            session?.sessionPreset = .hd4K3840x2160
        } else if (session?.canSetSessionPreset(.hd1920x1080))!{
            session?.sessionPreset = .hd1920x1080
        } else if (session?.canSetSessionPreset(.hd1280x720))!{
            session?.sessionPreset = .hd1280x720
        } else {
            print("unsupported session Preset.")
        }
        
        session?.addOutput(photoOutput)
        photoOutput.isHighResolutionCaptureEnabled = true
        
        let deviceOutput = AVCaptureVideoDataOutput.init()
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive))
        
        session?.addOutput(deviceOutput)
        
        session?.commitConfiguration()
    }
    
    
    func bringAllElementsToFront() {
        view.bringSubview(toFront: detectionOverlay)
//        view.bringSubview(toFront: whiteboard)
//        view.bringSubview(toFront: infolabel)
        view.bringSubview(toFront: cameraButton)
        view.bringSubview(toFront: suchenSegueButton)
        view.bringSubview(toFront: einstellungenSegueButton)
        view.bringSubview(toFront: blitzButton)
//        view.bringSubview(toFront: stackView)
        view.bringSubview(toFront: infoView)
    }
    
    
    
    
    func captureImage() {
        self.canTakeNextQR = false
        
        overlay?.invisible()
        
        /*
        self.session.stopRunning()
        self.session.beginConfiguration()
        self.session.sessionPreset = .hd4K3840x2160
        self.session.commitConfiguration()
        self.session.startRunning()
        */
        
        let photoSettings: AVCapturePhotoSettings = AVCapturePhotoSettings()
        
        photoSettings.flashMode = .auto
        photoSettings.isAutoStillImageStabilizationEnabled = self.photoOutput.isStillImageStabilizationSupported
        
        // the user can't take a picture now because we do it.
        DispatchQueue.main.async {
            self.cameraButton.isEnabled = false
        }
        
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    
    
    // sample buffer - Vision Detection
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        

        var options: [VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            options = [.cameraIntrinsics : camData]
        }
        
        
        guard let pixelbuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let requestHandler = VNImageRequestHandler.init(cvPixelBuffer: pixelbuffer, orientation: CGImagePropertyOrientation.init(rawValue: 6)!, options: options)
        
        
        do {
            try requestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), let image = UIImage.init(data: data) else {
            print(error ?? "no error.")
            return
        }
        
        self.image = image
        gotImage()
    }
}
