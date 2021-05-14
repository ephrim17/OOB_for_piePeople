//
//  loadCardsRequest.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct cardDetailsReq : Codable {
    let cust_login_id : String?
    
    enum CodingKeys: String, CodingKey {
        case cust_login_id = "cust_login_id"
    }
}
