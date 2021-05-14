//
//  userRequest.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct userRequest : Codable {
    
    let userName : String?
    let pin : String?
    let cust_login_id : String?
    let appToken : String?
    var reqId: String?
    
    enum CodingKeys: String, CodingKey {
        
        case userName = "userName"
        case pin = "pin"
        case cust_login_id = "cust_login_id"
        case appToken = "appToken"
        case reqId = "reqId"
    }
}
