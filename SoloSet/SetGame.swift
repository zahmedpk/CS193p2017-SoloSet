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
    var dealtCards = [Card]()
    var selectedCards = [Card]()
    var removedCards = [Card]()
    var selectedCardsFormASet : Bool {
        if selectedCards.count == 3 {
            var shapesInvolved = Set<Int>()
            var numbersInvolved = Set<Int>()
            var colorsInvolved = Set<Int>()
            var shadingInvolved = Set<Int>()
            for card in selectedCards {
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
    func dealThreeCards() {
        for _ in 1...3 {
            if let dealtCard = deck.popLast() {
                dealtCards.append(dealtCard)
            }
        }
    }
    init() {
        //populate deck and shuffle
        for shape in 0...0 {//TODO: correct this to 0...2.
            //shape is temporarily made same for all cards for smaller deck for easier testing
            for shading in 0...2 {
                for number in 0...2{
                    for color in 0...2 {
                        let newCard = Card(shape: shape, shading: shading, number: number, color: color)
                        deck.append(newCard)
                    }
                }
            }
        }
//        deck.shuffle()//TODO: uncomment this after initial testing
    }
    func select(card: Card){
        if selectedCards.count < 3 {
            if selectedCards.contains(card){
                selectedCards.removeAll {$0 == card}
            } else {
                selectedCards.append(card)
            }
        } else {
            if selectedCards.contains(card) {
                return
            }
            if selectedCardsFormASet {
                if deck.count >= 3 {//replace cards
                    for i in dealtCards.indices {
                        if selectedCards.contains(dealtCards[i]) {
                            let newCard = deck.popLast()!
                            removedCards.append(dealtCards[i])
                            dealtCards[i] = newCard
                        }
                    }
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
}
