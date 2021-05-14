//
//  oobSoftTokenVC.swift
//  OOB
//
//  Created by  Ephrim Daniel J on 17/07/20.
//  Copyright © 2020 Ephrim Daniel J. All rights reserved.
//

import UIKit
import SRCountdownTimer
import SwiftOTP

class oobSoftTokenVC: UIViewController {
    
    var counter = 29
    var timer: Timer?
    
    var receivedCidForCard : String?
    var cardArr = [Cust_card_details]()
    var secretKey: String?
    
    @IBOutlet weak var genCodeLabel: UILabel!
    @IBOutlet weak var countDownTimer: SRCountdownTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("receivedCid \(receivedCidForCard!)")
        secretKey = fromLocal(custIdforCard: receivedCidForCard!)
        let validation = validationService()
        secretKey = validation.revProcess(value: secretKey!)
        genCode()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    
    
    @objc func updateCounter(){
        
        if counter > 0 {
            print("\(counter) seconds remaining")
            counter -= 1
        }
            
        else {
            print("Timer over So restarting")
            counter = 29
            startTimer()
            genCode()
        }
    }
    
    func startTimer(){
        countDownTimer.labelFont = UIFont(name: "DIN Alternate", size: 50.0)
        countDownTimer.timerFinishingText = "End"
        countDownTimer.start(beginingValue: 30, interval: 1)
    }
    
    func genCode(){
        //TakingCurrent--UTC--Time
        let currentDateTime = Date()
        print("Time \(currentDateTime)")
        guard let data = base32DecodeToData(secretKey!) else { return }
        print("base32DecodeToData----\(data)")
        if let totp = TOTP(secret: data, digits: 6, timeInterval: 1, algorithm: .sha1) {
            
            let otpString = totp.generate(time: currentDateTime)
            print("TOTP-----\(String(describing: otpString))")
            genCodeLabel.text = otpString!
        }
    }
}

extension oobSoftTokenVC {
    func fromLocal(custIdforCard: String) -> String{
        print("from local storage")
        let userDefaults = UserDefaults.standard
        let test = userDefaults.data(forKey: Constants.key.custArray)
        let decoder = JSONDecoder()
        let model = try! decoder.decode(cardDetailsResp.self, from: test!)
        let cd = model.cust_card_details
        self.cardArr = cd!
        let dict :[String: Cust_card_details] = Dictionary(uniqueKeysWithValues:  self.cardArr.map{ ($0.cust_id, $0) }) as! [String : Cust_card_details]
        let secretKey = dict[custIdforCard]?.secKey
        var cardNumber = dict[custIdforCard]?.mask_card
        cardNumber = cardNumber!.inserting(separator: "  ", every: 4)
        let cardBrandType =  dict[custIdforCard]?.cardType
        return secretKey!
    }
}
