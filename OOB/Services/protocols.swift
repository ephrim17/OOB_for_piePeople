//
//  protocols.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 12/02/21.
//  Copyright © 2021 Ephrim Daniel J. All rights reserved.
//

import Foundation

@objc public protocol responseFromOOB{
    func authStatus(result: String, description: String)
}

@objc public protocol addCardProtocol{
    func addCardStatus(myData: String)
}


//Not in use
@objc public protocol bioMetricAuthVerifyProtocol{
    func bioMetricAuthStatus(result: String)
}


@objc public protocol pinAuthVerifyProtocol{
    func pinAuthStatus(result: String)
}
