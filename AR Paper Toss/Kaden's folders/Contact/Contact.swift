//
//  Contact.swift
//  AR Paper Toss
//
//  Created by Kaden Oldham on 11/9/17.
//  Copyright © 2017 Jeremy Reynolds. All rights reserved.
//

import ARKit

//enum BitTaskCategory: Int {
//    case paper = 2
//    case cylinder = 3
//    case tube = 4
//
//}


//class Contact: UIViewController, SCNPhysicsContactDelegate {

    
//
//
//    static let shared = Contact()
//
//    var cylinder: SCNNode?
//    var tube: SCNNode?
//
//
//     func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
//        let nodeA = contact.nodeA
//        let NodeB = contact.nodeB
//        missedIt(nodeA: nodeA, nodeB: NodeB)
//        madeIt(nodeA: nodeA, nodeB: NodeB)
//
//
//
//
//    }
//
//

//     func missedIt(nodeA: SCNNode, nodeB: SCNNode) {
//
//        var missed = false
//        if nodeA.physicsBody?.categoryBitMask == BitTaskCategory.tube.rawValue {
//            self.tube = nodeA
//            missed = true
//        } else if nodeB.physicsBody?.categoryBitMask == BitTaskCategory.tube.rawValue{
//            self.tube = nodeB
//            missed = true
//        }
//        if missed == true {
//            ScoreController.shared.reset()
//        }
//
//    }
//
//    func madeIt(nodeA: SCNNode, nodeB: SCNNode) {
//        var inBasket = false
//
//        if nodeA.physicsBody?.categoryBitMask == BitTaskCategory.cylinder.rawValue {
//            self.cylinder = nodeA
//            inBasket = true
//        } else if nodeB.physicsBody?.categoryBitMask == BitTaskCategory.cylinder.rawValue {
//            self.cylinder = nodeB
//            inBasket = true
//        }
//        if inBasket == true {
//            ScoreController.shared.addScore()
//        }
//    }
//
//}





