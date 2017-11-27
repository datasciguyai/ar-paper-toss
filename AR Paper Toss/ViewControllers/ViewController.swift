//
//  ViewController.swift
//  PaperTossARDay1
//
//  Created by Sam Bryson on 11/6/17.
//  Copyright © 2017 SamuelGBryson. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum BitMaskCategory: Int {
    case paper = 3
    case cylinder = 1
    case floor = 14
    
}

class ViewController: UIViewController, SCNPhysicsContactDelegate, planeDetectedDelegate {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    let fire = SCNParticleSystem(named: "Models.scnassets/Paper Ball/fire.scnp", inDirectory: nil)
    var cylinder: SCNNode?
    var tube: SCNNode?
    var floor: SCNNode?
    var paperBalls: [SCNNode] = []
    var scoredNodes: [SCNNode] = []
    var paperBinPlaced = false
    let impact = UIImpactFeedbackGenerator()

    
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        missedIt(nodeA: nodeA, nodeB: nodeB)
        madeIt(nodeA: nodeA, nodeB: nodeB)
        
        
        
    }
    
    func missedIt(nodeA: SCNNode, nodeB: SCNNode) {
        var missed = false
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.floor.rawValue {
            self.floor = nodeA
            missed = true
        } else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.floor.rawValue{
            self.floor = nodeB
            missed = true
        }
        if missed == true {
            if nodeA.name == "paperBall" {
                if !scoredNodes.contains(nodeA) {
                    ScoreController.shared.missed()
                    scoredNodes.append(nodeA)
                    print("miss")
                    DispatchQueue.main.async {
                        self.scoreLabel.text = "Score: \(ScoreController.shared.currentScore)"
                        self.reloadInputViews()
                    }
                }
            } else if nodeB.name == "paperBall" {
                if !scoredNodes.contains(nodeB) {
                    ScoreController.shared.missed()
                    scoredNodes.append(nodeB)
                    print("miss")
                    DispatchQueue.main.async {
                        self.scoreLabel.text = "Score: \(ScoreController.shared.currentScore)"
                        self.reloadInputViews()
                    }
                }
            }
        }

    }
    

    
    func madeIt(nodeA: SCNNode, nodeB: SCNNode) {
        
        var inBasket = false
        
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.cylinder.rawValue {
            self.cylinder = nodeA
            inBasket = true
        } else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.cylinder.rawValue {
            self.cylinder = nodeB
            inBasket = true
        }
        if inBasket == true {
            if nodeA.name == "paperBall" {
                if !scoredNodes.contains(nodeA) {
                    scoredNodes.append(nodeA)
                    ScoreController.shared.addScore()
                    DispatchQueue.main.async {
                        self.impact.impactOccurred()
                        if ScoreController.shared.currentScore >= ScoreController.shared.highScore.score {
                            self.scoreLabel.text = "Score: \(ScoreController.shared.currentScore) 🏅"
                            ScoreController.shared.highScoreForFireBall = true
                            
                        } else {
                            self.scoreLabel.text = "Score: \(ScoreController.shared.currentScore)"
                            
                        }
                        self.reloadInputViews()
                    }
                }
            } else if nodeB.name == "paperBall" {
                if !scoredNodes.contains(nodeB) {
                    scoredNodes.append(nodeB)
                    ScoreController.shared.addScore()
                    DispatchQueue.main.async {
                        self.impact.impactOccurred()
                        if ScoreController.shared.currentScore >= ScoreController.shared.highScore.score {
                            self.scoreLabel.text = "Score: \(ScoreController.shared.currentScore) 🏅"
                            ScoreController.shared.highScoreForFireBall = true
                            
                        } else {
                            self.scoreLabel.text = "Score: \(ScoreController.shared.currentScore)"
                            
                        }
                        self.reloadInputViews()
                    }
                }
            }
        }
    }
    
    // Actions
    @IBOutlet var sceneView: VirtualObjectARView!
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var moveBinUILabel: UILabel!
    
    var session: ARSession {
        return sceneView.session
    }
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    var focusSquare = FocusSquare()
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    let virtualObjectLoader = VirtualObjectLoader()
    let updateQueue = DispatchQueue(label: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        setupCamera()
        let configuration = ARWorldTrackingConfiguration()
        self.instructionsLabel.text = "Move camera around to detect a playing surface"
        focusSquare.delegate = self
        sceneView.scene.rootNode.addChildNode(focusSquare)
        self.sceneView.session.run(configuration)
        self.sceneView.scene.physicsWorld.contactDelegate = self
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(sender:)))
        sceneView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    func updatePlaneDetectedUI() {
        DispatchQueue.main.async {
            self.instructionsLabel.text = "Surface detected! Press the +/- button to place objects"
            self.addObjectButton.isEnabled = true
        }
    }
    
    func updateSurfaceDetectedUI() {
        DispatchQueue.main.async {
            self.instructionsLabel.text = "Detecting..."
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       resetTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    @objc func handlePanGestureRecognizer(sender: UIPanGestureRecognizer) {
        moveBinUILabel.isHidden = true
        switch sender.state {
        case .ended:
            
            guard paperBinPlaced, let arScene = sender.view as? ARSCNView, let pointOfView = arScene.pointOfView, let paperScene = SCNScene(named: "Models.scnassets/Paper Ball/Paper-Ball.scn"), let ballNode = (paperScene.rootNode.childNode(withName: "paperBall", recursively: false)) else { return }
            
            let transform = pointOfView.transform
            let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
            let location = SCNVector3(transform.m41, transform.m42 - 0.2, transform.m43)
//                        let position = orientation + location
            ballNode.position = location
//            let velocityX = abs(sender.velocity(in: arScene).x) / CGFloat(300)
            let velocity = abs(sender.velocity(in: arScene).y) / CGFloat(300)
            ballNode.name = "paperBall"
            ballNode.physicsBody?.applyForce(SCNVector3(orientation.x * Float(velocity), orientation.y * Float(-velocity), orientation.z * Float(velocity)), asImpulse: true)
            arScene.scene.rootNode.addChildNode(ballNode)
            
            paperBalls.append(ballNode)
                if paperBalls.count > 75 {
                    paperBalls.first?.removeFromParentNode()
                    self.paperBalls.removeFirst()
                }
        default:
            break
        }
    }
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        /*
         Enable HDR camera settings 
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }

    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    // MARK: - Focus Square
    func updateFocusSquare() {
        
        let isObjectVisible = virtualObjectLoader.loadedObjects.contains { object in
            return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        }
        
        if isObjectVisible {
            focusSquare.hide()
            instructionsLabel.text = ""
            currentScoreLabel.isHidden = false
        } else {
            focusSquare.unhide()
        // instructionsLabel.text = "Move camera around to detect floor and then push +/- to add a bin"
            currentScoreLabel.isHidden = true
            moveBinUILabel.isHidden = true
        }
        
        // We should always have a valid world position unless the sceen is just being initialized.
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition) else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            return
        }

        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
            let camera = self.session.currentFrame?.camera
            
            if let planeAnchor = planeAnchor {
                self.focusSquare.state = .planeDetected(anchorPosition: worldPosition, planeAnchor: planeAnchor, camera: camera)
            } else {
                self.focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
    }
}

func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + lhs.z)
}
