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
    private var setGame: SetGame!
    private var cardForButtonTag = [Int:Card]()
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
            print("replace cards on screen, selected cards are: ", setGame.selectedCards)
        } else if cardButtons.count > setGame.cardsAvailableToPlay {
            setGame.dealThreeCards()
            print("add more cards to screen")
        }
        updateUI()
    }
    
    @IBAction func newGameButtonTouched(_ sender: UIButton) {
        startNewGame()
    }
    func show(_ card: Card, on button: UIButton){
        cardForButtonTag[button.tag] = card
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let number = [Card.Number.One: 1, .Two: 2, .Three: 3][card.number]!
        let shape = [Card.Shape.A: "▲", .B: "●", .C: "■"][card.shape]!
        let numberedShape = String(repeating: shape, count: number)
        var attributes = [NSAttributedString.Key: Any]()
        let color: UIColor = [Card.Color.A: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), .B: UIColor.magenta, .C: UIColor.orange][card.color]!
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
        let emptySpotsOnScreen = cardButtons.count - setGame.cardsAvailableToPlay
        let canDealMoreCards = (emptySpotsOnScreen > 2 || setGame.selectedCardsFormASet) && setGame.deck.count > 2
        dealThreeMoreCardsButton.isEnabled = canDealMoreCards
        scoreLabel.text = "Score: \(setGame.score)"
        print("remaining deck is \(setGame.deck.count)")
        print("number of sets found is \(setGame.removedCards.count/3)")
        
    }
    @IBAction func cheatButtonTouched(_ sender: UIButton) {
        var cardsCurrentlyShown = [Card]()
        var buttonsForCurrentlyShownCards = [UIButton]()
        for cardButton in cardButtons {
            if cardButton.backgroundColor != UIColor.clear {
                cardsCurrentlyShown.append(cardForButtonTag[cardButton.tag]!)
                buttonsForCurrentlyShownCards.append(cardButton)
            }
        }
        if let setMakingCards = setGame.findSet(in: cardsCurrentlyShown){
            print("found a set")
            for (index, card) in cardsCurrentlyShown.enumerated() {
                if setMakingCards.contains(card){
                    buttonsForCurrentlyShownCards[index].backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
                }
            }
        } else {
            print("could not find a set in shown cards")
        }
    }
}
