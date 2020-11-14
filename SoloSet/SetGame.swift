//
//  Set.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 12/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import Foundation

class SetGame {
    private(set) var deck = [Card]()
    private(set) var dealtCards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var removedCards = [Card]()
    private(set) var score = 0
    let pointsPerSet = 3
    let pointsPenaltyPerMismatch = -5
    var lastSetFormedAtTime: Date?
    
    var selectedCardsFormASet : Bool {
        return isASet(in: selectedCards)
    }
    
    func isASet(in cards: [Card]) -> Bool {
        if cards.count == 3 {
            var shapesInvolved = Set<Int>()
            var numbersInvolved = Set<Int>()
            var colorsInvolved = Set<Int>()
            var shadingInvolved = Set<Int>()
            for card in cards {
                shapesInvolved.insert(card.shape.rawValue)
                numbersInvolved.insert(card.number.rawValue)
                colorsInvolved.insert(card.color.rawValue)
                shadingInvolved.insert(card.shading.rawValue)
            }
            if shapesInvolved.count == 3 || shapesInvolved.count == 1 {
                if numbersInvolved.count == 3 || numbersInvolved.count == 1 {
                    if colorsInvolved.count == 3 || colorsInvolved.count == 1 {
                        if shadingInvolved.count == 3 || shadingInvolved.count == 1 {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    var cardsAvailableToPlay : Int {
        var count = 0
        for card in dealtCards {
            if !removedCards.contains(card){
                count += 1
            }
        }
        return count
    }
    func dealThreeCards() {
        for _ in 1...3 {
            if let dealtCard = deck.popLast() {
                dealtCards.append(dealtCard)
            }
        }
    }
    init() {
        //populate deck and shuffle
        for shape in 0...2 {//TODO: correct this to 0...2.
            //shape is temporarily made same for all cards for smaller deck for easier testing
            for shading in 0...2 {
                for number in 0...2{
                    for color in 0...2 {
                        let newCard = Card(shape: Card.Shape(rawValue: shape)!, shading: Card.Shading(rawValue: shading)!, number: Card.Number(rawValue: number)!, color: Card.Color(rawValue: color)!)
                        deck.append(newCard)
                    }
                }
            }
        }
       deck.shuffle()
    }
    func select(card: Card){
        if selectedCards.count < 3 {
            if selectedCards.contains(card){
                selectedCards.removeAll {$0 == card}
                //deselection penalty
                score -= 1
            } else {
                selectedCards.append(card)
                if selectedCards.count == 3 {
                    if selectedCardsFormASet {
                        score += pointsPerSet
                        if let previousSetFormedAt = lastSetFormedAtTime {
                            let deltaInSeconds = previousSetFormedAt.distance(to: Date())
                            let tenthOfSeconds = deltaInSeconds/10
                            let speed = 1/tenthOfSeconds
                            let speedPoints = Int(speed * Double(pointsPerSet))
                            score += speedPoints
                            print("speed points awarded are \(speedPoints)")
                        }
                        lastSetFormedAtTime = Date()
                    } else {//non matching 3
                        score += pointsPenaltyPerMismatch
                    }
                }
            }
        } else {
            if selectedCards.contains(card) && selectedCardsFormASet {
                return
            }
            if selectedCardsFormASet {
                if deck.count >= 3 {//replace cards
                    replaceSelectedCards()
                } else {
                    //cards cant be replaced, just removing
                    for card in selectedCards {
                        removedCards.append(card)
                    }
                }
            }
            selectedCards.removeAll()
            selectedCards.append(card)
        }
    }
    func replaceSelectedCards() {
        for i in dealtCards.indices {
            if selectedCards.contains(dealtCards[i]) {
                let newCard = deck.removeFirst()
                removedCards.append(dealtCards[i])
                dealtCards[i] = newCard
            }
        }
        selectedCards.removeAll()
    }
    func findSet(in cards: [Card]) -> [Card]? {
        for card1 in cards {
            for card2 in cards {
                for card3 in cards {
                    let choiceOfThree = [card1, card2, card3]
                    if Set(choiceOfThree).count == 3 {
                        if isASet(in: choiceOfThree){
                            return choiceOfThree
                        }
                    }
                }
            }
        }
        return nil
    }
}
