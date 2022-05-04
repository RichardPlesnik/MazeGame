//
//  ShopMenu.swift
//  MazeGame
//
//  Created by Richard Plesnik on 28/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Class representing shop menu
class ShopMenu {
    // old orange UIColor(red: 1, green: 62 / 255, blue: 39 / 255, alpha: 1) // ff6e27//UIColor.black

    private var scene: MenuScene!

    private var titleNode: SKLabelNode!
    private var backButton: SKSpriteNode!
    private var backButtonLabel: SKLabelNode!

    private var upgradesButton: SKSpriteNode!
    private var upgradesButtonLabel: SKLabelNode!
    private var skinsButton: SKSpriteNode!
    private var skinsButtonLabel: SKLabelNode!

    private var bankBackground: SKShapeNode!
    private var coinsLabel: SKLabelNode!
    private var gemLabel: SKLabelNode!

    private var size: CGSize!

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27

    private var profileLoader: ProfileLoader!
    // TODO: replace with enum
    private var shopState = 0
    
    // Shops
    private var upgradesShop: UpgradeShop!
    private var skinsShop: SkinsShop!
    
    /// Class constructor
    /// - Parameters:
    ///   - scene: menu scene
    ///   - profileLoader: profile loader pointer
    init(scene: MenuScene, profileLoader: ProfileLoader) {
        self.scene = scene
        self.profileLoader = profileLoader
        size = scene.size

        titleNode = SKLabelNode(fontNamed: "Arial")
        titleNode.text = "Shop"
        titleNode.fontColor = orangeColor
        titleNode.fontSize = 45
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - titleNode.fontSize - 4)
        titleNode.zPosition = 3

        backButton = SKSpriteNode()
        backButton.name = "backButton"
        backButton.color = orangeColor
        backButton.size = CGSize(width: 130, height: 46)
        backButton.position = CGPoint(x: 65, y: size.height - 23)
        backButton.zPosition = 2
        backButtonLabel = SKLabelNode(fontNamed: "Arial")
        backButtonLabel.name = "backButtonLabel"
        backButtonLabel.text = "< Back"
        backButtonLabel.fontColor = UIColor.black
        backButtonLabel.verticalAlignmentMode = .center
        backButtonLabel.horizontalAlignmentMode = .center
        backButtonLabel.zPosition = 3
        backButton.addChild(backButtonLabel)

        let fontSize = CGFloat(30)
        let squareSize = CGFloat(140)
        let textOffset = CGFloat(6)
        upgradesButton = SKSpriteNode()
        upgradesButton.texture = SKTexture(imageNamed: "AbilitiesButton")
        upgradesButton.size = CGSize(width: squareSize, height: squareSize)
        upgradesButton.position = CGPoint(x: size.width / 2 - squareSize * 0.9, y: size.height / 2)
        upgradesButton.zPosition = 2
        upgradesButtonLabel = SKLabelNode(fontNamed: "Arial")
        upgradesButtonLabel.text = "Abilities"
        upgradesButtonLabel.fontColor = orangeColor
        upgradesButtonLabel.fontSize = fontSize
        upgradesButtonLabel.position = CGPoint(x: upgradesButton.position.x, y: upgradesButton.position.y - squareSize / 2 - fontSize - textOffset)
        upgradesButtonLabel.zPosition = 3

        skinsButton = SKSpriteNode()
        skinsButton.texture = SKTexture(imageNamed: "SkinsButton")
        skinsButton.size = CGSize(width: squareSize, height: squareSize)
        skinsButton.position = CGPoint(x: size.width / 2 + squareSize * 0.9, y: size.height / 2)
        skinsButton.zPosition = 2
        skinsButtonLabel = SKLabelNode(fontNamed: "Arial")
        skinsButtonLabel.text = "Skins"
        skinsButtonLabel.fontColor = orangeColor
        skinsButtonLabel.fontSize = fontSize
        skinsButtonLabel.position = CGPoint(x: skinsButton.position.x, y: skinsButton.position.y - squareSize / 2 - fontSize - textOffset)
        skinsButtonLabel.zPosition = 3

