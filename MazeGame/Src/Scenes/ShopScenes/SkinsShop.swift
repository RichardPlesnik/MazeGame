//
//  SkinsShop.swift
//  MazeGame
//
//  Created by Richard Plesnik on 28/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

// TODO: add chosing skins to player skin

/// Class representing skin shop
class SkinsShop {
    private var scene: MenuScene!

    private var titleNode: SKLabelNode!
    private var backButton: SKSpriteNode!
    private var backButtonLabel: SKLabelNode!

    private var unlocksButton: SKSpriteNode!
    private var unlocksButtonLabel: SKLabelNode!
    private var upgradesButton: SKSpriteNode!
    private var upgradesButtonLabel: SKLabelNode!
    private var skinsButton: SKSpriteNode!
    private var skinsButtonLabel: SKLabelNode!

    private var size: CGSize!

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    private var coverColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 0.5)

    private var profileLoader: ProfileLoader!

    private var shopMenu: ShopMenu!

    private var textureNames = ["coinAbility-64", "magnetAbility-64", "teleportAbility-64", "backAbility-64"]
    private var abilityNames = ["Path Finder", "Magnet", "Teleport", "Mid Travel"]
    private var levels = [2, 0, 1, 1]

    private var skinFrames: [SkinFrame]
    private var skinWindow: SkinWindow
    private var shadowFrame: SKShapeNode!

    private var renderWindow = false

    private var bankBackground: SKShapeNode!
    private var coinsLabel: SKLabelNode!
    private var gemLabel: SKLabelNode!

    /// Class constructor
    /// - Parameters:
    ///   - scene: menu scene
    ///   - shopMenu: shop menu pointer
    ///   - profileLoader: profile loader pointer    
    init(scene: MenuScene, shopMenu: ShopMenu, profileLoader: ProfileLoader) {
        self.scene = scene
        self.shopMenu = shopMenu
        self.profileLoader = profileLoader
        size = scene.size

        titleNode = SKLabelNode(fontNamed: "Arial")
        titleNode.text = "Skins"
        titleNode.fontColor = orangeColor
        titleNode.fontSize = 45
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - titleNode.fontSize - 4)
        titleNode.zPosition = 3

        backButton = SKSpriteNode()
        backButton.color = orangeColor
        backButton.size = CGSize(width: 130, height: 46)
        backButton.position = CGPoint(x: 65, y: size.height - 23)
        backButton.zPosition = 2
        backButtonLabel = SKLabelNode(fontNamed: "Arial")
        backButtonLabel.text = "< Back"
        backButtonLabel.fontColor = UIColor.black
        backButtonLabel.verticalAlignmentMode = .center
        backButtonLabel.horizontalAlignmentMode = .center
        backButtonLabel.zPosition = 3
        backButton.addChild(backButtonLabel)

        let skinsUnlocks = profileLoader.getSkinsUnlocks()
        
        let xOffset = CGFloat(115)
        let yOffsett = CGFloat(95)
        let yMove = CGFloat(-20)
        skinFrames = []
        
        for i in 0...11{
            var yIndex = 0 // row
            if i < 4{
                yIndex = 1
            }
            else if i > 7{
                yIndex = -1
            }
            let xIndex = 1.5 - Double((i % 4))*1.0  // column
            let xPos = size.width / 2 - CGFloat(xIndex)*xOffset;
            let yPos = size.height / 2 + yMove + CGFloat(yIndex)*yOffsett
            
            skinFrames.append(SkinFrame(scene: scene, size: size, position: CGPoint(x: xPos, y: yPos), skinId: i, locked: skinsUnlocks[i]))
        }
                
        shadowFrame = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        shadowFrame.lineWidth = 0
        shadowFrame.fillColor = coverColor
        shadowFrame.strokeColor = coverColor
        shadowFrame.position = CGPoint(x: size.width / 2, y: size.height / 2)
        shadowFrame.zPosition = 6

        skinWindow = SkinWindow(scene: scene, profileLoader: profileLoader, size: size, position: CGPoint(x: size.width / 2, y: size.height / 2 + yMove), skinId: 2, skinsUnlocks: skinsUnlocks)
        skinWindow.setSkinsShop(skinsShop: self)

        highlightEquiped()
        
    }

    /// Add menu childrens to scene
    func addChildrens() {
        scene.removeAllChildren()
        scene.addChild(titleNode)
        scene.addChild(backButton)

        for frm in skinFrames {
            frm.addChildrens()
        }

        if renderWindow {
            scene.addChild(shadowFrame)
            skinWindow.addChildrens()
        }
        shopMenu.addCoinsToScene()
        
    }

    /// Calculate menu clicks
    /// - Parameter touch: touch position
    func tick(touch: CGPoint) {
        let nodesArray = scene.nodes(at: touch)

        let button = nodesArray.first

        if !renderWindow {
            if button == backButton || button == backButtonLabel {
                shopMenu.changeShopState(newState: 0)
            }

            var output = -1
            for frm in skinFrames {
                output = frm.tick(touch: touch)
                if output != -1 {
                    break
                }
            }
            if output > -1 {
                // show window
                print("Choosen index: ", output)
                renderWindow = true
                skinWindow.changeId(id: output)
                addChildrens()
            }
        } else {
            let upgradeOutput = skinWindow.tick(touch: touch)
            if button == shadowFrame {
                disappearWindow()
            }
            if upgradeOutput > -1 {
                unlockSkin(skinId: skinWindow.getId())
            }
            else if upgradeOutput == -2{
                highlightEquiped()
            }
        }
    }

    /// Dissapear window
    func disappearWindow() {
        renderWindow = false
        addChildrens()
    }
    
    /// Highlight equiped skin
    func highlightEquiped(){
        let equipedId = profileLoader.getEquipedSkin()
        for i in 0...11{
            if i == equipedId{
                skinFrames[i].equip()
            }
            else{
                skinFrames[i].deequip()
            }
        }
    }
    
    
    /// Unlock skin
    /// - Parameter skinId: skin if
    func unlockSkin(skinId: Int) {
        var unlocks = profileLoader.getSkinsUnlocks()
        
        if unlocks[skinId] {
            unlocks[skinId] = false
            profileLoader.changeSkinsUnlocks(unlocks: unlocks)
            profileLoader.saveData()
            skinWindow.changeUnlocks(unlocks: unlocks)
            skinWindow.changeId(id: skinId)
            skinFrames[skinId].unlocked()
            shopMenu.updateCoinCount()
        }
    }
    
}
