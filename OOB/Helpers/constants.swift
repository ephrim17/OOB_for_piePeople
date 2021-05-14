//
//  constants.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

class Constants : NSObject {
    
    //MARK: URL Paths
    struct api {
        //static let base_url : String = "https://acstest.fssnet.co.in/ACSOOB/192/"
        static let base_url : String = "https://acsuat.fssnet.co.in/ACSOOB/2421/"
        
        static let initReq : String = "/getKey"
        static let addUser : String = "/thirdpartyregistration"
        static let addCard : String = "/addCard"
        static let getcustallcarddetails : String = "/getcustallcarddetails"
    }
    
    //MARK: Storage Keys
    struct key {
        static let pubKey : String = "pubKey"
        static let custID : String = "cid"
        static let statPass : String = "statPass"
        static let custArray : String = "custArray"
    }
    
    //MARK: Response Codes
    struct RC {
        static let successCode : String = "00"
    }
    
    //MARK: MESSAGE CODES
    struct frameworkMessageCodes {
        static let successInit : String = "OOB intialized successfully"
        static let errorInit : String = "OOB Initialisation failed"
        static let errorAddCard : String = "card add failed"
        static let successAddCard : String = "card added successfully"
    }

}
