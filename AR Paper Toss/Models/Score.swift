//
//  Score.swift
//  AR Paper Toss
//
//  Created by Johnny Hicks on 11/15/17.
//  Copyright © 2017 Jeremy Reynolds. All rights reserved.
//

import Foundation

class Score {
    
    private let scoreKey = "score"
    
    var score: Int
    
    init(score: Int){
        self.score = score
    }
    
    init?(dictionary: [String: Any]) {
        guard let score = dictionary[scoreKey] as? Int else { return nil }
        self.score = score
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        return [scoreKey: score]
    }
}
