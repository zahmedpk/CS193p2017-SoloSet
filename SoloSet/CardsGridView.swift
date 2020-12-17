//
//  CardsGridView.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 20/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//
//  CardsGridView uses the Grid class provided by CS193p Instructor
//  to generate a grid (frames) based on available screen real estate and number
//  of dealt cards.

import UIKit

class CardsGridView: UIView {
    var cards: [CardView]! {
        didSet {
            setNeedsLayout()
        }
    }
    var originOfDealOutAnimation: CGRect?
    var destinationOfDiscardAnimation: CGRect?
    lazy var dynamicAnimator = UIDynamicAnimator(referenceView: self)
    var matchedCardsInAnimation = [CardView]()
    override func layoutSubviews() {
        var grid = Grid(layout: .aspectRatio(5.2/8.0), frame: self.bounds)
        grid.cellCount = cards.count
        var delay = 0.2
        for i in 0..<grid.cellCount {
            if i >= cards.count {
                break
            }
            let card = cards[i]
            if !self.subviews.contains(card){
                self.addSubview(card)
            }
            switch card.animationState {
            case .FlyingIn:
                if let frame = originOfDealOutAnimation {
                    card.frame = frame
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: delay, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                        card.frame =  grid[i]!.insetBy(dx: 2, dy: 2)
                    }, completion: { _ in
                        UIView.transition(with: card, duration: 0.7, options: [.beginFromCurrentState,.transitionFlipFromLeft, .curveEaseInOut], animations: {
                            card.isFaceDown = false
                        }, completion: { _ in
                            card.animationState = .NoAnimation
                        })
                    })
                    delay += 0.15
                }
            case .FlyingOut:
                card.animationState = .Discarded
                card.viewController.replaceCardWithView(card)
                let push = UIPushBehavior(items: [card], mode: .instantaneous)
                let angle = Double.random(in: 0...2*Double.pi)
                push.setAngle(CGFloat(angle), magnitude: 15)
                dynamicAnimator.addBehavior(push)
                let collision = UICollisionBehavior(items: [card])
                dynamicAnimator.addBehavior(collision)
                collision.translatesReferenceBoundsIntoBoundary = true
                let dynamicItemBehavior = UIDynamicItemBehavior(items: [card])
                dynamicItemBehavior.friction = 0
                dynamicItemBehavior.elasticity = 1
                dynamicAnimator.addBehavior(dynamicItemBehavior)
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
                    push.removeItem(card)
                    collision.removeItem(card)
                    dynamicItemBehavior.removeItem(card)
                    self.dynamicAnimator.removeBehavior(push)
                    self.dynamicAnimator.removeBehavior(collision)
                    self.dynamicAnimator.removeBehavior(dynamicItemBehavior)
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.99, initialSpringVelocity: 0.5, options: .beginFromCurrentState, animations: {
                        if let frame = self.destinationOfDiscardAnimation {
                            card.frame = frame
                        }
                    }, completion: {
                        _ in
                        UIView.transition(with: card, duration: 0.3, options: [.transitionFlipFromTop], animations: {
                            card.isFaceDown = true
                        }, completion:
                            {_ in
                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
                                    card.alpha = 0
                                }, completion: {
                                    _ in
                                    card.removeFromSuperview()
                                })
                        })
                    })
                })
            case .NoAnimation:
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                    card.frame = grid[i]!.insetBy(dx: 2, dy: 2)
                }, completion: nil)
            default:
                print("ignore discarded cards")
            }}
        if self.subviews.count < 3 {
            self.subviews.forEach { $0.removeFromSuperview() }
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            label.text = "You win 👍🏻"
            label.font = UIFont.systemFont(ofSize: 40)
            label.textColor = .orange
            label.adjustsFontSizeToFitWidth = true
            label.center = self.center
            addSubview(label)
        }
    }
}
