//
//  enccHasRequest.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 26/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct EncHashReq : Codable {
    let encData : String?
    let encKeyData : String?
    
    enum CodingKeys: String, CodingKey {
        case encData = "encData"
        case encKeyData = "encKeyData"
    }
}

struct EncHashRes : Codable {
    let responseObject : String?
    
    enum CodingKeys: String, CodingKey {
        case responseObject = "responseObject"
    }
}


struct responseObject : Codable {
    
    let desc : String?
    let rc : String?
    
    enum CodingKeys: String, CodingKey {
        case desc = "desc"
        case rc = "rc"
    }
}
