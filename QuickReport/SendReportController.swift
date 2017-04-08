//
//  SendReportController.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit
import AVFoundation

class SendReportController: UIViewController, AVCapturePhotoCaptureDelegate, SendReportControllerDelegate {
    
    let userDefault = UserDefaults.standard
    var sendReportConfirmController: SendReportConfirmController?
    var getSendReportView:SendReportView!
    var returnMessage: String?
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        self.sendReportConfirmController = SendReportConfirmController()
        super.init(nibName: nil, bundle: nil)
        self.sendReportConfirmController?.delegate = self
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = SendReportView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var leftBarButton: UIBarButtonItem!
        self.navigationItem.title = "camera"
        leftBarButton = UIBarButtonItem(title: "< back", style: .plain, target: self, action: #selector(SendReportController.tappedLeftBarButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.getSendReportView = self.view as! SendReportView
        self.getSendReportView.start()
        self.getSendReportView.capButton.addTarget(self, action: #selector(SendReportController.onTakeIt(sender:)), for: .touchUpInside)
        self.view.addSubview(self.getSendReportView.capButton)
    }
    
    internal func onClickUrlSchemeButton(sender: UIButton){
        guard let scheme: String = sender.scheme else {
            return
        }
        print("button \(scheme) clicked!")
        open(scheme:scheme)
    }
    
    func open(scheme: String) {
        print("button \(scheme) clicked!")
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(scheme): \(success)")
            })
        }
    }
    
    func tappedLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    internal func onTakeIt(sender: UIButton) {
        
        let isTargetEmail = self.userDefault.string(forKey: "targetEmail")
        let isUserName = self.userDefault.string(forKey: "userName")
        let isTargetPassword = self.userDefault.string(forKey: "userPassword")
        let isPort = (self.userDefault.string(forKey: "port")?.description)!
        
        if self.isFieldValue(texts: isTargetEmail!,isUserName!,isTargetPassword!,isPort) {
            self.getSendReportView.captureHandler()
            
            let settingsForMonitoring = AVCapturePhotoSettings()
            //settingsForMonitoring.flashMode = .auto
            settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
            settingsForMonitoring.isHighResolutionPhotoEnabled = false
            
            getSendReportView.stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
            
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Please set a configration",
                message: "",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                // move settingView
                let settingController = SettingController()
                settingController.modalTransitionStyle = UIModalTransitionStyle.partialCurl
                self.navigationController?.pushViewController(settingController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            self.sendReportConfirmController?.modalTransitionStyle = UIModalTransitionStyle.partialCurl
            self.sendReportConfirmController?.capturePhoto = photoData!
              sendReportConfirmController?.modalTransitionStyle = .coverVertical
            //  sendReportConfirmController?.modalTransitionStyle = .crossDissolve
            //  sendReportConfirmController?.modalTransitionStyle = .flipHorizontal
            //sendReportConfirmController?.modalTransitionStyle = .partialCurl
            self.present(sendReportConfirmController!, animated: true, completion: nil)
        }
    }
    
    func setConfirm(value: String?, sendReportConfirmController:SendReportConfirmController) {
        if value != nil {
            returnMessage = value!
        } else {
            print("error")
            
        }
        self.sendReportConfirmController?.dismiss(animated: true, completion: nil)
    }
    
    private func isFieldValue(texts:String...) -> Bool {
        var isFieldValue: Bool = false
        var num = 0
        for tuple in texts.enumerated() {
            print(tuple.offset, tuple.element)
            if tuple.element.characters.count > 0 && tuple.element != "0" {
                num += 1
            }
        }
        if num == 4 { isFieldValue = true }
        return isFieldValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
