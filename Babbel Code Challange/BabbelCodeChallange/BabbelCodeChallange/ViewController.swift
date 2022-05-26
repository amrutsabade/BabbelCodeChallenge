//
//  ViewController.swift
//  BabbelCodeChallange
//
//  Created by Sabade Amrut on 25/05/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var correctButton: UIButton!
    @IBOutlet private var wrongButton: UIButton!

    @IBOutlet private var englishWord: UILabel!
    @IBOutlet private var optionWord: UILabel!
    
    @IBOutlet private var correctAttempts: UILabel!
    @IBOutlet private var wrongAttempts: UILabel!


    var viewModel: WordGameViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = WordGameViewModel(wordsAPI: WordsAPIService(),wordModelView: WordViewModel())

        viewModel?.getWords()
        
        viewModel?.guessNextWord = { [weak self] questionWord, answerOptionWord in
            
            DispatchQueue.main.async {
                self?.englishWord.text = questionWord.originalText
                self?.optionWord.text = answerOptionWord.translatedText
                self?.correctButton.isUserInteractionEnabled = true
                self?.wrongButton.isUserInteractionEnabled = true
            }
            
            UIView.animate(withDuration: 5,
                           delay: 0.0,
                           options: .curveEaseInOut,
                           animations: { [weak self] in
                guard let self = self else { return }
                self.optionWord.transform = CGAffineTransform(translationX: self.optionWord.bounds.origin.x, y: self.optionWord.bounds.origin.y + UIScreen.main.bounds.size.height)
            }, completion: { [weak self] _ in
                self?.optionWord.transform = CGAffineTransform.identity
                self?.englishWord.text = "Next Word Coming Soon..."
                self?.optionWord.text = ""
            })

        }
        viewModel?.gameFinished = { [weak self] in
            self?.englishWord.text = ""
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let retryAction = UIAlertAction(title: "Restart Game", style: .default, handler: { action in
                self?.viewModel?.resetGame()
                self?.viewModel?.startWordGame()
            })
            let userScore = self?.viewModel?.currentScore
            self?.showAlert(title: "Game Ended", message: "Game has ended with score \(userScore ?? 0)", actions: [ cancelAction, retryAction ])
        }
        
        viewModel?.updateGameScore = { [weak self] in
            DispatchQueue.main.async {
                self?.correctAttempts.text = String(self?.viewModel?.currentScore ?? 0)
                self?.wrongAttempts.text = String(self?.viewModel?.wrongAttempts ?? 0)
            }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func correctOptionButtonTapped(sender: Any) {
        self.correctButton.isUserInteractionEnabled = false
        self.wrongButton.isUserInteractionEnabled = false
        viewModel?.evaluateUserCorrectAttempt()
    }
    
    @IBAction func wrongOptionButtonTapped(sender: Any) {
        self.wrongButton.isUserInteractionEnabled = false
        self.correctButton.isUserInteractionEnabled = false
       viewModel?.evaluateUserWrongAttempt()
    }
    
    


}

