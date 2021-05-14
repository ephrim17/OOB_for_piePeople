//
//  initResponse.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct initResponse : Codable {
    let publicKey : String?
    let rc : String?
    let desc : String?
    let tranId : String?
    
    enum CodingKeys: String, CodingKey {
        
        case publicKey = "publicKey"
        case rc = "rc"
        case desc = "desc"
        case tranId = "tranId"
    }
}
