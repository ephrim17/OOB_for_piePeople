//
//  OOB_methods.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import SwiftOTP
import LocalAuthentication


//MARK: OOB_AUTHENTICATION_METHODS_WITHOUT_UI
public class OOB_Authentication {
    public init() {
    }
    
    
    //MARK: SOFT_TOKEN_NO_UI
    public func softToken(secretKey: String) -> String{
        var totpResult : String?
        let validation = validationService()
        let key = validation.revProcess(value: secretKey)
        let currentDateTime = Date()
        let dataSet = base32DecodeToData(key)
        if let totp = TOTP(secret: dataSet!, digits: 6, timeInterval: 1, algorithm: .sha1) {
            totpResult = totp.generate(time: currentDateTime)
            print("TOTP-----\(String(describing: totpResult))")
        }
        return totpResult!
    }
   
    //MARK: SEND_STATUS_TO_SERVER
    func sendTranStatus(tranId: String, custId: String, URL: String, rc: String, desc: String, authType: String, authMode: String, authFailed: String, myComplete: @escaping (_ result:String?, _ desc: String?)->()) {
        //Framing_Request
        let authObj = authenticationReq.init(tranId: tranId, authMode: authMode, rc: rc, custId: custId, authType: authType, desc: desc, reqId: "12345", authFailed: authFailed)
        //Getting pubKey from local storage
        let pubKey = UserDefaults.standard.string(forKey: Constants.key.pubKey)
        let jsonString = Providers.jsonEncode(ClassName: authObj)
        print("before encrypt \(jsonString)")
        //Generating AES Key
        let AES_enc_serv = AES_Encrypt()
        let dynamicAESKey = AES_enc_serv.keyGenerator(size: 32)
        //Encrypting AES Key data with RSA pubkey
        let rsaHash = RSAHASH()
        let encAESkeyData = rsaHash.RSAencc(value: dynamicAESKey.toBase64(), key: pubKey!)
        print("encypted_AES_Key \(encAESkeyData)")
        //Encrypting the request with AES key
        let encData =  try! AES_enc_serv.encrypt(value: jsonString, key: dynamicAESKey)
        let enccRequest = EncHashReq(encData: encData, encKeyData: encAESkeyData)
        let http = httpService()
        http.authenticationCall(ClassName: enccRequest, givenUrl: URL) { (mydata) in
            do {
                guard let tdata = mydata else {
                    myComplete("No data", "No data")
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
    
    //MARK: PIN_AUTHENTICATION
    public func pinAuthentication(tranId: String, custId: String, pin: String, URL: String, myComplete: @escaping (_ result: String?,_ desc: String?)->()) {
        //Framing_Request
        let authObj = validatePinReq.init(tranId: tranId, encPin: pin, custId: custId, type: "06", authType: "4", reqId: "12345")
        //Getting pubKey from local storage
        let pubKey = UserDefaults.standard.string(forKey: Constants.key.pubKey)
        let jsonString = Providers.jsonEncode(ClassName: authObj)
        print("before encrypt \(jsonString)")
        //Generating AES Key
        let AES_enc_serv = AES_Encrypt()
        let dynamicAESKey = AES_enc_serv.keyGenerator(size: 32)
        //Encrypting AES Key data with RSA pubkey
        let rsaHash = RSAHASH()
        let encAESkeyData = rsaHash.RSAencc(value: dynamicAESKey.toBase64(), key: pubKey!)
        print("encypted_AES_Key \(encAESkeyData)")
        //Encrypting the request with AES key
        let encData =  try! AES_enc_serv.encrypt(value: jsonString, key: dynamicAESKey)
        let enccRequest = EncHashReq(encData: encData, encKeyData: encAESkeyData)
        let http = httpService()
        http.authenticationCall(ClassName: enccRequest, givenUrl: URL) { (mydata) in
            do {
                guard let tdata = mydata else {
                    myComplete("No data", "No data")
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

