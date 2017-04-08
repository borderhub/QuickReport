//
//  SendReportConfirmController.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol SendReportControllerDelegate {
    func setConfirm(value: String?, sendReportConfirmController:SendReportConfirmController)
}

class SendReportConfirmController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var delegate: SendReportControllerDelegate!

    var capturePhoto:Data?
    private var getSendReportView:SendReportConfirmView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = SendReportConfirmView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSendReportView = self.view as! SendReportConfirmView
        self.navigationItem.title = "confirm"
        var leftBarButton: UIBarButtonItem!
        leftBarButton = UIBarButtonItem(title: "< back", style: .plain, target: self, action: #selector(SendReportConfirmController.tappedLeftBarButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getSendReportView!.record(image: capturePhoto!)
        self.getSendReportView!.sendButton.addTarget(self, action: #selector(SendReportConfirmController.showAlert(sender:)), for: .touchUpInside)
        self.getSendReportView!.closeButton.addTarget(self, action: #selector(SendReportConfirmController.tappedDismissButton(sender:)), for: .touchUpInside)
        self.view.addSubview(self.getSendReportView!.closeButton)
        self.view.addSubview(self.getSendReportView!.sendButton)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.delegate.setConfirm(value: "I`m back", sendReportConfirmController:self)
    }
    
    func tappedDismissButton(sender: UIButton) {
        self.delegate.setConfirm(value: "I`m back", sendReportConfirmController:self)
    }
    
    /*
     * To send an email
     */
    internal func onSendReport() {
        let sendMail = SendMail()
        sendMail.send("To send an email", image:self.capturePhoto)
        let image = UIImage(data: self.capturePhoto!)
        // save a photo
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        self.delegate.setConfirm(value: "sending a report", sendReportConfirmController:self)
    }
    
    @objc private func showAlert(sender: UIButton) {
        // create alert
        let alert = UIAlertController(
            title: "Confirmation before sending",
            message: "Can I send a report?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
            self.onSendReport()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
}
