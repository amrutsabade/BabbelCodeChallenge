//
//  WordGameViewModel.swift
//  BabbelCodeChallange
//
//  Created by Sabade Amrut on 25/05/22.
//

import Foundation
import Combine

class WordGameViewModel {
    
    var apiService: WordsAPIService
    var wordModelView: WordViewModel
    
    private var gameTimer: Timer?
    
    var currentScore: Int = 0
    var wrongAttempts : Int = 0
    
    var currentShownWord: Word?
    var optionForCurrentShownWord: Word?
    
    var guessNextWord: ((Word,Word) -> Void)?
    
    var gameFinished: (() -> Void)?
    
    var updateGameScore: (() -> Void)?

    var userDidNotAttemptWord = false
    
    init(wordsAPI: WordsAPIService, wordModelView: WordViewModel) {
        self.apiService = wordsAPI
        self.wordModelView = wordModelView
    }

    func getWords() {
        apiService.getWordsData(fileName: "words", completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let words):
                self.wordModelView.words = words
                self.startWordGame()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func startWordGame() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: .timerDuration, repeats: true) {  timer in
            let questionAndAnswerWord = self.wordModelView.getNextWord()
            self.currentShownWord = questionAndAnswerWord.0
            self.optionForCurrentShownWord = questionAndAnswerWord.1
            self.guessNextWord?(questionAndAnswerWord.0,questionAndAnswerWord.1)
            if self.shouldContinueGame() {
                self.gameTimer?.invalidate()
                self.gameFinished?()
            }
        }

    }
    
    func evaluateUserCorrectAttempt() {
        if self.currentShownWord?.translatedText == self.optionForCurrentShownWord?.translatedText {
            currentScore = currentScore + 1
        } else {
            wrongAttempts = wrongAttempts + 1
        }
        updateGameScore?()
    }
    
    func evaluateUserWrongAttempt() {
        if self.currentShownWord?.translatedText != self.optionForCurrentShownWord?.translatedText {
            currentScore = currentScore + 1
        } else {
            wrongAttempts = wrongAttempts + 1
        }
        updateGameScore?()
    }
    
    func shouldContinueGame() -> Bool {
        wrongAttempts >= 3 || currentScore >= 15
    }
    
    func resetGame() {
        wrongAttempts = 0
        currentScore = 0
        currentShownWord = nil
        updateGameScore?()
    }
    
}

fileprivate extension Double {
    static let timerDuration = 5.0
}
