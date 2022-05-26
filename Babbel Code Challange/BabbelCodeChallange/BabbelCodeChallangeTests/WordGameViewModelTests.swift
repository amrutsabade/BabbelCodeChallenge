//
//  WordGameViewModelTests.swift
//  BabbelCodeChallangeTests
//
//  Created by Sabade Amrut on 26/05/22.
//

import XCTest
@testable import BabbelCodeChallange

class WordGameViewModelTests: XCTestCase {

    var wordGameViewModel: WordGameViewModel?
    override func setUp() {
        super.setUp()
        wordGameViewModel = WordGameViewModel(wordsAPI: WordsAPIService(), wordModelView: WordViewModel())
    }
    
    func test_FetchData_FomLocalJsonIs_Successfull() {
        wordGameViewModel?.apiService.getWordsData(fileName: "words", completion: {  result in
            
            switch result {
            case .success(let words):
                XCTAssertNotNil(words)
                self.wordGameViewModel?.wordModelView.words = words
                let word = self.wordGameViewModel?.wordModelView.getNextWord()
                XCTAssertNotNil(word)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func test_FetchData_FomLocalJsonIs_NotSuccessfull() {
        wordGameViewModel?.apiService.getWordsData(fileName: "No_words", completion: {  result in
            
            switch result {
            case .success(let words):
                XCTAssertNil(words)
            case .failure(let error):
                XCTAssertNotNil(error)
                print(error.localizedDescription)
            }
        })
    }
    
    func test_initial_Game_State() {
        XCTAssertEqual(wordGameViewModel?.wrongAttempts, 0)
        XCTAssertEqual(wordGameViewModel?.currentScore, 0)
    }
    
    func test_Game_StateAfter_Playing() {
        wordGameViewModel?.currentScore = 3
        wordGameViewModel?.wrongAttempts = 2
        XCTAssertEqual(wordGameViewModel?.wrongAttempts, 2)
        XCTAssertEqual(wordGameViewModel?.currentScore, 3)
    }
    
    func test_WhenGameStatus_GraterThanAllowed_StatusIsOver() {
        wordGameViewModel?.wrongAttempts = 3
        let isGameOver = wordGameViewModel?.shouldContinueGame() ?? false
        XCTAssertTrue(isGameOver)
    }
    
    func test_WhenGameStatus_IsReset() {
        wordGameViewModel?.currentScore = 3
        wordGameViewModel?.wrongAttempts = 2
        XCTAssertEqual(wordGameViewModel?.wrongAttempts, 2)
        XCTAssertEqual(wordGameViewModel?.currentScore, 3)
        wordGameViewModel?.resetGame()
        XCTAssertEqual(wordGameViewModel?.wrongAttempts, 0)
        XCTAssertEqual(wordGameViewModel?.currentScore, 0)
    }



    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
