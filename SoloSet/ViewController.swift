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
            //make all buttons invisible
            for cardButton in cardButtons {
                cardButton.setTitle("", for: .normal)
                cardButton.backgroundColor = .clear
            }
            //shuffle cardButton positions
            cardButtons.shuffle()
        }
    }
    var setGame: SetGame!
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame = SetGame()
        //deal 12 cards from the deck
        for _ in 1...4 {
            setGame.dealThreeCards()
        }
        //show the dealt cards to user
        for (index, card) in setGame.dealtCards.enumerated() {
            show(card, on: cardButtons[index])
        }
    }
    
    @IBAction func cardButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func dealThreeMoreCardsButtonTouched(_ sender: UIButton) {
    }
    
    @IBAction func newGameButtonTouched(_ sender: UIButton) {
    }
    func show(_ card: Card, on button: UIButton){
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
//            attributes[.strokeWidth] = -5
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
}
