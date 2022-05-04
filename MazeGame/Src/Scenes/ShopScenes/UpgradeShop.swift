//
//  UpgradeShop.swift
//  Maze Game
//
//  Created by Richard Plesnik on 28/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class representing upgrade shop
class UpgradeShop {
    // old orange UIColor(red: 1, green: 62 / 255, blue: 39 / 255, alpha: 1) // ff6e27//UIColor.black

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

    private var upgradeFrames: [UpgradeFrame]
    private var upgradeWindow: UpgradeWindow
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
        titleNode.text = "Unlocks"
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

        let abilityLevels = profileLoader.getUnclocks()
        let xOffset = CGFloat(168)
        let yOffsett = CGFloat(70)
        let yMove = CGFloat(-10)
        upgradeFrames = []
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2 - xOffset, y: size.height / 2 + yMove + yOffsett), abilityId: 0, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2, y: size.height / 2 + yMove + yOffsett), abilityId: 1, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2 + xOffset, y: size.height / 2 + yMove + yOffsett), abilityId: 2, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2 - xOffset, y: size.height / 2 + yMove), abilityId: 3, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2, y: size.height / 2 + yMove), abilityId: -1, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2 + xOffset, y: size.height / 2 + yMove), abilityId: -1, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2 - xOffset, y: size.height / 2 + yMove - yOffsett), abilityId: -1, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2, y: size.height / 2 + yMove - yOffsett), abilityId: -1, abilityLevels: abilityLevels))
        upgradeFrames.append(UpgradeFrame(scene: scene, size: size, position: CGPoint(x: size.width / 2 + xOffset, y: size.height / 2 + yMove - yOffsett), abilityId: -1, abilityLevels: abilityLevels))

        shadowFrame = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        shadowFrame.lineWidth = 0
        shadowFrame.fillColor = coverColor
        shadowFrame.strokeColor = coverColor
        shadowFrame.position = CGPoint(x: size.width / 2, y: size.height / 2)
        shadowFrame.zPosition = 6

        upgradeWindow = UpgradeWindow(scene: scene, profileLoader: profileLoader, size: size, position: CGPoint(x: size.width / 2, y: size.height / 2 + yMove), abilityId: 2, abilityLevels: abilityLevels)
        upgradeWindow.setUpgradeShop(upgradeShop: self)
        
    }

    /// Add menu childrens to scene
    func addChildrens() {
        scene.removeAllChildren()
        scene.addChild(titleNode)
        scene.addChild(backButton)

        for frm in upgradeFrames {
            frm.addChildrens()
        }

        if renderWindow {
            scene.addChild(shadowFrame)
            upgradeWindow.addChildrens()
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
            for frm in upgradeFrames {
                output = frm.tick(touch: touch)
                if output != -1 {
                    break
                }
            }
            if output != -1 {
                print("Choosen index: ", output)
                renderWindow = true
                upgradeWindow.changeId(id: output)
                addChildrens()
            }
        } else {
            let upgradeOutput = upgradeWindow.tick(touch: touch)
            if button == shadowFrame {
                disappearWindow()
            }
            if upgradeOutput != -1 {
                upgradeAbility(abilityId: upgradeWindow.getId())
            }
        }
    }

    
    /// Dissapear window
    func disappearWindow() {
        renderWindow = false
        addChildrens()
    }

    
    /// Upgrade ability
    /// - Parameter abilityId: ability id
    func upgradeAbility(abilityId: Int) {
        var abilities = profileLoader.getUnclocks()
        if abilities[abilityId] != 5 {
            abilities[abilityId] += 1
            profileLoader.changeUnlocks(abilities: abilities)
            profileLoader.saveData()
            upgradeWindow.changeLevels(levels: abilities)
            upgradeWindow.changeId(id: abilityId)
            upgradeFrames[abilityId].updateLevels(abilityLevels: abilities)
            shopMenu.updateCoinCount()
        }
    }
    
}
