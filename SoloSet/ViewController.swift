//
//  ViewController.swift
//  SoloSet
//
//  Created by Zubair Ahmed on 12/11/2020.
//  Copyright © 2020 Zubair Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet var dealThreeMoreCardsButton: UIButton!
    var setGame: SetGame!
    var cardForButtonTag = [Int:Card]()
    func resetUI(){
        //make all buttons invisible
        for cardButton in cardButtons {
            cardButton.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
            cardButton.setTitle("", for: .normal)
            cardButton.backgroundColor = .clear
            cardButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    func startNewGame() {
        cardForButtonTag.removeAll()
        cardButtons.shuffle()
        setGame = SetGame()
        //deal 12 cards from the deck
        for _ in 1...4 {
            setGame.dealThreeCards()
        }
        updateUI()
    }
    
    @IBAction func cardButtonTouched(_ sender: UIButton) {
        if let card = cardForButtonTag[sender.tag] {
            setGame.select(card: card)
            updateUI()
        }
    }
    
    @IBAction func dealThreeMoreCardsButtonTouched(_ sender: UIButton) {
        if setGame.selectedCardsFormASet && setGame.deck.count >= 3 {
            setGame.replaceSelectedCards()
        } else if cardButtons.count > setGame.cardsAvailable {
            setGame.dealThreeCards()
        }
        updateUI()
    }
    
    @IBAction func newGameButtonTouched(_ sender: UIButton) {
        startNewGame()
    }
    func show(_ card: Card, on button: UIButton){
        cardForButtonTag[button.tag] = card
        button.backgroundColor = .systemGray5
        let number = card.number.rawValue+1
        let shape = [0: "▲", 1: "●", 2: "■"][card.shape.rawValue]!
        let numberedShape = String(repeating: shape, count: number)
        var attributes = [NSAttributedString.Key: Any]()
        let color = [0: UIColor.cyan, 1: UIColor.magenta, 2: UIColor.orange][card.color.rawValue]!
        switch card.shading {
        case .A://outline
            attributes[.foregroundColor] = color.withAlphaComponent(1.0)
            attributes[.strokeWidth] = 5
        case .B://striped
            attributes[.foregroundColor] = color.withAlphaComponent(0.25)
        case .C://filled
            attributes[.foregroundColor] = color.withAlphaComponent(1.0)
        }
        let attributedString = NSAttributedString(string: numberedShape , attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.minimumScaleFactor = 0.1
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    func hide(_ button: UIButton){
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
    }
    func updateUI(){
        //update user interface based on dealtCards, selectedCards and removedCards
        //go over the dealt cards and put them on buttons sequentually
        //if card is selected as well then draw borders around them
        //the borders around the cards can be green(matching), red(non-matching)
        // and blue(just two selected)
        resetUI()
        for (index, card) in setGame.dealtCards.enumerated() {
            if !setGame.removedCards.contains(card){
                show(card, on: cardButtons[index])
                if setGame.selectedCards.contains(card){
                    cardButtons[index].layer.borderWidth = 3.0
                    cardButtons[index].layer.borderColor = UIColor.blue.cgColor
                    if setGame.selectedCardsFormASet {
                        cardButtons[index].layer.borderColor = UIColor.green.cgColor
                    } else if setGame.selectedCards.count == 3 {//bad selection
                        cardButtons[index].layer.borderColor = UIColor.red.cgColor
                    }   
                }
            } else {
                hide(cardButtons[index])
            }
        }
        let emptySpotsOnScreen = cardButtons.count - setGame.cardsAvailable
        let canDealMoreCards = (emptySpotsOnScreen > 2 || setGame.selectedCardsFormASet) && setGame.deck.count > 2
        dealThreeMoreCardsButton.isEnabled = canDealMoreCards
        scoreLabel.text = "Score: \(setGame.score)"
    }
}
