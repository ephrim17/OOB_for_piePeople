//
//  hash&EnccService.swift
//  oobAuthAcs
//
//  Created by LOB4 on 24/10/19.
//  Copyright © 2019 fss. All rights reserved.
//

import Foundation
import SwiftyRSA

public class RSAHASH {
    
    //HMAC_SHA256
    func hmacSha(value:String, key: String)->String{
        let hmac_md5 = value.hmac(algorithm: .sha256, key: key)
        return hmac_md5
    }
    
    
    //RSA-Encryption
    func RSAencc(value: String, key: String) -> String{
        var returnRSAencc : String!
        let base =  key
        let decodedData = Data(base64Encoded: base)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        let keyString = decodedString.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "").replacingOccurrences(of: "\n-----END PUBLIC KEY-----", with: "")
        do {
            let publicKey = try PublicKey(base64Encoded: keyString)
            let str =  value
            let clear = try? ClearMessage(string: "\(str)", using: .utf8)
            let encrypted = try? clear!.encrypted(with: publicKey, padding: .OAEP)
            let mydata = encrypted!.base64String
            returnRSAencc = mydata
        }
        catch {
            print(error.localizedDescription)
        }
        return returnRSAencc
    }
}

var hashKey : String?

public class security {
    class func getHashKey() -> String {
        let key = "$MTOGGLE_!1@2#3$4<>.,?/';:$MOB"
        var list : [Int] = []
        for i in 101...999 {
            list.append(i)
        }
        hashKey = key + "\(list[Int(arc4random_uniform(UInt32(list.count)))])"
        return hashKey!
    }
}

func gethashed(encString : String) -> String{
    let rsaHash = RSAHASH()
    let hasheddata = rsaHash.hmacSha(value: encString, key: hashKey!)
    return hasheddata
}
