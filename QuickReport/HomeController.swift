//
//  HomeController.swift
//  QuickReport
//
//  Created by borderhub on 2017/04/05.
//  Copyright © 2017 border___. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    override var shouldAutorotate:Bool{
        return false
    }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func loadView() {
        self.view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let getHomeView = self.view as! HomeView
        getHomeView.settingButton.addTarget(self, action: #selector(HomeController.onClickSettingButton(sender:)), for: .touchUpInside)
        getHomeView.reportButton.addTarget(self, action: #selector(HomeController.onClickReportButton(sender:)), for: .touchUpInside)
        
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
    
    internal func onClickSettingButton(sender: UIButton) {
        let settingController = SettingController()
        settingController.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        self.navigationController?.pushViewController(settingController, animated: true)
    }
    
    internal func onClickReportButton(sender: UIButton) {
        let sendReportController = SendReportController()
        sendReportController.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        self.navigationController?.pushViewController(sendReportController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
