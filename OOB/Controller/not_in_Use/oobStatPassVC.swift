//
//  oobStatPassVC.swift
//  OOB
//
//  Created by LOB4 on 11/02/21.
//  Copyright © 2021 Ephrim Daniel J. All rights reserved.
//

import UIKit

class oobStatPassVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var staticPassTxtField: UITextField!
    
    //MARK: RECEIEVED VALUES FROM AUTH VC
    var receivedTranID : String!
    var receivedCustID : String!
    var receivedURL : String!
    var receivedAuthMode : String!
    var receivedAuthType: String!
    var receivedMerchant: String!
    var receivedAmount: String!
    var receivedTranTime: String!
    
    //MARK: IB OUTLETS
    @IBOutlet weak var merchantLabel : UILabel!
    @IBOutlet weak var amountLabel : UILabel!
    @IBOutlet weak var transactionTimeLabel : UILabel!
    @IBOutlet weak var transactionIDLabel : UILabel!
    
    public var sendOOBAuthStatusdelegate: responseFromOOB? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        staticPassTxtField.delegate = self
        print("success receivedAuthType \(self.receivedAuthType!)")
        //Tap_Gesture_ToHideKeyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(oobStatPassVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let storedStatPassword = UserDefaults.standard.string(forKey: Constants.key.statPass)
        print("Stored key is \(storedStatPassword!)")
        loadTransactionDetails()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let oob = OOB_Authentication()
        guard let statPass = staticPassTxtField?.text, statPass.count > 0  else {
            Alert(Title: nil, Message: "Static Password should not be lempty")
            return
        }
        
        guard statPass.count >= 6  else {
            Alert(Title: "Length not matched", Message: "Static Password length should not be less than six")
            return
        }
        print("Process the request")
        
        let storedStatPassword = UserDefaults.standard.string(forKey: Constants.key.statPass)
        if statPass == storedStatPassword  {
            print("Static success")
            DispatchQueue.main.async {
                //MARK: STATIC PASSWORD SUCCESS CASE (FOR SINGLE)
                if self.receivedAuthType == "08"{
                    oob.sendTranStatus(tranId: self.receivedTranID!, custId: self.receivedCustID!, URL: self.receivedURL!, rc: "00", desc: "success", authType: "Static Password", authMode: self.receivedAuthType!, authFailed: "0") { (result, desc) in
                        if result == "00" {
                            DispatchQueue.main.async {
                                print("Dual Authentication Success")
                                self.sendOOBAuthStatusdelegate?.authStatus(result: "Dual Authentication Success \(result!)", description: desc!)
                                self.presentingViewController?.dismiss(animated: true, completion: {})
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: desc, message: nil, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                                    self.sendOOBAuthStatusdelegate?.authStatus(result: desc!, description: desc!)
                                    self.presentingViewController?.dismiss(animated: true, completion: {})
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                //MARK: STATIC PASSWORD SUCCESS CASE (FOR DUAL)
                else {
                    self.receivedAuthType = "01,08"
                    oob.sendTranStatus(tranId: self.receivedTranID, custId: self.receivedCustID, URL: self.receivedURL, rc: "00", desc: "success", authType: "Static Password", authMode: self.receivedAuthType, authFailed: "0") { (result, desc) in
                        if result == "00" {
                            DispatchQueue.main.async {
                                print("Dual Authentication Success")
                                self.sendOOBAuthStatusdelegate?.authStatus(result: "Dual Authentication Success \(result!)", description: desc!)
                                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: desc, message: nil, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                                    self.sendOOBAuthStatusdelegate?.authStatus(result: desc!, description: desc!)
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        //MARK: STATIC PASSWORD ERROR CASE (FOR SINGLE)
        else{
            print("Static error")
            DispatchQueue.main.async {
                if self.receivedAuthType == "08"{
                    oob.sendTranStatus(tranId: self.receivedTranID, custId: self.receivedCustID, URL: self.receivedURL, rc: "01", desc: "Failure", authType: "Static Password", authMode: "8", authFailed: "8") { (rc, desc) in
                        if rc == "00" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Invalid Password", message: "Static password does not match", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                                    self.sendOOBAuthStatusdelegate?.authStatus(result: "\(rc!)", description: "\(desc!)")
                                    self.presentingViewController?.dismiss(animated: true, completion: {})
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: desc, message: nil, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                                    self.sendOOBAuthStatusdelegate?.authStatus(result: "\(rc!)", description: "\(desc!)")
                                    self.presentingViewController?.dismiss(animated: true, completion: {})
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                //MARK: STATIC PASSWORD SUCCESS CASE (FOR DUAL)
                else {
                    self.receivedAuthType = "01,08"
                    oob.sendTranStatus(tranId: self.receivedTranID, custId: self.receivedCustID, URL: self.receivedURL, rc: "01", desc: "Failure", authType: "Static Password", authMode: "8", authFailed: "8") { (rc, desc) in
                        if rc == "00" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Invalid Password", message: "Static password does not match", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                                    self.sendOOBAuthStatusdelegate?.authStatus(result: "\(rc!)", description: "\(desc!)")
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: desc, message: nil, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { [self](action:UIAlertAction!) in
                                    self.sendOOBAuthStatusdelegate?.authStatus(result: "\(rc!)", description: "\(rc!)")
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension oobStatPassVC {
    
    //Calls this function when the tap is recognized
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Limit_textField_characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = textField.text!.utf8CString.count + string.utf8CString.count - range.length
        
        return newLength <= 8
    }
    
    func loadTransactionDetails(){
        self.transactionIDLabel.text = self.receivedTranID
        self.amountLabel.text = self.receivedAmount
        self.merchantLabel.text = self.receivedMerchant
        self.transactionTimeLabel.text = self.receivedTranTime
    }
    
}
