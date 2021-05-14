//
//  localStorage.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

public class Storage{
    class func myStorage(key : String, value : String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        print("local storage saved----\(String(describing: value)) with key value as ----\(key)")
    }
}

  
