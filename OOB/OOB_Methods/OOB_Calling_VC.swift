//
//  OOB_Calling_VC.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 16/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation
import UIKit

@objc
public class oobView : UIViewController {
    
    //MARK: OOB_REGISTRATION
    @objc public func registraionView(appToken: String, mobileModel: String, deviceID: String, cardNumber: String, custId: String, delegate: addCardProtocol) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobAddCardVC.self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "addcard") as! oobAddCardVC
        homeVC.receivedAppToken = appToken
        homeVC.receivedDeviceId = deviceID
        homeVC.receivedMobileModel = mobileModel
        homeVC.receivedCardNumber = cardNumber
        homeVC.delegate = delegate
        homeVC.receivedCustID = custId
        return homeVC
    }
    
    //MARK: CHOOSE_AUTHENTICATION_VC
    @objc public func oobAuthentication(tranID: String, custID: String, URL: String, authType: String, merchant: String, tranTime: String, amount: String, pin: String, delegate: responseFromOOB) -> UIViewController {
        //chooseAuthenticationView enters OOB BiometricVC first to check whether it is Single or Dual authentication
        if authType == "01" {
            print("Entering Bio-Metric VC")
            let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobBioMetricVC.self))
            let homeVC = storyboard.instantiateViewController(withIdentifier: "biometric") as! oobBioMetricVC
            homeVC.receivedURL = URL
            homeVC.receivedCustID = custID
            homeVC.sendOOBAuthStatusdelegate = delegate
            homeVC.receivedAuthType = authType
            homeVC.receivedTranID = tranID
            homeVC.receivedMerchant = merchant
            homeVC.receivedAmount = amount
            homeVC.receivedTranTime = tranTime
            return homeVC
        }
        else if authType == "08" {
            print("Entering StatPass VC")
            let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobStatPassVC.self))
            let homeVC = storyboard.instantiateViewController(withIdentifier: "statPass") as! oobStatPassVC
            homeVC.receivedTranID = tranID
            homeVC.receivedURL = URL
            homeVC.receivedCustID = custID
            homeVC.receivedAuthType = authType
            homeVC.receivedTranID = tranID
            homeVC.receivedMerchant = merchant
            homeVC.receivedAmount = amount
            homeVC.receivedTranTime = tranTime
            homeVC.sendOOBAuthStatusdelegate = delegate
            return homeVC
        }
        else if authType == "4" {
            print("Entering Pin Auth VC")
            let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobPinAuthVC.self))
            let homeVC = storyboard.instantiateViewController(withIdentifier: "pin") as! oobPinAuthVC
            homeVC.receivedTranID = tranID
            homeVC.receivedURL = URL
            homeVC.receivedCustID = custID
            homeVC.receivedAuthType = authType
            homeVC.receivedTranID = tranID
            homeVC.receivedMerchant = merchant
            homeVC.receivedAmount = amount
            homeVC.receivedTranTime = tranTime
            homeVC.receivedPin = pin
            homeVC.sendOOBAuthStatusdelegate = delegate
            return homeVC
        }
        
        else{
            print("Entering Dual Authentication")
            let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobBioMetricVC.self))
            let homeVC = storyboard.instantiateViewController(withIdentifier: "biometric") as! oobBioMetricVC
            homeVC.receivedTranID = tranID
            homeVC.receivedURL = URL
            homeVC.receivedCustID = custID
            homeVC.sendOOBAuthStatusdelegate = delegate
            homeVC.receivedAuthType = authType
            homeVC.receivedTranID = tranID
            homeVC.receivedMerchant = merchant
            homeVC.receivedAmount = amount
            homeVC.receivedTranTime = tranTime
            return homeVC
        }
    }
                                                    //MARK: NOT IN USE
    
    
    //MARK: PIN_AUTHENTICATION_VC
    @objc public func pinAuthenticationView(tranId: String, custIdforCard: String, URL: String, delegate: pinAuthVerifyProtocol) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobPinAuthVC.self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "pin") as! oobPinAuthVC
        homeVC.receivedURL = URL
        homeVC.pinAuthdelegate = delegate
        return homeVC
    }
    
    //MARK: TOTP_AUTHENTICATION_VC
    @objc public func TOTPAuthenticationView(custIdforCard: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: "main", bundle: Bundle(for: oobSoftTokenVC.self))
        let homeVC = storyboard.instantiateViewController(withIdentifier: "totp") as! oobSoftTokenVC
        homeVC.receivedCidForCard = custIdforCard
        return homeVC
    }
}
