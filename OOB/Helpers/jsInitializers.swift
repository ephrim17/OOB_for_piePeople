//
//  jsInitializers.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation
import JavaScriptCore

public class jsCore{
     var jsContext: JSContext!
    
    //Initializing_myJS.js_file
    func initializeJS(){
        self.jsContext = JSContext()
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "rrnGen", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                self.jsContext.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //Calling_JS_func--"toggle"
    func getRRNfromJS()->String{
        var randomNum: String!
        if let variableRandomNumber = self.jsContext.objectForKeyedSubscript("toggleRRN") {
            randomNum = "\(variableRandomNumber)"
            print("Random Number Full---\(variableRandomNumber)")
        }
        return randomNum
    }
}

