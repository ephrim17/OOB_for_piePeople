//
//  authResponse.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct authenticationRes : Codable {
    let rc : String?
    let desc : String?
    let tranId : String?
    let custId : String?
    let errorCode: String
    let msgId : String?
    let oobType : String?
    
    
    enum CodingKeys: String, CodingKey {
        case rc = "rc"
        case desc = "desc"
        case tranId = "tranId"
        case custId = "custId"
        case errorCode = "errorCode"
        case msgId = "msgId"
        case oobType = "oobType"
    }
}
