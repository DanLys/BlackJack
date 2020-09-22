//
//  main.swift
//  BlackJack
//
//  Created by Danil Lyskin on 17.09.2020.
//  Copyright © 2020 Danil Lyskin. All rights reserved.
//

import Foundation

func main() {
    let config = Config()
    let dealer = Dealer()
    
    func printRules() {
        print("Select parameters for include rules: ")
        print("1: Double")
        print("2: Triple")
    }
    
    func printQuestionAboutAmoubtOfPlayers() {
        print("Enter count of players:");
        let count = Int.init(readLine() ?? "0")
        for ind in 0..<count! {
            let name = readLine() ?? "Players\(ind)"
            dealer.players.append(Hands(name: name))
        }
    }
    
    func startNewGame() -> Bool {
        dealer.clean()
        
        for ind in 0..<dealer.players.count {
            print("\(dealer.players[ind].name)'s start cards: ")
            dealer.players[ind].giveCard(cards: dealer.takeCard())
            dealer.players[ind].giveCard(cards: dealer.takeCard())
            print(dealer.players[ind].cards.map(dealer.getCardsUnicode).joined(separator: " "))
            print("sum: \(dealer.players[ind].sum)")
            if dealer.players[ind].sum == 21 {
                dealer.printWinner(name: dealer.players[ind].name)
                return true
            }
        }

        print("Dealers start cards: ")
        dealer.dealersHands.giveCard(cards: dealer.takeCard())
        dealer.dealersHands.giveCard(cards: dealer.takeCard())
        print(dealer.dealersHands.cards.map(dealer.getCardsUnicode).joined(separator: " "))
        print("sum: \(dealer.dealersHands.sum)")
        if dealer.dealersHands.sum == 21 {
            dealer.printWinner(name: dealer.dealersHands.name)
            return true
        }
        return false
    }
    
    printQuestionAboutAmoubtOfPlayers()
    
    printRules()
    var rules = readLine()
    config.updateSettings(parameters: rules)
    
    var end = true
    var count = 0
    var countOfPass = 0
    while (true) {
        if end {
            print("New round started!")
            end = false
            count = 0
            if startNewGame() {
                end = true
                continue
            }
        }
        
        var ind = 0
        while ind < dealer.players.count {
            if dealer.players[ind].flag {
                ind += 1
                continue
            }
            
            print("\(dealer.players[ind].name)'s turn!")
            let command: String = readLine() ?? "command"
            
            if let rule = config.settings[command] {
                if command == "pass" {
                    countOfPass += 1
                    dealer.players[ind].flag = true
                    ind += 1
                    continue
                } else if rule.0 {
                    if rule.2 || (!rule.2 && count == 0) {
                        end = rule.1(dealer)(ind)
                        ind += 1
                        continue
                    }
                }
            }
            if command == "rules" {
                printRules()
                rules = readLine()
                config.updateSettings(parameters: rules)
                end = true
            } else {
                print("incorrect command: " + command)
            }
        }
        count += 1
        if countOfPass == dealer.players.count {
            end = dealer.pass(ind: nil)
            countOfPass = 0
        }
    }
}

main()
