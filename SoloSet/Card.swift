//
//  Card.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 12/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import Foundation

struct Card {
    //A single card representing one of the 81 permutations of shape, shading, number and color.
    // each of these four features can take one of 3 possible values, i.e 0, 1, 2
    let shape: Int
    let shading: Int
    let number: Int
    let color: Int
}
