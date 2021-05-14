//
//  chooseAuthViewController.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 11/01/21.
//  Copyright © 2021 Ephrim Daniel J. All rights reserved.
//

import UIKit



class chooseAuthVC: UIViewController {

    @IBOutlet weak var bioBtn: UIButton!
    @IBOutlet weak var softBtn: UIButton!
    @IBOutlet weak var pinBtn: UIButton!
    @IBOutlet weak var staticBtn: UIButton!
    
    //MARK: RECEIEVED_VALUES_FROM_APP
    var receivedTranID : String?
    var receivedCustID : String?
    var receivedURL : String?
    var receivedAuthMode : String?
    
    public var sendOOBAuthStatusdelegate: responseFromOOB? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SettingTag
        bioBtn.tag = 1
        softBtn.tag = 2
        pinBtn.tag = 3
        staticBtn.tag = 4
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseAuthAction(sender: UIButton) {
        switch sender.tag {
        case 1:
            print("Bio-Mteroc")
            biomtericAuthentication()
        case 2:
            print("Soft")
            softTokenAuthentication()
        case 3:
            print("Pin")
            pinAuthentication()
        case 4:
            print("Static")
        default:
            print("default")
        }
    }
    
}

extension chooseAuthVC {
    
    func biomtericAuthentication(){
        let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobBioMetricVC.self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "biometric") as! oobBioMetricVC
        homeVC.receivedTranID = receivedTranID
        homeVC.receivedCustID = receivedCustID
        homeVC.receivedURL = receivedURL
        homeVC.receivedAuthMode = receivedAuthMode
        homeVC.bioMetricAuthdelegate = self
        self.present(homeVC, animated: true, completion: nil)
    }
    
    func softTokenAuthentication(){
        let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobSoftTokenVC.self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "totp") as! oobSoftTokenVC
        homeVC.receivedCidForCard = receivedCustID
        self.present(homeVC, animated: true, completion: nil)
    }
    
    func pinAuthentication(){
        let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobPinAuthVC.self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "pin") as! oobPinAuthVC
        homeVC.receivedURL = receivedURL
        homeVC.pinAuthdelegate = self
        self.present(homeVC, animated: true, completion: nil)
    }
}

extension chooseAuthVC : bioMetricAuthVerifyProtocol, pinAuthVerifyProtocol {
    func pinAuthStatus(result: String) {
        print("Pin Auth VC \(result)")
        sendOOBAuthStatusdelegate?.authStatus(result: "from choose auth \(result)", description: "\(result)")
    }
    
    func bioMetricAuthStatus(result: String) {
        print("Bio-Metric VC \(result)")
        sendOOBAuthStatusdelegate?.authStatus(result: "from choose auth \(result)", description: "\(result)")
    }
    
    
}
