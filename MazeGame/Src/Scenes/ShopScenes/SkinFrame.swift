//
//  SkinFrame.swift
//  MazeGame
//
//  Created by Richard Plesnik on 28.07.2021.
//  Copyright © 2021 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class representing skin frame in menu
class SkinFrame {
    private var frame: SKShapeNode!
    private var icon: SKSpriteNode!
    private var grayFrame: SKShapeNode
    
    private var scene: MenuScene!

    private var position: CGPoint!

    private var size: CGSize!

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    private var grayColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
    private var coverColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 0.8)

    private var skinId: Int!
    private var locked: Bool!
    private var equiped: Bool!

    
    private var skinName: String!

    var frameWidth = CGFloat(56)
    let iconSize = CGFloat(80)
    var frameHeight = CGFloat(56)
    
    /// Class constructor
    /// - Parameters:
    ///   - scene: menu scene
    ///   - size: frame size
    ///   - position: frame position
    ///   - skinId: skin id
    ///   - locked: ture if skin is locked
    init(scene: MenuScene, size: CGSize!, position: CGPoint, skinId: Int, locked: Bool) {
        self.scene = scene
        self.position = position
        self.size = size
        self.skinId = skinId
        self.locked = locked
        
        self.skinName = "pSkin1" + String(skinId)
        
        frameHeight = CGFloat(iconSize + 2)
        frameWidth = frameHeight
        frame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight))
        frame.lineWidth = 3
        frame.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        frame.strokeColor = orangeColor
        frame.position = CGPoint(x: position.x, y: position.y)
        icon = SKSpriteNode()
        if skinId > 8 {
            icon.texture = SKTexture(imageNamed: "emptyAbility-64")
        } else {
            icon.texture = SKTexture(imageNamed: skinName)
        }

        icon.size = CGSize(width: iconSize, height: iconSize)
        icon.position = CGPoint(x: -frameWidth / 2 + iconSize / 2, y: 0)
        icon.zPosition = 4

        frame.addChild(icon)

        grayFrame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight))
        grayFrame.lineWidth = 3
        grayFrame.fillColor = coverColor
        grayFrame.strokeColor = coverColor
        grayFrame.position = CGPoint(x: 0, y: 0)
        grayFrame.zPosition = 6
        if locked {
            frame.addChild(grayFrame)
        }
    }
    
    /// Add menu childrens to scene
    func addChildrens() {
        scene.addChild(frame)
    }

    /// Calculate menu clicks
    /// - Parameter touch: touch position
    func tick(touch: CGPoint) -> Int {
        let nodesArray = scene.nodes(at: touch)

        let button = nodesArray.first

        if button == frame || button == icon || button == grayFrame {
            //print("Skin id: ", skinId)
            return skinId
        } else {
            return -1
        }
    }
    
    /// Called if frame is unlocked
    func unlocked(){
        grayFrame.removeFromParent()
    }
    
    /// Called if frame is equiped
    func equip(){
        equiped = true
        frame.strokeColor = UIColor.green
    }
    
    /// Called if frame is deequiped
    func deequip(){
        equiped = false
        frame.strokeColor = orangeColor
    }
    
}
