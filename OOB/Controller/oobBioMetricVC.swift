//
//  oobBioMetricVC.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 11/01/21.
//  Copyright © 2021 Ephrim Daniel J. All rights reserved.
//

import UIKit
import LocalAuthentication

@objc public
class oobBioMetricVC: UIViewController {
    
    //MARK: IB OUTLETS
    @IBOutlet weak var bioImage: UIImageView!
    @IBOutlet weak var merchantLabel : UILabel!
    @IBOutlet weak var amountLabel : UILabel!
    @IBOutlet weak var transactionTimeLabel : UILabel!
    @IBOutlet weak var transactionIDLabel : UILabel!
    @IBOutlet weak var authenticateBtn: UIButton!
    
    //MARK: RECEIEVED VALUES FROM AUTH VC
    @objc public var receivedTranID : String?
    @objc public var receivedCustID : String?
    @objc public var receivedURL : String?
    @objc public var receivedAuthMode : String?
    @objc public var receivedAuthType: String?
    @objc public var receivedMerchant: String?
    @objc public var receivedAmount: String?
    @objc public var receivedTranTime: String?
    
    //MARK: RECEIEVED VALUES FROM REACT NATIVE FOR UI CONFIGURATIONS
    @objc public var receivedTitleText : String?
    @objc public var receivedTitleColor : String?
    @objc public var receivedSubTitleText : String?
    @objc public var receivedSubTitleColor : String?
    @objc public var receivedBoxColor : String?
    @objc public var receivedBGColor : String?
   
    //MARK: UI CONFIGURATION OUTLETS FROM REACT NATIVE
    @IBOutlet weak var titleLabel: UILabel! //color_&_Text
    @IBOutlet weak var subTitleLabel: UILabel! //color_&_Text
    @IBOutlet weak var boxView: UIView! //color
    
    //MARK: VARIABLES
    var bioMetricAuthenticationMode: String = "bioMetric"
    var sv = UIView()
    
