//
//  notification.swift
//  MazeGame
//
//  Created by Richard Plesnik on 25/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class for creating notifications
class Notification {
    var labelFrame: SKShapeNode!
    var label: SKLabelNode!

    var scene: SKScene!

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 0.8) // ff6e27
    private var blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8) // ff6e27

    private var visible = false

    init(scene: SKScene, screenWidth: CGFloat, screenHeight: CGFloat) {
        self.scene = scene
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight

        labelFrame = SKShapeNode(rectOf: CGSize(width: 350, height: 200))
        labelFrame.lineWidth = 3
        labelFrame.fillColor = blackColor
        labelFrame.strokeColor = orangeColor
        labelFrame.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        labelFrame.zPosition = 7

        label = SKLabelNode(fontNamed: "Arial") // Courier Oblique 68   w.0
        label.fontColor = orangeColor
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 8
        labelFrame.addChild(label)
    }
    
    /// Add notification to scene
    func addToScene() {
        if visible {
            labelFrame.removeFromParent()
            scene.addChild(labelFrame)
        }
    }
    
    /// Show notification
    /// - Parameters:
    ///   - text: notification text
    ///   - time: notification duration
    func showNotification(text: String, time: Int) {
        if visible {
            labelFrame.removeFromParent()
        }
        label.text = text
        initFrame()
        label.position = CGPoint(x: 0, y: -label.fontSize / 2)
        scene.addChild(labelFrame)
        visible = true
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(time)) {
            self.visible = false
            self.labelFrame.removeFromParent()
        }
    }
    
    /// Initalize notification frame
    func initFrame() {
        label.removeFromParent()
        labelFrame = SKShapeNode(rectOf: CGSize(width: label.frame.width + 30, height: label.fontSize + 30))
        labelFrame.lineWidth = 3
        labelFrame.fillColor = blackColor
        labelFrame.strokeColor = orangeColor
        labelFrame.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 + 70)
        labelFrame.zPosition = 7
        labelFrame.addChild(label)
    }
}
