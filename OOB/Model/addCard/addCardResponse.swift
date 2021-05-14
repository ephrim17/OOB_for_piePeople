//
//  addCardResponse.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 29/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation



//"rc": "00",
//"desc": "Card  Updated Successfully",
//"secKey": "Pe4J2VUW3MGRZMKD4IGVZMCDZEHTBMSDYEGLTUMFMNMLCSCVJRNITZAVGFLB2MIUM5Gk1Q",
//"cust_login_id": "926119909147"

struct addCardResponse: Codable {
    let rc: String?
    let desc: String?
    let secKey: String?
    let cust_login_id: String?
    
    enum CodingKeys: String, CodingKey{
        case rc = "rc"
        case desc = "desc"
        case secKey = "secKey"
        case cust_login_id = "cust_login_id"
    }
}
