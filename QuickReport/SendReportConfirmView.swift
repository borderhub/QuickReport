//
//  SendReportConfirmView.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit
import AVFoundation

class SendReportConfirmView: UIView {
    
    private var deviceWidth: CGFloat
    private var deviceHeight: CGFloat
    var sendButton: UIButton
    var closeButton: UIButton

    private var captureImageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {
        self.deviceWidth = UIScreen.main.bounds.width
        self.deviceHeight = UIScreen.main.bounds.height
        
        closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        closeButton.backgroundColor = UIColor.clear;
        closeButton.layer.masksToBounds = true
        closeButton.setTitle("×", for: .normal)
        closeButton.titleLabel!.font = UIFont.systemFont(ofSize: 60)
        closeButton.layer.cornerRadius = 1
        
        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sendButton.backgroundColor = UIColor.darkGray;
        sendButton.layer.masksToBounds = true
        sendButton.setTitle(">>", for: .normal)
        sendButton.titleLabel!.font = UIFont.systemFont(ofSize: 60)
        sendButton.layer.cornerRadius = sendButton.frame.size.width / 2
        
        super.init(frame: frame)
        
        closeButton.layer.position = CGPoint(x: closeButton.bounds.width / 2 , y:closeButton.bounds.height / 1)
        sendButton.layer.position = CGPoint(x: self.deviceWidth/2 , y:self.deviceHeight-sendButton.bounds.height)

        self.addSubview(sendButton);
        self.backgroundColor = UIColor(red: 5, green: 6, blue: 2, alpha: 0.4)
    }
    
    public func record(image: Data?) {
        guard let capturedata = image else { return }
        let captureImage = UIImage(data: capturedata)
        let width = captureImage?.size.width
        let height = captureImage?.size.height
        self.captureImageView = UIImageView(image: captureImage)
        let scale = (self.deviceWidth - 0) / width!
        let rect:CGRect = CGRect(x:0, y:0, width:width!*scale, height:height!*scale)
        self.captureImageView.image = captureImage
        self.captureImageView.frame = rect;
        self.captureImageView.center = CGPoint(x:self.deviceWidth/2, y:self.deviceHeight/2)
        self.addSubview(self.captureImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
