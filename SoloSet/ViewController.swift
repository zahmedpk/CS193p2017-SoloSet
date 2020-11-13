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
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            cardButtons.shuffle()
        }
    }
    func resetUI(){
        //make all buttons invisible
        for cardButton in cardButtons {
            cardButton.setTitle("", for: .normal)
            cardButton.backgroundColor = .clear
            cardButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    var setGame: SetGame!
    var cardForButtonTag = [Int:Card]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction func newGameButtonTouched(_ sender: UIButton) {
        
    }
    func show(_ card: Card, on button: UIButton){
        cardForButtonTag[button.tag] = card
        button.backgroundColor = .systemGray5
        let number = card.number+1
        let shape = [0: "▲", 1: "●", 2: "■"][card.shape]!
        let numberedShape = String(repeating: shape, count: number)
        var attributes = [NSAttributedString.Key: Any]()
        let color = [0: UIColor.cyan, 1: UIColor.magenta, 2: UIColor.orange][card.color]!
        switch card.shading {
        case 0://outline
            attributes[.foregroundColor] = color.withAlphaComponent(1.0)
            attributes[.strokeWidth] = 5
        case 1://striped
            attributes[.foregroundColor] = color.withAlphaComponent(0.25)
        case 2://filled
            attributes[.foregroundColor] = color.withAlphaComponent(1.0)
        default:
            preconditionFailure("found unexpected value of card.shading :\(card.shading)")
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
                print("card is to be removed")
                hide(cardButtons[index])
            }
        }
        
    }
}
