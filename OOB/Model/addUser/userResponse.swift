//
//  userResponse.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation


struct userResponse: Codable {
    let rc: String?
    let desc: String?
    let cust_login_id: String?
    
    enum CodingKeys: String, CodingKey{
        case rc = "rc"
        case desc = "desc"
        case cust_login_id = "cust_login_id"
    }
}
