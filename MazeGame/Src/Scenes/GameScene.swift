//
//  GameScene.swift
//  MazeGame
//
//  Created by Richard Plesnik on 03/02/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import GameplayKit
import SpriteKit

import SceneKit

/// Class representing game scene
class GameScene: SKScene {
    private var level: Level!

    private var player: Player!
    private var joystick: Joystick!

    private var fingerPosition = CGPoint()
    var canMove = Bool(false)

    private var screenSize: CGRect = UIScreen.main.bounds
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!

    private var tileMap: TileMap!
    private var screen: Screen!

    private var movementAngle: CGFloat = 0
    private var rotationAngle: CGFloat = 0

    private var lastUpdateTime: CFTimeInterval = 0

    private var running: Bool!

    var mapName: String = "Map001.json" // DEFAULT VALUE
    var mapIndex = 0 // DEFAULT VALUE

    override func didMove(to view: SKView) {
        level = Level(scene: self, mapIndex: mapIndex, mapName: mapName)
        running = true
    }

    // Touch operations functions:
    
    func touchDown(atPoint pos: CGPoint) {
    }
    
    func touchMoved(toPoint pos: CGPoint) {
    }

    func touchUp(atPoint pos: CGPoint) {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            fingerPosition = t.location(in: self)
        }
        canMove = true
        level.clickTick(fingerPosition: fingerPosition)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.first
        fingerPosition = t?.location(in: self) ?? CGPoint(x: 0, y: 0)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false
    }

    override func update(_ currentTime: TimeInterval) {
        var deltaTime = currentTime - lastUpdateTime
        if deltaTime > 1 {
            deltaTime = 1 / 30
        }
        lastUpdateTime = currentTime

        if running {
            level.tick(deltaTime: deltaTime, fingerPosition: fingerPosition, canMove: canMove)
        }
    }
    
    /// Pause game scene
    func pause() {
        running = false
    }
    
    /// Unpause game scene
    func play() {
        running = true
    }
    
    /// Reset move
    func resetMove(){
        canMove = false
    }
}
