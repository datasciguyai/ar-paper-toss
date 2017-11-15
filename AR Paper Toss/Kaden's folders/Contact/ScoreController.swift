//
//  ScoreController.swift
//  AR Paper Toss
//
//  Created by Kaden Oldham on 11/9/17.
//  Copyright © 2017 Jeremy Reynolds. All rights reserved.
//

import Foundation

class ScoreController {
    private let highScoreKey = "highScore"
    static let shared = ScoreController()
    
    var highScore: Score = {
        return Score(score: 0)
    }()
    
    var highScoreString: String {
        return("HighScore: \(highScore.score)")
    }
    
    init() {
        loadFromPersistence()
    }
    
    func addScore() -> Int {
        highScore.score += 1
        saveToPersistence()
        return(highScore.score)
    }
    
    func missed() -> Int {
        currentScore = 0
        print("\(currentScore)")
        return(currentScore)
    }
    
    func reset() -> String {
        highScore.score = 0
        saveToPersistence()
        return("HighScore: 0")
    }
    
    func saveToPersistence() {
        let scoreDictionary = highScore.dictionaryRepresentation()
        UserDefaults.standard.set(scoreDictionary, forKey: highScoreKey)
    }
    
    func loadFromPersistence() {
        if let scoreDictionary = UserDefaults.standard.object(forKey: highScoreKey) as? [String: Any], let highScore = Score(dictionary: scoreDictionary) {
        self.highScore = highScore
        }
    }
}
