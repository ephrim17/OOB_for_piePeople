//
//  httpSerivce.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import SwiftOTP
import LocalAuthentication

public class httpService {
    
    func call<GenricClass: Codable>(ClassName: GenricClass,path: String, mycomplete: @escaping (_ result: Data?)->()){
        
        guard let url = URL(string: Constants.api.base_url + path) else { return }
        let reqString = Providers.jsonEncode(ClassName: ClassName)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .sortedKeys
            let jsonData = try jsonEncoder.encode(ClassName)
            request.httpBody = jsonData
            print("Request URL---------> \(url)")
            print("Request Hit---------> \(reqString)")
        }
        catch{
            print("error from http service")
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                do {
                    print(data)
                    _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    mycomplete((data as AnyObject) as? Data)
                    //mycomplete(nil)
                } catch {
                    mycomplete(nil)
                    print("Errorrrr \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func authenticationCall<GenricClass: Codable>(ClassName: GenricClass,givenUrl: String, mycomplete: @escaping (_ result: Data?)->()){
        
        let reqString = Providers.jsonEncode(ClassName: ClassName)
        guard let url = URL(string: Constants.api.base_url + givenUrl) else {return}
        //guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .sortedKeys
            let jsonData = try jsonEncoder.encode(ClassName)
            request.httpBody = jsonData
            print("Request URL---------> \(url)")
            print("Request Hit---------> \(reqString)")
        }
        catch{
            print("error")
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    mycomplete((data as AnyObject) as? Data)
                    
                } catch {
                    mycomplete(nil)
                    print(error)
                }
            }
        }.resume()
    }
}

