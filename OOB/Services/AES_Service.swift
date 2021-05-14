//
//  AES_Service.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 29/12/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation
import CryptoSwift
import UIKit
public class AES_Encrypt {
    
    public init() {
    }
    
    public func keyGenerator(size: UInt) -> String {
        let prefixSize = Int(min(size, 43))
        let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return String(Data(uuidString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .prefix(prefixSize))
    }
    
    
    public func aesService(key: String, value: String){
        do {
            let ivByte = [UInt8](repeatElement(0, count: 16))
            if let ivByteString = String(bytes: ivByte, encoding: .utf8) {
                print("ivByteString \(ivByteString)")
                let x = try encrypt(value: "Hello World OOB NEW", key: "12345678901234567890123456789012")
                print("Encrypt---- \(x)")
                let z = try decrypt(encryptedString: x, key: "12345678901234567890123456789012")
                print("Decrypt---- \(z)")
            } else {
                print("not a valid UTF-8 sequence")
            }
        }
        catch {
            print(error)
        }
    }
    
    public func encrypt(value: String, key: String) throws -> String {
        let data = value.data(using: .utf8)!
        let ivByte = [UInt8](repeatElement(0, count: 16))
        let ivByteString = String(bytes: ivByte, encoding: .utf8)
        let encrypted = try! AES(key: key, iv: ivByteString!, padding: .pkcs5).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }

    public func decrypt(encryptedString: String,key: String) throws -> String {
        let data = Data(base64Encoded: encryptedString)!
        let ivByte = [UInt8](repeatElement(0, count: 16))
        let ivByteString = String(bytes: ivByte, encoding: .utf8)
        let decrypted = try! AES(key: key, iv: ivByteString!, padding: .pkcs5).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
}



