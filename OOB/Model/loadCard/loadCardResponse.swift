//
//  loadCardResponse.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 15/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct cardDetailsResp : Codable {
    let rc : String?
    let desc : String?
    let cust_card_details : [Cust_card_details]?
    
    enum CodingKeys: String, CodingKey {
        
        case rc = "rc"
        case desc = "desc"
        case cust_card_details = "cust_card_details"
    }
}

struct Cust_card_details : Codable {
    let mask_card : String?
    let cust_id : String?
    let secKey : String?
    let cardType : String?
    let isAlexaStatus : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case mask_card = "mask_card"
        case cust_id = "cust_id"
        case secKey = "secKey"
        case cardType = "cardType"
        case isAlexaStatus = "isAlexaStatus"
    }
    
}
