//
//  CardView.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 24/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import UIKit

class CardView: UIButton {
    var shapeViews : [ShapeView]! {
        didSet {
            setNeedsLayout()
        }
    }
    var viewController: GraphicalSoloSetViewController!
    var borderColor: CGColor!
    override func layoutSubviews() {
        if isSelected {
            self.layer.borderWidth = 2.0
        } else {
            self.layer.borderWidth = 1.0
        }
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = 2
        if self.bounds.width > 100 {
            self.layer.cornerRadius = 5
        }
        super.layoutSubviews()
        var grid : Grid!
        if self.bounds.width > 100 {
            grid = Grid(layout: .aspectRatio(Constants.aspectRatioOfShapes), frame: self.bounds.insetBy(dx: 12, dy: 12))
        } else {
            grid = Grid(layout: .aspectRatio(Constants.aspectRatioOfShapes), frame: self.bounds.insetBy(dx: 2, dy: 2))
        }
        
        
        grid.cellCount = shapeViews.count
        for i in 0..<grid.cellCount {
            shapeViews[i].frame = grid[i]!.insetBy(dx: 2, dy: 2)
            self.addSubview(shapeViews[i])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: viewController, action: #selector(viewController.handleTap(recognizer:))))
    }
}
