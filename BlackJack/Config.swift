//
//  config.swift
//  BlackJack
//
//  Created by Danil Lyskin on 19.09.2020.
//  Copyright © 2020 Danil Lyskin. All rights reserved.
//

import Foundation

class Config {
    var settings = ["pass": (true, Dealer.pass, true), "take": (true, Dealer.take, true),
                           "double": (false, Dealer.take, false),"triple": (false, Dealer.take, false)]
    
    func updateSettings(parameters: String?) {
        settings["double"]?.0 = false
        settings["triple"]?.0 = false
        
        guard parameters != nil else {
            return
        }
        for code in parameters! {
            switch code {
                case "1":
                    settings["double"]?.0 = true
                case "2":
                    settings["triple"]?.0 = true
                default:
                    break
            }
        }
    }
}
