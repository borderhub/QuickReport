//
//  SettingController.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/08.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit
import Eureka

class SettingController : FormViewController {
    
    let userDefault = UserDefaults.standard
    var targetEmail: String!
    var userName: String!
    var userPassword: String!
    var port: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var leftBarButton: UIBarButtonItem!
        self.navigationItem.title = "setting"
        leftBarButton = UIBarButtonItem(title: "< back", style: .plain, target: self, action: #selector(SettingController.tappedLeftBarButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
        form +++
            Section("target Email Address") {
                $0.tag = "section1"
                $0.header = HeaderFooterView(title: "target Email Address")
            }
                <<< EmailFloatLabelRow("targetEmail") {
                    $0.tag = "targetEmail"
                    $0.title = "target email"
                    $0.value = userDefault.string(forKey: "targetEmail")
                }.onChange{row in
                    //userDefault.setValue(row.value, forKey: "targetEmail")
                }

            +++ Section("smtp Email setting") {
                $0.tag = "section2"
                $0.header = HeaderFooterView(title: "smtp Email setting")
            }
                <<< EmailFloatLabelRow("userName") {
                    $0.tag = "userName"
                    $0.title = "username"
                    $0.value = userDefault.string(forKey: "userName")
                }.onChange{row in
                    //userDefault.setValue(row.value, forKey: "userName")
                }
                <<< PasswordFloatLabelRow("userPassword") {
                    $0.tag = "userPassword"
                    $0.title = "userpassword"
                    $0.value = userDefault.string(forKey: "userPassword")
                }.onChange{row in
                    //userDefault.setValue(row.value, forKey: "userPassword")
                }
                <<< IntFloatLabelRow("port") {
                    $0.tag = "port"
                    $0.title = "port"
                    $0.value = userDefault.integer(forKey: "port")
                }.onChange{row in
                    //userDefault.setValue(row.value, forKey: "port")
                }
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "Save"
                }.onCellSelection({ (cell, row) in
                    // create alert
                    self.showAlert(type: row.title!)
                })
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "All Clear"
                }.onCellSelection({ (cell, row) in
                    // create alert
                    self.showAlert(type: row.title!)
                })
    }
    
    private func showAlert(type: String, texts: TextRow...) {
        
        let targetEmail: TextRow? = self.form.rowBy(tag: "targetEmail")
        let userName: TextRow? = self.form.rowBy(tag: "userName")
        let userPassword: TextRow? = self.form.rowBy(tag: "userPassword")
        let port: TextRow? = self.form.rowBy(tag: "port")
        
        if self.isFieldValue(texts: targetEmail!,userName!,userPassword!,port!) {
        
            // create alert
            let alert = UIAlertController(
                title: type,
                message: "Are you okay with this?",
                preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                switch(type) {
                    case "Save":
                        let targetEmailText = (targetEmail!.value != nil) ? targetEmail!.value! : ""
                        let userNameText = (userName!.value != nil) ? userName!.value! : ""
                        let userPasswordText = (userPassword!.value != nil) ? userPassword!.value! : ""
                        let portText = (port!.value != nil) ? port!.value! : ""
                        if (targetEmailText.characters.count) > 0 { self.userDefault.setValue(targetEmailText, forKey: "targetEmail") }
                        if (userNameText.characters.count) > 0 { self.userDefault.setValue(userNameText, forKey: "userName") }
                        if (userPasswordText.characters.count) > 0 { self.userDefault.setValue(userPasswordText, forKey: "userPassword") }
                        if (portText.characters.count) > 0 { self.userDefault.setValue(portText, forKey: "port") }
                        break
                    case "All Clear":
                        self.userDefault.removeObject(forKey: "targetEmail")
                        self.userDefault.removeObject(forKey: "userName")
                        self.userDefault.removeObject(forKey: "userPassword")
                        self.userDefault.removeObject(forKey: "port")
                        targetEmail?.value = ""
                        userName?.value = ""
                        userPassword?.value = ""
                        port?.value = ""
                        targetEmail?.updateCell()
                        userName?.updateCell()
                        userPassword?.updateCell()
                        port?.updateCell()
                        break
                    default:break
                }
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func isFieldValue(texts: TextRow...) -> Bool {
        var isFieldValue: Bool = false
        for data in texts {
            var text = (data.value != nil) ? data.value! : ""
            print("\(text)")
            if text.characters.count > 0 {
                isFieldValue = true
            }
        }
        return isFieldValue
    }
    
    func tappedLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
