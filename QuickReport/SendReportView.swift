//
//  SendReportView.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit
import AVFoundation

class SendReportView: UIView {
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    private var deviceWidth: CGFloat
    private var deviceHeight: CGFloat

    var capButton: UIButton
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        deviceWidth = UIScreen.main.bounds.width
        deviceHeight = UIScreen.main.bounds.height
        
        captureSession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        captureSession.sessionPreset = AVCaptureSessionPreset1920x1080
        
        capButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 3, green: 3, blue: 3, alpha: 0.4)
    }
    
    public func start() {
        capButton.backgroundColor = UIColor.orange;
        capButton.layer.masksToBounds = true
        //capButton.setTitle("take a picture", for: .normal)
        capButton.layer.cornerRadius = capButton.frame.size.width / 2
        capButton.layer.position = CGPoint(x: deviceWidth/2 , y:deviceHeight-capButton.bounds.height)
        self.addSubview(capButton);
        self.captureHandler()
    }
    
    public func captureHandler() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            //input
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                //output
                if captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addOutput(stillImageOutput)
                    captureSession.startRunning()
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                    self.previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    // layer for preview
                    self.layer.addSublayer(self.previewLayer!)
                    self.previewLayer?.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight)
                }
            }
        } catch {
            print(error)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
