//
//  Dealer.swift
//  BlackJack
//
//  Created by Danil Lyskin on 19.09.2020.
//  Copyright © 2020 Danil Lyskin. All rights reserved.
//

import Foundation

let hexSymbol: [String] = ["A", "B", "C", "D", "E", "F"]

struct Deck {
    func checkIn(card: (Int, Int), hands: Hands) -> Bool {
        for (cardX, suit) in hands.cards {
            if cardX == card.0 && suit == card.1 {
                return true
            }
        }
        return false
    }
    
    func takeCard() -> (Int, Int) {
        var num: Int = Int.random(in: 0...12)
        num += num == 11 ? 2 : 1
        return (num, Int.random(in: 0...3))
    }
}

struct Hands {
    var cards: [(Int, Int)] = []
    var sum: Int = 0
    let name: String
    var flag: Bool = false
    
    mutating func giveCard(cards: (Int, Int)) {
        self.cards.append(cards)
        sum += getPoints(card: cards.0)
    }
    
    mutating func cleanHands() {
        sum = 0
        cards.removeAll()
        flag = false
    }
    
    func getPoints(card: Int) -> Int {
        switch card {
        case 2...10:
            return card
        case 11...14:
            return 10
        default:
            return 11
        }
    }
}

public class Dealer {
    let deck: Deck = Deck()
    var dealersHands: Hands = Hands(name: "Dealer")
    var players: [Hands] = []
    var playersHands: Hands = Hands(name: "Player")
    
    func clean() {
        dealersHands.cleanHands()
        for ind in 0..<players.count {
            players[ind].cleanHands()
        }
    }
    
    func getCardsUnicode(cards: (Int, Int)) -> String {
        let charString: String = "1F0" + hexSymbol[cards.1] + (cards.0 > 9 ? hexSymbol[cards.0 - 10] : "\(cards.0)")
        if let charCode = UInt32(charString, radix: 16), let unicode = UnicodeScalar(charCode) {
            return String(unicode)
        }
        return "Error"
    }
    
    func printWinner(name: String?) {
        var result: String = "Dealer: \(dealersHands.sum)"
        
        if (name == nil) {
            print("Draw!")
            print("Dealer cards: " + dealersHands.cards.map(getCardsUnicode).joined(separator: " "))
            for player in players {
                print("\(player.name) cards: " + player.cards.map(getCardsUnicode).joined(separator: " "))
                result += "  |  \(player.name): \(player.sum)"
            }
            print(result)
            return
        }
        print("\(name!) wins!")
        
        print("Dealer cards: " + dealersHands.cards.map(getCardsUnicode).joined(separator: " "))
        for player in players {
            print("\(player.name) cards: " + player.cards.map(getCardsUnicode).joined(separator: " "))
            result += "  |  \(player.name): \(player.sum)"
        }
        print(result)
        clean()
    }

    func takeCard() -> (Int, Int) {
        return deck.takeCard()
    }
    
    func checkWin() -> Hands? {
        players = players.sorted() {$0.sum > $1.sum}
        for player in players {
            if player.sum <= 21 && dealersHands.sum == player.sum {
                return nil
            } else if player.sum <= 21 && player.sum > dealersHands.sum {
                return player;
            } else if player.sum <= 21 && player.sum < dealersHands.sum && dealersHands.sum <= 21 {
                return dealersHands
            } else if player.sum <= 21 {
                return player
            }
        }
        return nil
    }
    
    func take(ind: Int) -> Bool {
        let cards: (Int, Int) = takeCard()
        print("Player take: " + getCardsUnicode(cards: cards))
        players[ind].giveCard(cards: cards)
        print(players[ind].sum)
        
        if players[ind].sum == 21 {
            printWinner(name: players[ind].name)
            return true
        }
        if players[ind].sum > 21 {
            printWinner(name: dealersHands.name)
            return true
        }
        return false
    }
    
    func pass(ind: Int?) -> Bool {
        while (dealersHands.sum < 17) {
            let cards: (Int, Int) = takeCard()
            dealersHands.giveCard(cards: cards)
        }
        
        let winner = checkWin()
        if winner == nil {
            printWinner(name: nil)
        } else {
            printWinner(name: winner!.name)
        }
        return true
    }
}