        let coinCount = profileLoader.getCoinCount()
        coinsLabel = SKLabelNode(fontNamed: "Arial")
        coinsLabel.text = "\(coinCount)₵"
        coinsLabel.fontColor = orangeColor
        coinsLabel.fontSize = fontSize
        coinsLabel.position = CGPoint(x: size.width - coinsLabel.frame.width / 2 - 2, y: size.height - fontSize - 2)
        coinsLabel.zPosition = 7
        let gemCount = profileLoader.getGemCount()
        gemLabel = SKLabelNode(fontNamed: "Arial")
        gemLabel.text = "\(gemCount)°"
        gemLabel.fontColor = orangeColor
        gemLabel.fontSize = fontSize
        gemLabel.position = CGPoint(x: size.width - gemLabel.frame.width / 2 - 2, y: size.height - 2 * fontSize - 2)
        gemLabel.zPosition = 7
        let backgroundHeight = 2 * fontSize + 8
        var backgroundWidth = coinsLabel.frame.width
        if gemLabel.frame.width > backgroundWidth {
            backgroundWidth = gemLabel.frame.width
        }
        backgroundWidth += 8
        bankBackground = SKShapeNode(rectOf: CGSize(width: backgroundWidth, height: backgroundHeight))
        bankBackground.lineWidth = 2
        bankBackground.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        bankBackground.strokeColor = orangeColor
        // bankBackground.size = CGSize(width: backgroundWidth, height: 2 * fontSize + 8)
        bankBackground.position = CGPoint(x: size.width - backgroundWidth / 2 - 2, y: size.height - backgroundHeight / 2 - 2)
        bankBackground.zPosition = 6

        // profile data (coins, gems, badges??)

        upgradesShop = UpgradeShop(scene: scene, shopMenu: self, profileLoader: profileLoader)
        skinsShop = SkinsShop(scene: scene, shopMenu: self, profileLoader: profileLoader)
    }

    /// Add menu childrens to scene
    func addChildrens() {
        scene.removeAllChildren()
        if shopState == 0 {
            scene.addChild(titleNode)
            scene.addChild(backButton)

            scene.addChild(upgradesButton)
            scene.addChild(upgradesButtonLabel)
            scene.addChild(skinsButton)
            scene.addChild(skinsButtonLabel)

            addCoinsToScene()

        } else if shopState == 2 {
            upgradesShop.addChildrens()
        } else if shopState == 3 {
            skinsShop.addChildrens()        
        }
    }
    
    /// Add cpins to scene
    func addCoinsToScene(){
        scene.addChild(coinsLabel)
        scene.addChild(gemLabel)
        scene.addChild(bankBackground)
    }
    
    /// Calculate menu clicks
    /// - Parameter touch: touch position
    func tick(touch: CGPoint) {
        let nodesArray = scene.nodes(at: touch)

        let button = nodesArray.first

        if shopState == 0 {
            if button == backButton || button == backButtonLabel {
                scene.changeState(state: 0)
            } else if button == upgradesButton || button == upgradesButtonLabel {
                changeShopState(newState: 2)
            } else if button == skinsButton || button == skinsButtonLabel {
                changeShopState(newState: 3)
            }
        } else if shopState == 2 {
            upgradesShop.tick(touch: touch)
        } else if shopState == 3 {
            skinsShop.tick(touch: touch)
        }
    }

    
    /// Change shop menu scene
    /// - Parameter newState: new menu state
    func changeShopState(newState: Int) {
        shopState = newState
        addChildrens()
    }
    
    /// Update coin count in menu
    func updateCoinCount() {
        let coinCount = profileLoader.getCoinCount()
        coinsLabel.text = "\(coinCount)₵"
        coinsLabel.position = CGPoint(x: size.width - coinsLabel.frame.width / 2 - 2, y: size.height - 30 - 2)
        let gemCount = profileLoader.getGemCount()
        gemLabel.text = "\(gemCount)°"
        gemLabel.position = CGPoint(x: size.width - gemLabel.frame.width / 2 - 2, y: size.height - 2 * 30 - 2)
    }
}
