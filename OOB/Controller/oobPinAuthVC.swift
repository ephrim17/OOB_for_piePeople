//
//  oobPinAuthVC.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 16/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import UIKit


class oobPinAuthVC: UIViewController {
    
    //MARK: IB OUTLETS
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var merchantLabel : UILabel!
    @IBOutlet weak var amountLabel : UILabel!
    @IBOutlet weak var transactionTimeLabel : UILabel!
    @IBOutlet weak var transactionIDLabel : UILabel!
    @IBOutlet weak var cancelBtn : UIButton!
    var sv = UIView()
    
    //MARK: DELEGATES
    public var pinAuthdelegate: pinAuthVerifyProtocol? //NOT IN USE
    @objc public var sendOOBAuthStatusdelegate: responseFromOOB?
    
  
    //MARK: RECEIEVED VALUES FROM AUTH VC
    var receivedTranID : String!
    var receivedCustID : String!
    var receivedURL : String!
    var receivedAuthMode : String!
    var receivedAuthType: String!
    var receivedMerchant: String!
    var receivedAmount: String!
    var receivedTranTime: String!
    var receivedPin : String = "56,78,98"
    var fullNumArr = [String]()
    
    //MARK: VIEW-DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTransactionDetails()
        roundBtn()
        fullNumArr = receivedPin.components(separatedBy: ",")
        btn1.setTitle(fullNumArr[0],for: .normal)
        btn2.setTitle(fullNumArr[1],for: .normal)
        btn3.setTitle(fullNumArr[2],for: .normal)
    }
    
    @IBAction func button1(_ sender: UIButton) {
        if sender.tag == btn1.tag {
            print(fullNumArr[sender.tag])
            sendPinAuthVerify(pin: fullNumArr[sender.tag])
        }
        else if sender.tag == btn2.tag {
            print(fullNumArr[sender.tag])
            sendPinAuthVerify(pin: fullNumArr[sender.tag])
        }
        else if sender.tag == btn3.tag {
            print(fullNumArr[sender.tag])
            sendPinAuthVerify(pin: fullNumArr[sender.tag])
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        sendCancel()
    }
}

extension oobPinAuthVC {
    func sendPinAuthVerify(pin: String){
        let oobAuth = OOB_Authentication()
        DispatchQueue.main.async {
            self.sv = UIViewController.displaySpinner(onView: self.view)
        }
        oobAuth.pinAuthentication(tranId: receivedTranID, custId: receivedCustID, pin: pin, URL: receivedURL) { (rc, desc) in
            print("pin auth status \(desc!)")
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: self.sv)
            }
            self.sendOOBAuthStatusdelegate?.authStatus(result: "\(rc!)", description: "\(desc!)")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func sendCancel(){
        let oobAuth = OOB_Authentication()
        DispatchQueue.main.async {
            self.sv = UIViewController.displaySpinner(onView: self.view)
        }
        oobAuth.pinAuthentication(tranId: receivedTranID, custId: receivedCustID, pin: "user cancel", URL: receivedURL) { (rc, desc) in
            print("pin auth status \(desc!)")
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: self.sv)
            }
            self.sendOOBAuthStatusdelegate?.authStatus(result: "\(rc!)", description: "\(desc!)")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func roundBtn(){
        //Making_round_button
        btn1.layer.cornerRadius = 20
        btn1.clipsToBounds = true
        btn2.layer.cornerRadius = 20
        btn2.clipsToBounds = true
        btn3.layer.cornerRadius = 20
        btn3.clipsToBounds = true
        self.cancelBtn.layer.cornerRadius = 5
    }
    func loadTransactionDetails(){
        self.transactionIDLabel.text = self.receivedTranID
        self.amountLabel.text = self.receivedAmount
        self.merchantLabel.text = self.receivedMerchant
        self.transactionTimeLabel.text = self.receivedTranTime
    }
}
