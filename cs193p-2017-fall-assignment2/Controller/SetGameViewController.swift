//
//  SetGameViewController.swift
//  cs193p-2017-fall-assignment2
//
//  Created by Ksenia Surikova on 25.05.2022.
//

import UIKit

class SetGameViewController: UIViewController {

    private var game = SetGame()

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet var cardButtons: [SetCardButton]!
    {
        didSet {
            getReadyToStart()
        }
    }
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        game.dealCards()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: SetCardButton) {
        if let card = sender.card {
            game.chooseCard(card: card)
            updateViewFromModel()
        }
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        getReadyToStart()
        updateScore()
        updateDealCardsButtonState()
    }
    
    private func getReadyToStart(){
        game = SetGame()
        assert(cardButtons.count > SetGame.startFacedUpCardsCount, "No enought card views for game")
        let shuffledIndices = cardButtons.indices.shuffled()
        for index in shuffledIndices {
            cardButtons[shuffledIndices[index]].card = index < SetGame.startFacedUpCardsCount ? game.cardsOnView[index] : nil
        }
    }
    
    private func updateViewFromModel(){
        updateButtonsFromModel()
        updateScore()
        updateDealCardsButtonState()
    }

    private func updateDealCardsButtonState(){
        dealCardsButton.isEnabled = game.canDealMoreCards() && cardButtons.filter({$0.card == nil}).count >= SetGame.cardsToDealAndCheckCount
    }
    
    private func updateScore()
    {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func updateButtonsFromModel(){
        // new or removed cards
        let newCards = game.cardsOnView.filter{!cardButtons.compactMap({$0.card}).contains($0)}
        let changedButtons = cardButtons.filter({$0.card != nil && !game.cardsOnView.contains($0.card!)})
        if changedButtons.count != 0 {
            if newCards.count != 0 {
                for index in 0..<newCards.count {
                    changedButtons[index].card = newCards[index]
                }
            }
            else {
                for index in 0..<changedButtons.count {
                    changedButtons[index].card = nil
                }
            }
        }
        else {
            let emptyButtons = cardButtons.filter{$0.card == nil}
            for index in 0..<newCards.count {
                emptyButtons[index].card = newCards[index]
            }
        }
       
        // set borders depends on matching or simply selected
        if let isMatched = game.isSet {
            for index in 0..<cardButtons.count {
                if let card = cardButtons[index].card {
                    if game.cardsChosen.contains(card) {cardButtons[index].setBorderColor(at: isMatched ? SetGameUIConstants.matchedCardColor : SetGameUIConstants.mismatchedCardColor)}
                }
            }
        }
        else {
            // else borders for chosen cards
            for index in 0..<cardButtons.count {
                if let card = cardButtons[index].card {
                    if game.cardsChosen.contains(card) { cardButtons[index].setBorderColor(at: SetGameUIConstants.chosenCardColor)}
                    else {cardButtons[index].clearBorder()}
                }
                else {cardButtons[index].clearBorder()}
            }
        }
    }
}

private struct SetGameUIConstants {
    static let chosenCardColor : UIColor = #colorLiteral(red: 0.05665164441, green: 0.2764216363, blue: 1, alpha: 1)
    static let matchedCardColor : UIColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
    static let mismatchedCardColor : UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
}



extension UIButton {
    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