    //MARK: DELEGATES
    @objc public var sendOOBAuthStatusdelegate: responseFromOOB?
    @objc public var bioMetricAuthdelegate: bioMetricAuthVerifyProtocol? //not in use
    @objc public var delegate: addCardProtocol? //not in use
    
    
    //MARK: VIEWDIDLOAD
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("ReceivedAuthType \(receivedAuthType!)")
        //loadUIConfigurations()
        loadTransactionDetails()
    }
    
    
    @IBAction func authenticateAction(_ sender: Any) {
        bioMetric { (res, desc) in
            //MARK: SENDING RESPONSE OF BIO METRIC AUTHENTICATION RESPONSE TO REF APP
            print("SENDING RESPONSE \(res!) \(desc!)")
            if res == "00" {
                self.sendOOBAuthStatusdelegate?.authStatus(result: "\(res!)", description: "\(desc!)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
            else {
                self.sendOOBAuthStatusdelegate?.authStatus(result: "\(res!)", description: "\(desc!)")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension oobBioMetricVC{
    
    //MARK: STATIC PASSWORD SCREEN
    func staticPassScreen(){
        let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobStatPassVC.self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "statPass") as! oobStatPassVC
        homeVC.receivedTranID = self.receivedTranID
        homeVC.receivedURL = self.receivedURL
        homeVC.receivedCustID = self.receivedCustID
        homeVC.receivedAuthType = self.receivedAuthType
        homeVC.receivedMerchant = self.receivedMerchant
        homeVC.receivedTranTime = self.receivedTranTime
        homeVC.receivedAmount = self.receivedAmount
        homeVC.modalPresentationStyle = .fullScreen
        homeVC.sendOOBAuthStatusdelegate = sendOOBAuthStatusdelegate
        self.present(homeVC, animated: true, completion: nil)
    }
    
    func loadTransactionDetails(){
        // DispatchQueue.main.async {
        let id = biometricType()
        print("id \(id)")
        //bioMetricAuthenticationMode = id
//        if id == "face" {
//            bioImage.image = UIImage(named: "face")
//        }
//        else if id == "touch"{
//            bioImage.image = UIImage(named: "touch")
//        }
//        else{
//            bioImage.image = UIImage(named: "touch")
//        }
        //}
        self.transactionIDLabel.text = self.receivedTranID
        self.amountLabel.text = self.receivedAmount
        self.merchantLabel.text = self.receivedMerchant
        self.transactionTimeLabel.text = self.receivedTranTime
        self.authenticateBtn.layer.cornerRadius = 5
    }
    
    //MARK: BIOMETRIC AUTHENTICATION
    func bioMetric(myComplete: @escaping (_ result:String?, _ desc: String?)->()) {
        let context = LAContext()
        var error: NSError?
        let oob = OOB_Authentication()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "For Secure Authentication"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                                    {(success, error) in
                                        //MARK: BIOMETRIC SUCCESS CASE
                                        if success {
                                            //MARK: SINGLE TYPE AUTHENTICATION
                                            print("success receivedAuthType \(self.receivedAuthType!)")
                                            if self.receivedAuthType == "01" {
                                                print("only Bio_metric")
                                                //MARK: SENDING REQUEST TO OOB ENGINE
                                                DispatchQueue.main.async {
                                                    self.sv = UIViewController.displaySpinner(onView: self.view)
                                                }
                                                oob.sendTranStatus(tranId: self.receivedTranID!, custId: self.receivedCustID!, URL: self.receivedURL!, rc: "00", desc: "success", authType: self.bioMetricAuthenticationMode, authMode: "1", authFailed: "0") { (rc, desc)  in

                                                    if rc == "00" {
                                                        DispatchQueue.main.async {
                                                            UIViewController.removeSpinner(spinner: self.sv)
                                                            self.presentingViewController?.dismiss(animated: true, completion: {})
                                                            myComplete(rc, desc)
                                                        }
                                                    }

                                                    else {
                                                        DispatchQueue.main.async {
                                                            UIViewController.removeSpinner(spinner: self.sv)
                                                            let alert = UIAlertController(title: desc!, message: nil, preferredStyle: UIAlertController.Style.alert)
                                                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                                                self.presentingViewController?.dismiss(animated: true, completion: {})
                                                                myComplete(rc, desc)
                                                            }))
                                                            self.present(alert, animated: true, completion: nil)
                                                        }
                                                    }
                                                }
                                            }
                                            else{
                                                //MARK: ROUTING TO DUAL AUTHENTICATION IF AUTHTYPE = "01, 08"
                                                print("Dual Authentication triggered")
                                                DispatchQueue.main.async {
                                                    UIViewController.removeSpinner(spinner: self.sv)
                                                    self.staticPassScreen()
                                                }
                                            }
                                        }
                                        //MARK: BIOMETRIC ERROR CASE
                                        else {
                                            print("BIOMETRIC Error")
                                            //MARK: SENDING REQUEST TO OOB ENGINE
                                            oob.sendTranStatus(tranId: self.receivedTranID!, custId: self.receivedCustID!, URL: self.receivedURL!, rc: "01", desc: "failure", authType: self.bioMetricAuthenticationMode, authMode: "1", authFailed: "1") { (rc, desc)  in
                                                if rc == "00" {
                                                    DispatchQueue.main.async {
                                                        UIViewController.removeSpinner(spinner: self.sv)
                                                        self.presentingViewController?.dismiss(animated: true, completion: {})
                                                        myComplete(rc, desc)
                                                    }
                                                }
                                                
                                                else {
                                                    DispatchQueue.main.async {
                                                        UIViewController.removeSpinner(spinner: self.sv)
                                                        self.presentingViewController?.dismiss(animated: true, completion: {})
                                                        myComplete(rc, desc)
                                                    }
                                                }
                                            }
                                        }
                                    })
        }
        else {
            UIViewController.removeSpinner(spinner: self.sv)
            print("Touch ID not available")
            DispatchQueue.main.async {
                self.Alert(Title: "Sorry", Message: "Touch ID not available")
            }
            myComplete("Touch ID not available", "Something went wrong")
        }
    }
}


extension oobBioMetricVC {
    func loadUIConfigurations(){
        //MARK: TITLE_CONFIG
        if receivedTitleText == "" {
            receivedTitleText = "Bio-Metric"
        }
        else if receivedTitleColor == "" {
            receivedTitleColor = "#FFFFFF"
        }
        
        //MARK: SUB_TITLE_CONFIG
        if receivedSubTitleText == "" {
            receivedSubTitleText = "Bio-Metric"
        }
        else if receivedSubTitleColor == "" {
            receivedSubTitleColor = "#FFFFFF"
        }
        
        //MARK: BOX
        if receivedBoxColor == "" {
            receivedBoxColor = "#A9372C"
        }
        
        //MARK: SUB_TITLE_CONFIG
        if receivedBGColor == "" {
            receivedBGColor = "#E0DFE1"
        }
        
        self.titleLabel.text = receivedTitleText
        self.subTitleLabel.text = receivedSubTitleText
        self.titleLabel.textColor = UIColor(hexaRGB: receivedTitleColor!)
        self.subTitleLabel.textColor = UIColor(hexaRGB: receivedSubTitleColor!)
        self.boxView.backgroundColor = UIColor(hexaRGB: receivedBoxColor!)
        self.view.backgroundColor = UIColor(hexaRGB: receivedBGColor!)
        self.authenticateBtn.layer.cornerRadius = 5
    }
}
