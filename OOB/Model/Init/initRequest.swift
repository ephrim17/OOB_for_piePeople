//
//  initRequest.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

struct InitRequest : Codable {
    
    var uniqueId : String?
    
    enum CodingKeys: String, CodingKey {
        case uniqueId = "uniqueId"
    }
}
