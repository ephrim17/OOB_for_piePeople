//
//  helpers.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 25/06/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import Foundation

var ran1 : String?
var ran2 : String?

public class validationService {
    
    //EmailValidation
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //Phone-Number Validation
    func validateNumb(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //validateName
    func validateName(enteredName:String) -> Bool {
        let regex = "^[a-zA-Z ]*$"
        let emailFormat = regex
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredName)
    }
    
    //validatePassword
    func validatePass(password: String) -> Bool{
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: password)
    }
    
    //MARK: Reverse_process_For_Public_Key
    func revProcess(value: String) -> String{
        let str = value
        let substring1 = str.dropLast(3)
        let outputString = String(substring1.dropFirst(3))
        //print("After dropping first three and Last three---\(outputString)")
        let reversed = String(outputString.reversed())
        //print("After Reversing a String---\(reversed)")
        //print("count value----\(reversed.count)---\(reversed.count/2)")
        let arr = reversed.components(withMaxLength: reversed.count/2)
        let first = arr[1]
        let last = arr[0]
        //print("arr---\(arr)")
        let result = first + last
        //print("Final String is -----\(result)")
        return result
    }
}

public class Providers{
    class func jsonEncode <GenricClass: Codable>(ClassName: GenricClass) -> String{
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        let jsonData = try! jsonEncoder.encode(ClassName)
        let jsonString = String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        return jsonString
    }
    class func startRandomNumber() ->  (ran1: String, ran2: String){
        let js = jsCore()
        js.initializeJS()
        let randomNumberFull = js.getRRNfromJS()
        let first19 = String("\(randomNumberFull)".prefix(19))
        ran1 = "\(first19)"
        let last8 = String("\(randomNumberFull)".suffix(8))
        ran2 = "\(last8)"
        return (ran1!, ran2!)
    }
}



extension String {
    
    //Checks_Whether_String_or_Int
    var isInt: Bool {
        return Int(self) != nil
    }
    //slpitStringsBasedOnlength
    func components(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    //RemoveWhiteSpace
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert(separator: Self, every n: Int) {
        for index in indices.reversed() where index != startIndex &&
            distance(from: startIndex, to: index) % n == 0 {
                insert(contentsOf: separator, at: index)
        }
    }
    
    func inserting(separator: Self, every n: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: n)
        return string
    }
}

extension String {
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
