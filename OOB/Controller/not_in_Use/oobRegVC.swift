//
//  ViewController.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import UIKit

public protocol MyDataSendingDelegateProtocol: NSObject {
    func sendDataToFirstViewController(myData: String)
}


public class oobRegVc: UIViewController, addCardProtocol{
    public func addCardStatus(myData: String) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    public var delegate: MyDataSendingDelegateProtocol?
    
    @IBOutlet weak var mobTextField: UITextField!
    @IBOutlet weak var dialCode: UILabel!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var submitbtn: UIButton!
    
    var receivedAppToken: String?
    var receivedDeviceID: String?
    var receivedMobileModel: String?
    var receivedUserName: String?
    var receivedPin: String?
    var receivedCustID: String?
    
    var cardArr = [Cust_card_details]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        submitbtn.layer.cornerRadius = 10
        print("receivedAppToken \(receivedAppToken!)")
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func submitAction(_ sender: Any) {
        let user = oobRegistration()
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        guard let pin = pinTextField.text, pin.count < 5 else {
            return
        }
        
        let validate = validationService()
        
        guard validate.validateName(enteredName: receivedUserName!) else {return}
    }
}

extension oobRegVc {
    //MARK: LOAD_ALL_CARDS
    //This..is..to..fetch..the..cardDetailsArray..for..getting..particular..secret..key
    func loadCards(){
        //        let sv = UIViewController.displaySpinner(onView: self.view)
        //        //gettingSecKeyfrom--localStoarge
        //        let secretKey = UserDefaults.standard.string(forKey: Constants.key.pubKey)
        //        let cid = UserDefaults.standard.string(forKey: Constants.key.custID)
        //        let userObj = cardDetailsReq.init(cust_login_id: cid)
        //        //Js-initialization
        //        let randomNumbers = Providers.startRandomNumber()
        //        //Using jsonEncoder to convert it into JSON format
        //        let jsonString = Providers.jsonEncode(ClassName: userObj)
        //        print("loadCards before encrypt \(jsonString)")
        //        //Getting Encrypted RRN
        //        let rsaHash = RSAHASH()
        //        let encRRN = rsaHash.RSAencc(value: randomNumbers.ran1, key: secretKey!)
        //        //Getting Encrypted Data
        //        let encData = rsaHash.RSAencc(value: jsonString, key: secretKey!)
        //        //Getting Hashed Data
        //        let hasheddata = rsaHash.hmacSha(value: jsonString, key: randomNumbers.ran2)
        //        let enccRequest = EncHashReq(encData: encData, rrn: encRRN, hashedData: hasheddata)
        //
        //        let http = httpService()
        //        http.call(ClassName: enccRequest, path: Constants.api.getcustallcarddetails) { (mydata) in
        //            do {
        //                guard let tdata = mydata else {
        //                    print("no data")
        //                    return
        //                }
        //                let decoder = JSONDecoder()
        //                let model = try decoder.decode(cardDetailsResp.self, from: tdata)
        //                print(model)
        //                if (model.rc == "00"){
        //                    DispatchQueue.main.async {
        //                        UIViewController.removeSpinner(spinner: sv)
        //                        let enc = JSONEncoder()
        //                        if let encoded = try? enc.encode(model) {
        //                            let userdefaults = UserDefaults.standard
        //                            userdefaults.set(encoded, forKey: Constants.key.custArray)
        //                        }
        //                        self.delegate?.send(myData: "close all VC from framework")
        //                        self.dismiss(animated: true, completion: nil)
        //                    }
        //                }
        //                else {
        //                    DispatchQueue.main.async {
        //                        UIViewController.removeSpinner(spinner: sv)
        //                        self.Alert(Title: model.desc!, Message: nil)
        //                    }
        //                }
        //            }
        //            catch{
        //                print("error")
        //            }
        //        }
    }
}
