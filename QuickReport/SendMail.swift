//
//  SendMail.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit

class SendMail {
    
    let userDefault = UserDefaults.standard
    private var toAddress : Array<String>?
    private var toMessage : String?
    private var toAttachment : UIImage?
    
    init() {
        //initialize
    }
    
    func send(_ message: String?, image: Data?) {
        
        if message != nil { toMessage = message! }
        if image != nil { toAttachment = UIImage(data:image!) }
        
        if image == nil {toAttachment = UIImage(named:"Resource/Common/ipad.png")!}
        toAddress = [userDefault.string(forKey: "targetEmail")!]
        if toMessage == nil {toMessage = ""}
        
        let smtpSession:MCOSMTPSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = userDefault.string(forKey: "userName") //"yourname@gmail.com"
        smtpSession.password = userDefault.string(forKey: "userPassword") //"yourpassword"
        smtpSession.port = UInt32(userDefault.integer(forKey: "port")) //465 or 25 or 587
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    print("Connectionlogger: \(string)")
                }
            }
        }
        
        let dataImage: NSData?
        dataImage = UIImageJPEGRepresentation(toAttachment!, 0.6)! as NSData?
        let attachment = MCOAttachment()
        attachment.mimeType =  "image/jpg, image/png"
        attachment.filename = "image.jpg"
        attachment.data = dataImage as Data!
        
        let builder:MCOMessageBuilder = MCOMessageBuilder()
        var toAddressArray:Array<MCOAddress>? = []
        toAddress?.forEach { toAddressArray!.append(MCOAddress(displayName: nil, mailbox: $0)) }
        
        let tos:Array = toAddressArray!
        let from:MCOAddress = MCOAddress(displayName: nil, mailbox: "xxx@yyy.com")
        builder.header.to = tos
        builder.header.from = from
        builder.header.subject = "Quick Report"
        builder.htmlBody = toMessage
        builder.addAttachment(attachment)
        
        let rfc822Data:NSData = builder.data() as NSData
        let sendOperation:MCOSMTPSendOperation = smtpSession.sendOperation(with: rfc822Data as Data!)
        sendOperation.start { (error) -> Void in
            if (error != nil) {
                print("Error sending email: \(error)")
            } else {
                print("Successfully sent email!")
            }
        }
    }
    
}
