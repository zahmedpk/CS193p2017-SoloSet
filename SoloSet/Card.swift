//
//  Card.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 12/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import Foundation

struct Card: Equatable, CustomStringConvertible {
    //A single card representing one of the 81 permutations of shape, shading, number and color.
    // each of these four features can take one of 3 possible values, i.e 0, 1, 2
    let shape: Shape
    let shading: Shading
    let number: Number
    let color: Color
    let id: Int
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.shape == rhs.shape && lhs.shading == rhs.shading && lhs.number == rhs.number && lhs.color == rhs.color
    }
    var description: String {
        return String(id)
    }
}

extension Card {
    enum Shape: Int, CaseIterable {
        case A
        case B
        case C
    }
    enum Color: Int, CaseIterable {
        case A
        case B
        case C
    }
    enum Shading: Int, CaseIterable {
        case A
        case B
        case C
    }

    enum Number: Int, CaseIterable {
        case One=1
        case Two=2
        case Three=3
    }
}

extension Card: Hashable {
    func hash(into hasher: inout Hasher){
        hasher.combine(shape)
        hasher.combine(shading)
        hasher.combine(number)
        hasher.combine(color)
    }
}
