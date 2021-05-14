//
//  addCardRequest.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 29/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

//"deviceID":"79675fee9cb0f5fc",
//"mobModel":"Motorola moto x4",
//"cardNo":"5577882000000177",
//"authType":"1,3,4",
//"cust_login_id":"926119909147"


struct addCardRequest : Codable {
    let deviceID: String
    let mobModel: String
    let cardToken: String
    let cust_login_id: String
    let reqId: String
    let authType: String
    let appToken: String
    
    
    enum CodingKeys: String, CodingKey {
        
        case deviceID = "deviceID"
        case mobModel = "mobModel"
        case cardToken = "cardToken"
        case authType = "authType"
        case cust_login_id = "cust_login_id"
        case reqId = "reqId"
        case appToken = "appToken"
    }
    
}
