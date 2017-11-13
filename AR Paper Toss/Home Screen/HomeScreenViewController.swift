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
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    func setHighScore() {
        highScoreLabel.text = ScoreController.shared.highScoreString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playNowButton.layer.cornerRadius = 20
        resetHighScoreButton.layer.cornerRadius = 20
        
    }
    
    
    
    /*
    var screenCenter: CGPoint {
        let bounds = homeScreenSceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//    setupCamera()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       let configuration = ARWorldTrackingConfiguration()
       homeScreenSceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeScreenSceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera() {
        guard let camera = homeScreenSceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }

*/
}

