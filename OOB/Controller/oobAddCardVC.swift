//
//  oobAddCardVC.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import UIKit

@objc public class oobAddCardVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var stacticPassTxtField: UITextField!
    @IBOutlet weak var newPinTextField: UITextField!
    @IBOutlet weak var confirmPinTextField: UITextField!
    
    @objc public var delegate: addCardProtocol?
    @objc public var receivedDeviceId: String!
    @objc public var receivedMobileModel: String!
    @objc public var receivedAppToken: String!
    @objc public var receivedCardNumber: String!
    @objc public var receivedCustID: String!
    public var Status: String!
    
    var sv = UIView()
    var oldPass : String?
    var newPass :String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = 10
        //stacticPassTxtField.delegate = self
        
        //MARK: Tap_Gesture_ToHideKeyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(oobStatPassVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.newPinTextField.tag = 0
        newPinTextField.delegate = self
        confirmPinTextField.delegate = self
        self.confirmPinTextField.tag = 1
        
        let var_OOB = OOB()
        DispatchQueue.main.async {
            self.sv = UIViewController.displaySpinner(onView: self.view)
        }
        var_OOB.initialize { (rc, desc) in
            guard let res = rc else {return}
            if res == "00" {
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                }
                print("hide oob init spinner")
            }
            else{
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: self.sv)
                }
                print("hide oob init spinner \(res)")
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        Status = "test"
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        matchFields()
    }
    
    func matchFields(){
        if newPinTextField.text == ""{
            Alert(Title:  "Sorry", Message: "New-Pin should not be empty")
        }
        
        guard let ntemp = newPinTextField.text , ntemp.count == 6  else {
            Alert(Title: "Sorry", Message: "New-Pin should not be less than six digits")
            return
        }
        
        oldPass = ntemp
        
        if confirmPinTextField.text == "" {
            Alert(Title:  "Sorry", Message: "Confirm-Pin should not be empty")
        }
        
        guard let ctemp = confirmPinTextField.text , ctemp.count == 6  else {
            Alert(Title: "Sorry", Message: "Confirm-Pin should not be less than six digits")
            return
        }
        
        if ntemp == ctemp{
            print("Pass Match")
            newPass = ntemp
            staticPasswordRegistrationCall()
        }
            
        else if ntemp != ctemp{
            print("Pin Not Match")
            Alert(Title:  "Sorry", Message: "Pin Does not match")
        }
    }
    
    func staticPasswordRegistrationCall(){
        let var_OOB = OOB()
        var_OOB.initialize { (str, desc) in
            guard let res = str else {return}
            if res == "00" {
                let card = oobRegistration()
                DispatchQueue.main.async{
                    //MARK: STORING STATIC PASSWORD IN LOCAL STORAGE
                    Storage.myStorage(key: Constants.key.statPass, value: self.newPass!)
                    let storedStatPassword = UserDefaults.standard.string(forKey: Constants.key.statPass)
                    print("Process Add Card request and stored key is \(storedStatPassword!)")
                    //MARK: ADD CARD REQUEST
                    let sv = UIViewController.displaySpinner(onView: self.view)
                    card.cardReg(deviceId: self.receivedDeviceId, mobModel: self.receivedMobileModel, cardToken: self.receivedCardNumber, authType: "1,3,4", cust_login_id: self.receivedCustID, appToken: self.receivedAppToken) { (rc, desc) in
                        DispatchQueue.main.async {
                            if rc == Constants.RC.successCode {
                                UIViewController.removeSpinner(spinner: sv)
                                let alert = UIAlertController(title: desc!, message: nil, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                    self.delegate?.addCardStatus(myData: desc!)
                                    self.presentingViewController?.dismiss(animated: true, completion: {})
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else{
                                UIViewController.removeSpinner(spinner: sv)
                                let alert = UIAlertController(title: desc!, message: nil, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "okay", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                    self.delegate?.addCardStatus(myData: desc!)
                                    self.presentingViewController?.dismiss(animated: true, completion: {})
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            else {
                self.Alert(Title: "OOB Initialization Error", Message: "Not initialised successfully")
            }
        }
    }
}


extension oobAddCardVC {
    
    //MARK: Limit_textField_characters
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = textField.text!.utf8CString.count + string.utf8CString.count - range.length
        
        if textField.tag == 0 {
            return newLength <= 8
        }
         
        else{
            return newLength <= 8
        }
    }
    
    //MARK: Dismiss_keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

