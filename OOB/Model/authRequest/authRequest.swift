//
//  authRequest.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct authenticationReq : Codable {
    let tranId : String?
    let authMode : String?
    let rc : String?
    let custId : String?
    let authType : String?
    let desc : String?
    let reqId : String?
    let authFailed: String?
    
    enum CodingKeys: String, CodingKey {
        
        case tranId = "tranId"
        case authMode = "authMode"
        case rc = "rc"
        case custId = "custId"
        case authType = "authType"
        case desc = "desc"
        case reqId = "reqId"
        case authFailed = "authFailed"
    }
}
