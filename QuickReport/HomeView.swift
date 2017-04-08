//
//  HomeView.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit

extension UIButton {
    private struct SchemeCustomProperties {
        static var schemeName:String? = nil
    }
    var scheme:String?{
        get {
            return objc_getAssociatedObject(self, SchemeCustomProperties.schemeName) as? String
        }
        set {
            if let unwrappedValue = newValue {
                objc_setAssociatedObject(self, SchemeCustomProperties.schemeName,unwrappedValue as NSString?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

class HomeView: UIView {
    
    let userDefault = UserDefaults.standard
    var settingButton: UIButton
    var reportButton: UIButton
    
    func calcButtonWidth(_ width: Int, bounds: Int) -> CGFloat {
        return CGFloat(Int(bounds / width))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required override init(frame: CGRect) {

        let deviceWidth = UIScreen.main.bounds.width
        let deviceHeight = UIScreen.main.bounds.height
        
        settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        settingButton.backgroundColor = UIColor.darkGray;
        settingButton.layer.masksToBounds = true
        settingButton.setTitle("setting", for: .normal)
        settingButton.layer.cornerRadius = 10.0
        
        reportButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        reportButton.backgroundColor = UIColor.black;
        reportButton.layer.masksToBounds = true
        reportButton.setTitle("report", for: .normal)
        reportButton.scheme = "sms:?to=appleid"
        reportButton.layer.cornerRadius = 10.0
        
        super.init(frame: frame);
        
        settingButton.layer.position = CGPoint(x: deviceWidth/2 - calcButtonWidth(3, bounds:Int(deviceWidth)) , y:deviceHeight - 50)
        reportButton.layer.position = CGPoint(x: deviceWidth/2 + calcButtonWidth(3, bounds:Int(deviceWidth)) , y:deviceHeight - 50)
        
        self.addSubview(reportButton);
        self.addSubview(settingButton);
        
        self.userDefault.setValue("", forKey: "targetEmail")
        self.userDefault.setValue("", forKey: "userName")
        self.userDefault.setValue("", forKey: "userPassword")
        self.userDefault.setValue(0, forKey: "port")
        
        self.backgroundColor = UIColor(red: 8, green: 8, blue: 8, alpha: 0.1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //table.frame = self.frame
    }
    
}
