//
//  registration.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import SwiftOTP
import LocalAuthentication

//MARK: OOB_INITIALIZE
@objc
public class OOB: NSObject {
    
    @objc
    public override init() {
    }
    
    @objc
    public func initialize(complete: @escaping (_ result: String?, _ desc: String?)->()){
        let http = httpService()
        var initReqObj = InitRequest()
        initReqObj.uniqueId = "123"
        http.call(ClassName: initReqObj, path: Constants.api.initReq) { (mydata) in
            do {
                guard let tdata = mydata else {
                    complete(Constants.frameworkMessageCodes.errorInit, "no response from server")
                    return
                }
                let decoder = JSONDecoder()
                let model = try decoder.decode(initResponse.self, from: tdata)
                if (model.rc == Constants.RC.successCode) {
                    let secPubKey =  model.publicKey
                    let validation = validationService()
                    let getKey = validation.revProcess(value: secPubKey!)
                    Storage.myStorage(key: Constants.key.pubKey, value: getKey)
                    complete(model.rc, model.desc)
                }
                else{
                    complete(model.rc, model.desc)
                }
            }
            catch{
                print("error in catch")
            }
        }
    }
    
    @objc public func myTest(hello1: String, hello2: String, complete: @escaping (_ result: String?)->()){
        
    }
}


//MARK: OOB_REGISTRATION
@objc
public class oobRegistration : NSObject{
    var ran1: String?
    var ran2: String?
    var jsContext: JSContext!
    
    @objc public override init() {
    }
    
    //MARK: ADD CARD
    @objc
    public func cardReg(deviceId: String, mobModel:String, cardToken: String, authType: String, cust_login_id: String, appToken: String, myComplete: @escaping (_ result:String?, _ desc: String?)->()){
        
        let var_OOB = OOB()
        var_OOB.initialize { (rc, desc) in
            guard let res = rc else {return}
            if res == "00" {
                DispatchQueue.main.async{
                    //Framing Request
                    let addCardObj = addCardRequest.init(deviceID: deviceId, mobModel: mobModel, cardToken: cardToken, cust_login_id: cust_login_id, reqId: "12345", authType: authType, appToken: appToken)
                    //Getting pubKey from local storage
                    let pubKey = UserDefaults.standard.string(forKey: Constants.key.pubKey)
                    let jsonString = Providers.jsonEncode(ClassName: addCardObj)
                    print("before encrypt \(jsonString)")
                    //Generating AES Key
                    let AES_enc_serv = AES_Encrypt()
                    let dynamicAESKey = AES_enc_serv.keyGenerator(size: 32)
                    print("dynamicAESKey \(dynamicAESKey)")
                    //Encrypting AES Key data with RSA pubkey
                    let rsaHash = RSAHASH()
                    let encAESkeyData = rsaHash.RSAencc(value: dynamicAESKey.toBase64(), key: pubKey!)
                    print("encypted_AES_Key \(encAESkeyData)")
                    //Encrypting the request with AES key
                    let encData =  try! AES_enc_serv.encrypt(value: jsonString, key: dynamicAESKey)
                    let enccRequest = EncHashReq(encData: encData, encKeyData: encAESkeyData)
                    let http = httpService()
                    http.call(ClassName: enccRequest, path: Constants.api.addCard) { (mydata) in
                        do {
                            guard let tdata = mydata else {
                                myComplete(Constants.frameworkMessageCodes.errorAddCard, nil)
                                print("no data")
                                return
                            }
                            let decoder = JSONDecoder()
                            let model = try decoder.decode(EncHashRes.self, from: tdata)
                            print("Response object\(model.responseObject!)")
                            let z = try! AES_enc_serv.decrypt(encryptedString: model.responseObject!, key: dynamicAESKey)
                            print("Decrypted check---- \(z)")
                            let f = try JSONDecoder().decode(responseObject.self, from: Data(z.utf8))
                            print("final f value \(f)")
                            
                            if (f.rc == "00"){
                                myComplete(f.rc!, f.desc!)
                            }
                            else {
                                myComplete(f.rc!, f.desc!)
                            }
                        }
                        catch{
                            print("error")
                        }
                    }
                }
            }
            else{
                print("OOB  init key failed")
                myComplete(res, desc)
            }
        }
    }
}
