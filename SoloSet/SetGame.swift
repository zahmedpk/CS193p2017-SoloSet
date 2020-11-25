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
    var cardIdMaker: () -> Int = {
        var cardId = 0
        func inner() -> Int {
            cardId += 1
            return cardId
        }
        return inner
    }()
    func isASet(in cards: [Card]) -> Bool {
        if cards.count == 3 {
            var shapesInvolved = Set<Card.Shape>()
            var numbersInvolved = Set<Card.Number>()
            var colorsInvolved = Set<Card.Color>()
            var shadingInvolved = Set<Card.Shading>()
            for card in cards {
                shapesInvolved.insert(card.shape)
                numbersInvolved.insert(card.number)
                colorsInvolved.insert(card.color)
                shadingInvolved.insert(card.shading)
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
        for shape in Card.Shape.allCases {
            for shading in Card.Shading.allCases {
                for number in Card.Number.allCases {
                    for color in Card.Color.allCases {
                        let newCard = Card(shape: shape, shading: shading, number: number, color: color, id: cardIdMaker())
                        deck.append(newCard)
                    }
                }
            }
        }
//       deck.shuffle()
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
                            let deltaInSeconds = Date().timeIntervalSince(previousSetFormedAt)
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
                        if let i = dealtCards.firstIndex(of: card){
                            dealtCards.remove(at: i)
                        }
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
    func shuffleDealtCards() {
        dealtCards.shuffle()
    }
}
