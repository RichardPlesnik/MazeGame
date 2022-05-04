//
//  MenuScene.swift
//  MazeGame
//
//  Created by Richard Plesnik on 06/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import GameplayKit
import SpriteKit

import SceneKit

/// Class representing menu scene
class MenuScene: SKScene {
    var launchMenu: LaunchMenu!
    var selectionMenu: SelectionMenu!

    var equipmentMenu: EquipmentMenu!

    var shopMenu: ShopMenu!

    private var fingerPosition = CGPoint()
    // TODO: replace with enum
    private var state = 0 // 0 launch menu, 1 selection menu, 2 equipmentMenu, 3 shop menu

    override func didMove(to view: SKView) {
        let profileLoader = ProfileLoader()

        launchMenu = LaunchMenu(scene: self)
        selectionMenu = SelectionMenu(scene: self)

        equipmentMenu = EquipmentMenu(scene: self, profileLoader: profileLoader)

        shopMenu = ShopMenu(scene: self, profileLoader: profileLoader)

        addChildrens()
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
        tick()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    
    /// Calculate menu clicks
    func tick() {
        if state == 0 {
            launchMenu.tick(touch: fingerPosition)
        } else if state == 1 {
            selectionMenu.tick(touch: fingerPosition)
        } else if state == 2 {
            equipmentMenu.tick(touch: fingerPosition)
        } else if state == 3 {
            shopMenu.tick(touch: fingerPosition)
        }
    }

    
    /// Add menu childrens to scene
    func addChildrens() {
        if state == 0 {
            launchMenu.addChildrens()
        } else if state == 1 {
            selectionMenu.addChildrens()
        } else if state == 2 {
            equipmentMenu.addChildrens()
        } else if state == 3 {
            shopMenu.addChildrens()
        }
    }

    
    /// Change menu state
    /// - Parameter state: new menu state
    func changeState(state: Int) {
        removeAllChildren()
        self.state = state
        addChildrens()
    }

    /// Set menu state
    func setState(state: Int) {
        self.state = state
    }
}
