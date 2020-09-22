//
//  config.swift
//  BlackJack
//
//  Created by Danil Lyskin on 19.09.2020.
//  Copyright © 2020 Danil Lyskin. All rights reserved.
//

import Foundation

public var settings = ["Double": false, "Truple": false, "Insurance": false, "Split": false]

public func updateSettings(parameters: String) {
    for code in parameters {
        switch code {
            case "1":
                settings["Double"] = true
            case "2":
                settings["Triple"] = true
            case "3":
                settings["Insurance"] = true
            case "4":
                settings["Split"] = true
            default:
                break
        }
    }
}
