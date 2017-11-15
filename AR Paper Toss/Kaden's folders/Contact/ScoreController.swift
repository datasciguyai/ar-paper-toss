//
//  ScoreController.swift
//  AR Paper Toss
//
//  Created by Kaden Oldham on 11/9/17.
//  Copyright © 2017 Jeremy Reynolds. All rights reserved.
//

import Foundation

class ScoreController {
    static let shared = ScoreController()
    var currentScore = 0
    var highScore = 0
    
    
    
    var highScoreString: String {
        return("HighScore: \(highScore)")
    }
    
    func addScore() -> Int {
        currentScore = currentScore + 1
        print("score added \(currentScore)")
        return(currentScore)
    }
    
    func missed() -> Int {
        currentScore = 0
        print("\(currentScore)")
        return(currentScore)
    }
    
    func reset() -> String {
        return("HighScore: \(0)")
    }
    
    
    
    
}
