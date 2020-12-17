//
//  CardView.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 24/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//
// CardView provides the visual representation of each of
// the 81 SET cards. It draws the shapes using ShapeView subviews.

import UIKit

class CardView: UIButton {
    var shapeViews : [ShapeView]! {
        didSet {
            setNeedsLayout()
        }
    }
    var viewController: GraphicalSoloSetViewController!
    var borderColor: CGColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    var isFaceDown: Bool  = true {
        didSet{
            setNeedsLayout()
        }
    }
    enum AnimationState {
        case NoAnimation
        case FlyingIn
        case FlyingOut
        case Discarded
    }
    var animationState: AnimationState = .FlyingIn
    static var fontSizeForDimension = [CGSize: CGFloat]()
    var isMatched = false
    var isChosen = false
    override func draw(_ rect: CGRect) {
        if isChosen {
            self.layer.borderWidth = 2.0
        } else {
            self.layer.borderWidth = 1.0
        }
        self.layer.borderColor = borderColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach {$0.removeFromSuperview()}
        var maxFontSize: CGFloat = 99
        if isFaceDown {
            self.backgroundColor = .white
            var attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "AmericanTypewriter-Bold", size: maxFontSize)!,
                .obliqueness: 0.1,
                .strokeColor: UIColor.orange,
                .strokeWidth: -3.0,
                .foregroundColor: UIColor.yellow,
            ]
            let label = UILabel(frame: self.bounds.insetBy(dx: 5, dy: 5))
            label.textAlignment = .center
            var attributedText = NSAttributedString(string: "SET", attributes: attributes)
            if let fontSize = CardView.fontSizeForDimension[self.bounds.size]{
                //using precomputed font size
                attributes[.font] = UIFont(name: "AmericanTypewriter-Bold", size: fontSize)!
                attributedText = NSAttributedString(string: "SET", attributes: attributes)
            } else {
                //computing font size
                while label.bounds.width < (attributedText.size().width+2) {
                    maxFontSize -= 1
                    attributes[.font] = UIFont(name: "AmericanTypewriter-Bold", size: maxFontSize)!
                    attributedText = NSAttributedString(string: "SET", attributes: attributes)
                }
                CardView.fontSizeForDimension[self.bounds.size] = maxFontSize
            }
            label.attributedText = attributedText
            self.addSubview(label)
        } else {
            self.backgroundColor = .white
            self.layer.cornerRadius = 4
            if self.bounds.width > 100 {
                self.layer.cornerRadius = 5
            }
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
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: viewController, action: #selector(viewController.handleTap(recognizer:))))
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
