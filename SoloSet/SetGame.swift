//
//  Set.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 12/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import Foundation

class SetGame {
    var deck = [Card]()
    var dealtCards = [Card]()
    func dealThreeCards() {
        for _ in 1...3 {
            if let dealtCard = deck.popLast() {
                dealtCards.append(dealtCard)
            }
        }
    }
    init() {
        //populate deck and shuffle
        for shape in 0...2 {
            for shading in 0...2 {
                for number in 0...2{
                    for color in 0...2 {
                        let newCard = Card(shape: shape, shading: shading, number: number, color: color)
                        deck.append(newCard)
                    }
                }
            }
        }
        deck.shuffle()
    }
}
