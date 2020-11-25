//
//  GraphicalSoloSetViewController.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 19/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import UIKit

class GraphicalSoloSetViewController: UIViewController {
    @IBOutlet var cardsGridView: CardsGridView!
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cardsGridView.setNeedsLayout()
    }
    var game = SetGame()
    let colorMapping: [Card.Color: UIColor] = [
        .A: .green,
        .B: .red,
        .C: .purple
    ]
    let shapeMapping: [Card.Shape: ShapeView.Kind] = [
        .A: .Diamond,
        .B: .Squiggle,
        .C: .Stadium
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deal12Cards()
        showDealtCards()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("grid has \(cardsGridView.subviews.count) cards")
    }
    @objc func foo(recognizer: UITapGestureRecognizer){
        let cardView = recognizer.view as! CardView
        let card = game.dealtCards.first(where: {$0.id == cardView.tag})
        game.select(card: card!)
        showDealtCards()
    }
    func showDealtCards(){
        var cardViews = [CardView]()
        for card in game.dealtCards {
            var shapeViews = [ShapeView]()
            for _ in 1...card.number.rawValue {
                let shapeView = ShapeView()
                shapeView.color = colorMapping[card.color]!
                shapeView.isFilled = card.shading == Card.Shading.C
                shapeView.isStriped = card.shading == Card.Shading.B
                shapeView.shape = shapeMapping[card.shape]!
                shapeViews.append(shapeView)
            }
            let cardView = CardView()
            cardView.shapeViews = shapeViews
            cardView.tag = card.id
            cardView.viewController = self
            cardView.isSelected = game.selectedCards.contains(card)
            if cardView.isSelected {
                if game.selectedCards.count < 3 {
                    cardView.borderColor = UIColor.blue.cgColor
                } else if game.isASet(in: game.selectedCards){
                    cardView.borderColor = UIColor.green.cgColor
                } else {
                    cardView.borderColor = UIColor.red.cgColor
                }
            } else {
                cardView.borderColor = UIColor.gray.cgColor
            }
            cardViews.append(cardView)
        }
        cardsGridView.cards = cardViews
    }
    func deal12Cards(){
        for _ in 1...4 {
            game.dealThreeCards()
        }
    }
    @IBAction func deal3MoreCardsButtonTapped(_ sender: UIButton) {
        if game.deck.count > 0 {
            if game.selectedCardsFormASet {
                game.replaceSelectedCards()
            } else {
                game.dealThreeCards()
            }
            showDealtCards()
        }
        if game.deck.count == 0 {
            deal3MoreCardsButton.isEnabled = false
        }
    }
    @IBOutlet var deal3MoreCardsButton: UIButton!
}
