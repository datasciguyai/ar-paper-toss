//
//  HomeScreenViewController.swift
//  PaperTossARDay1
//
//  Created by Sam Bryson on 11/7/17.
//  Copyright © 2017 SamuelGBryson. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var playNowButton: UIButton!
    @IBOutlet weak var resetHighScoreButton: UIButton!
    
    @IBAction func resetScoreButton(_ sender: Any) {
        resetScore()
    }
    
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    func resetScore() {
        highScoreLabel.text = "\(ScoreController.shared.reset())"
    }
    
    func setHighScore() {
        highScoreLabel.text = ScoreController.shared.highScoreString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScoreController.shared.loadFromPersistence()
        setHighScore()
        playNowButton.layer.cornerRadius = 20
        resetHighScoreButton.layer.cornerRadius = 20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setHighScore()
    }
}

