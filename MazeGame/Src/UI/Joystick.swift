//
//  Joystick.swift
//  MazeGame
//
//  Created by Richard Plesnik on 04/02/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Class for joystick for movement
class Joystick {
    // var size : CGSize
    var node: SKShapeNode!
    var outerNode: SKShapeNode!

    private var size: CGFloat!
    private var range = CGFloat(100.0)

    private var fingerPosition = CGPoint()

    private var movementAngle: CGFloat!
    private var rotationAngle: CGFloat!

    private var scene: SKScene!

    init(scene: SKScene, size: CGFloat) {
        self.scene = scene
        self.size = size
        node = SKShapeNode(circleOfRadius: size)
        node.position.x = 110 // 110 scene.size.width / 2
        node.position.y = 70 // 70 scene.size.height / 2
        node.zPosition = 3
        node.strokeColor = UIColor(red: 1, green: 62 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        outerNode = SKShapeNode(circleOfRadius: size)
        outerNode.position.x = 110 //scene.size.width / 2
        outerNode.position.y = 70 // scene.size.height / 2 
        outerNode.zPosition = 2
        outerNode.strokeColor = UIColor.black // UIColor(red: 56 / 255, green: 62 / 255, blue: 101 / 255, alpha: 1) // 383e65
        addToScene()
    }

    
    /// Calculate joystick position
    /// - Parameters:
    ///   - fingerPosition: finger position
    ///   - canMove: true if player can move
    func tick(fingerPosition: CGPoint, canMove: Bool) {
        self.fingerPosition = fingerPosition

        movementAngle = atan2(fingerPosition.y - outerNode.position.y, fingerPosition.x - outerNode.position.x)
        rotationAngle = atan2(fingerPosition.x - outerNode.position.x, fingerPosition.y - outerNode.position.y)
        /*
         if (abs(fingerPosition.x - x) > range || abs(fingerPosition.y - y) > range){
             return
         }*/
        // movementAngle = atan2(fingerPosition.y - outerNode.position.y, fingerPosition.x - outerNode.position.x)

        if canMove {
            node.position.x = outerNode.position.x + size * cos(movementAngle)
            node.position.y = outerNode.position.y + size * sin(movementAngle)
        } else {
            node.position.x = outerNode.position.x
            node.position.y = outerNode.position.y
        }
    }
    
    /// Add joystick to scene
    func addToScene() {
        scene.addChild(node)
        scene.addChild(outerNode)
    }

    /// Reset joystick position
    func resetPosition() {
        node.position.x = outerNode.position.x
        node.position.y = outerNode.position.y
    }
        
    //Getters:
    
    func getMovementAngle() -> CGFloat {
        return movementAngle
    }

    func getRotationAngle() -> CGFloat {
        return rotationAngle
    }

    
}
