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
    var viewForCard = [Card:CardView]()
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        cardsGridView.setNeedsLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        deal12Cards()
        showDealtCards()
    }
    override func viewDidAppear(_ animated: Bool) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(recognizer:)))
        swipeGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        self.view.isUserInteractionEnabled = true
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGestureRecognizer(recognizer:)))
        self.view.addGestureRecognizer(rotationGestureRecognizer)
        
    }
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        let cardView = recognizer.view as! CardView
        cardView.borderColor = UIColor.blue.cgColor
        if let card = game.dealtCards.first(where: {$0.id == cardView.tag}){
            game.select(card: card)
            showDealtCards()
        }
    }
    @objc func handleSwipeGesture(recognizer: UISwipeGestureRecognizer){
        game.dealThreeCards()
        showDealtCards()
    }
    @objc func handleRotationGestureRecognizer(recognizer: UIRotationGestureRecognizer){
        if recognizer.state == .recognized {
            game.shuffleDealtCards()
            showDealtCards()
        }
    }
    func makeACardView(for card: Card) -> CardView {
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
        cardView.clipsToBounds = true
        viewForCard[card] = cardView
        return cardView
    }
    func showDealtCards(){
        updateDiscardPileTitle(setsFound: game.removedCards.count/3)
        var cardViews = [CardView]()
        for card in game.dealtCards {
            let cardView = viewForCard[card] ?? makeACardView(for: card)
            cardView.isChosen = game.selectedCards.contains(card)
            if cardView.isChosen {
                if game.selectedCards.count < 3 {
                    cardView.borderColor = UIColor.blue.cgColor
                } else if game.isASet(in: game.selectedCards){
                    cardView.borderColor = UIColor.green.cgColor
                    cardView.animationState = .FlyingOut
                } else {
                    cardView.borderColor = UIColor.red.cgColor
                }
            } else {
                cardView.borderColor = UIColor.gray.cgColor
            }
            cardViews.append(cardView)
        }
        cardsGridView.cards = cardViews
        scoreLabel.text = "Score: \(game.score)"
    }
    func deal12Cards(){
        for _ in 1...4 {
            game.dealThreeCards()
        }
    }
    @IBAction func deal3MoreCardsButtonTapped(_ sender: UIButton) {
        add3MoreCards()
    }
    func add3MoreCards(){
        if game.deck.count > 0 {
            game.dealThreeCards()
            showDealtCards()
        }
        if game.deck.count == 0 {
            deal3MoreCardsButton.isEnabled = false
        }
    }
    @IBOutlet var deal3MoreCardsButton: UIButton!
    @IBAction func newGameButtonTapped(_ sender: UIButton) {
        cardsGridView.subviews.forEach {$0.removeFromSuperview()}
        viewForCard.removeAll()
        game = SetGame()
        deal12Cards()
        showDealtCards()
        deal3MoreCardsButton.isEnabled = true
        updateDiscardPileTitle(setsFound: game.removedCards.count/3)
    }
    @IBOutlet var scoreLabel: UILabel!
    @IBAction func cheatButtonTapped(_ sender: UIButton) {
        if let foundSet = game.findSet(in: game.dealtCards){
            let foundIds = foundSet.map {$0.id}
            for cardView in cardsGridView.subviews {
                if foundIds.contains(cardView.tag){
                    cardView.layer.borderColor = UIColor.orange.cgColor
                    cardView.layer.borderWidth = 3.0
                }
            }
        }
    }
    func updateDiscardPileTitle(setsFound: Int){
        let setsFound: Int = game.removedCards.count/3
        let suffix = setsFound == 1 ? "" : "s"
        discardPileButton.setTitle("\(setsFound) Set" + suffix, for: .normal)
        discardPileButton.sizeToFit()
        discardPileButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBOutlet var discardPileButton: UIButton!
    override func viewDidLayoutSubviews() {
        cardsGridView.originOfDealOutAnimation = deal3MoreCardsButton.convert(deal3MoreCardsButton.bounds.insetBy(dx: 1, dy: 1), to: cardsGridView)
        cardsGridView.destinationOfDiscardAnimation = discardPileButton.convert(discardPileButton.bounds.insetBy(dx: 1, dy: 1), to: cardsGridView)
    }
    private var countOfPendingCardsForReplacement = 0
    func replaceCardWithView(_ cardView: CardView){
        if game.dealtCards.first(where: {$0.id == cardView.tag}) != nil{
            countOfPendingCardsForReplacement += 1
        }
        if countOfPendingCardsForReplacement == 3 {
            countOfPendingCardsForReplacement = 0
            game.replaceSelectedCards()
            showDealtCards()
        }
        updateDiscardPileTitle(setsFound: game.removedCards.count/3)
    }
}
