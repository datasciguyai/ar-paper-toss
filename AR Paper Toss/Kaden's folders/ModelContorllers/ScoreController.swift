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
    
    var highScore = 0
    
    func addScore() -> Int {
        highScore = highScore + 1
        return(highScore)
    }
    
    func reset() -> Int {
        highScore = 0
        return(highScore)
    }
}
