//
//  CardsGridView.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 20/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import UIKit

class CardsGridView: UIView {
    var cards: [CardView]! {
        didSet {
            setNeedsLayout()
        }
    }
    override func layoutSubviews() {
        subviews.forEach {$0.removeFromSuperview()}
        var grid = Grid(layout: .aspectRatio(5.2/8.0), frame: self.bounds)
        grid.cellCount = cards.count
        for i in 0..<grid.cellCount {
            cards[i].frame = grid[i]!.insetBy(dx: 2, dy: 2)
            self.addSubview(cards[i])
        }
    }
}
