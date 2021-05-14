//
//  pinAuthrequest.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct validatePinReq : Codable {
    let tranId : String?
    let encPin : String?
    let custId : String?
    let type : String? //06
    let authType : String? //1
    let reqId : String?
    
    enum CodingKeys: String, CodingKey {
        case tranId = "tranId"
        case encPin = "encPin"
        case custId = "custId"
        case type = "type"
        case authType = "authType"
        case reqId = "reqId"
    }
}
