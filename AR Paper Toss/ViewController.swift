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
    case cylinder = 4
    case tube = 5
    
}

class ViewController: UIViewController, SCNPhysicsContactDelegate {
    
    //kaden added begins
    
    var cylinder: SCNNode?
    var tube: SCNNode?
    var paperBalls: [SCNNode]?
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let NodeB = contact.nodeB
        missedIt(nodeA: nodeA, nodeB: NodeB)
        madeIt(nodeA: nodeA, nodeB: NodeB)
        
    }
    
    func missedIt(nodeA: SCNNode, nodeB: SCNNode) {
        
        var missed = false
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.tube.rawValue {
            self.tube = nodeA
            missed = true
        } else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.tube.rawValue{
            self.tube = nodeB
            missed = true
        }
        if missed == true {
            ScoreController.shared.reset()
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
            ScoreController.shared.addScore()
        }
    }
    
    //Kaden added ends
    
    
    
    
    
    // Actions
    @IBOutlet var sceneView: VirtualObjectARView!
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    
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
        sceneView.scene.rootNode.addChildNode(focusSquare)
        self.sceneView.scene.physicsWorld.contactDelegate = self
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(sender:)))
        sceneView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       resetTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, .showPhysicsShapes]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    @objc func handlePanGestureRecognizer(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended:
            guard let arScene = sender.view as? ARSCNView, let pointOfView = arScene.pointOfView, let paperScene = SCNScene(named: "Models.scnassets/Paper Ball/Paper-Ball.scn"), let ballNode = (paperScene.rootNode.childNode(withName: "paperBall", recursively: false)) else { return }
            let transform = pointOfView.transform
            let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
            let location = SCNVector3(transform.m41, transform.m42 - 0.2, transform.m43)
//                        let position = orientation + location
            ballNode.position = location
            let velocityX = abs(sender.velocity(in: arScene).x) / CGFloat(300)
            let velocity = abs(sender.velocity(in: arScene).y) / CGFloat(300)
            
            ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ballNode, options: [SCNPhysicsShape.Option.scale:ballNode.scale]))
            ballNode.physicsBody?.friction = 0.75

            ballNode.physicsBody?.categoryBitMask = BitMaskCategory.paper.rawValue
            ballNode.physicsBody?.contactTestBitMask = BitMaskCategory.cylinder.rawValue
            
            ballNode.physicsBody?.applyForce(SCNVector3(orientation.x * Float(velocity), orientation.y * Float(-velocity), orientation.z * Float(velocity)), asImpulse: true)
            arScene.scene.rootNode.addChildNode(ballNode)
            if paperBalls == nil {
                paperBalls = []
            }
            paperBalls?.append(ballNode)
            if let paperBalls = paperBalls {
                if paperBalls.count > 500 {
                    paperBalls.first?.removeFromParentNode()
                    self.paperBalls?.removeFirst()
                }
            }
        default:
            break
        }
    }
    
    func centerPivot(for node: SCNNode) {
        let min = node.boundingBox.min
        let max = node.boundingBox.max
        node.pivot = SCNMatrix4MakeTranslation(
        min.x + (max.x - min.x)/2,
        min.y + (max.y - min.y)/2,
        min.z + (max.z - min.z)/2
        )
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
    
    func startupBin() {
        
        // Add Code to create initial bin in viewDidLoad

        let startupBin = SCNScene(named: "Models.scnassets/Classic-Bin.scn")
        let startupBinNode = startupBin?.rootNode.childNode(withName: "MACOSX_paper_bin_fixed", recursively: false)
        startupBinNode?.position = SCNVector3(0,0,-3)
        self.sceneView.scene.rootNode.addChildNode(startupBinNode!)
        
        startupBinNode?.physicsBody?.categoryBitMask = BitMaskCategory.cylinder.rawValue
        startupBinNode?.physicsBody?.contactTestBitMask = BitMaskCategory.paper.rawValue

        
        
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
        } else {
            focusSquare.unhide()
            instructionsLabel.text = "Move camera around to detect floor and then push +/- to add a bin"
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
