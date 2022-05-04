//
//  SkinWindow.swift
//  MazeGame
//
//  Created by Richard Plesnik on 28.07.2021.
//  Copyright © 2021 Richard Plesnik. All rights reserved.
//

import SpriteKit

// TODO: add saving data to profile

/// Class representing unlock skin window
class SkinWindow {
    private var frame: SKShapeNode!
    private var icon: SKSpriteNode!

    private var nameLabel: SKLabelNode!

    private var upgradeButton: SKSpriteNode!
    private var upgradeButtonLabel: SKLabelNode!
    private var crossButton: SKSpriteNode

    private var scene: MenuScene!
    private var skinsShop: SkinsShop?

    private var position: CGPoint!

    private var size: CGSize!

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1)
    private var grayColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
    private var emptyColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    private var greenColor = UIColor(red: 0 / 255, green: 204 / 255, blue: 0 / 255, alpha: 1)
    private var unactiveButtonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 0.5)
    private var unactiveBlack = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5)

    private var skinId: Int!
    private var skinName: String!

    private var skinsUnlocks: [Bool]

    let frameWidth = CGFloat(250)
    let iconSize = CGFloat(156)
    let frameHeight = CGFloat(260)
    var fontSize = CGFloat(27)
    let textOffset = CGFloat(6)
    var yPos = CGFloat(0)
    let descriptionOffset = CGFloat(30)

    private var profileLoader: ProfileLoader!
    private var upgradeCost = 0
    
    private var eqipedId = 0

    /// Class constructor
    /// - Parameters:
    ///   - scene: menu scene
    ///   - profileLoader: profile loader pointer
    ///   - size: window size
    ///   - position: window position
    ///   - skinId: skin id
    ///   - skinsUnlocks: skin unlocks data
    init(scene: MenuScene, profileLoader: ProfileLoader, size: CGSize!, position: CGPoint, skinId: Int, skinsUnlocks: [Bool]) {
        self.scene = scene
        self.profileLoader = profileLoader
        self.position = position
        self.size = size
        self.skinId = skinId
        self.skinsUnlocks = skinsUnlocks
        self.skinName = "pSkin1" + String(skinId)
        
        frame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight))
        frame.lineWidth = 3
        frame.fillColor = grayColor
        frame.strokeColor = orangeColor
        frame.position = CGPoint(x: position.x, y: position.y)
        frame.zPosition = 7

        icon = SKSpriteNode()
        icon.texture = SKTexture(imageNamed: String(skinName))
        icon.size = CGSize(width: iconSize, height: iconSize)
        icon.position = CGPoint(x: 0, y: +10)
        icon.zPosition = 8

        nameLabel = SKLabelNode(fontNamed: "Arial")
        nameLabel.text = "\(String(skinName))" //pozdeji vytvorit pole s nazvy skinu
        nameLabel.fontColor = orangeColor
        nameLabel.fontSize = fontSize
        nameLabel.position = CGPoint(x: icon.position.x + iconSize / 2 + nameLabel.frame.width / 2 + textOffset, y: icon.position.y - fontSize / 2 - iconSize/2)
        nameLabel.zPosition = 8
        yPos = icon.position.y - iconSize / 2 - fontSize / 2
        fontSize = CGFloat(21)

        frame.addChild(icon)
        frame.addChild(nameLabel)
        
        upgradeButton = SKSpriteNode()
        upgradeButton.color = orangeColor
        upgradeButton.size = CGSize(width: 128, height: 35)
        upgradeButton.zPosition = 8
        upgradeButtonLabel = SKLabelNode(fontNamed: "Arial")
        upgradeButtonLabel.text = "Upgrade" + "(100₵)"
        upgradeButtonLabel.fontColor = UIColor.black
        upgradeButtonLabel.fontSize = 18
        upgradeButtonLabel.verticalAlignmentMode = .center
        upgradeButtonLabel.horizontalAlignmentMode = .center
        upgradeButtonLabel.zPosition = 3
        upgradeButton.addChild(upgradeButtonLabel)
        frame.addChild(upgradeButton)

        crossButton = SKSpriteNode()
        crossButton.texture = SKTexture(imageNamed: "cross32")
        crossButton.size = CGSize(width: 19, height: 19)
        crossButton.zPosition = 9
        crossButton.position = CGPoint(x: -frameWidth / 2, y: frameHeight / 2)
        frame.addChild(crossButton)

        loadEquipedId()
    }

    /// Add menu childrens to scene
    func addChildrens() {
        scene.addChild(frame)
    }
    
    /// Calculate menu clicks
    /// - Parameter touch: touch position
    /// - Returns: skin ID or -1
    func tick(touch: CGPoint) -> Int {
        let nodesArray = scene.nodes(at: touch)

        let button = nodesArray.first

        if button == upgradeButton || button == upgradeButtonLabel {
            print("unlock clicked")
            if checkBank() {
                
                if !skinsUnlocks[skinId]{
                    print("bought -> equip")
                    eqipedId = skinId
                    profileLoader.changeEquipedSkin(equipedSkin: skinId)
                    updateText()
                    return -2
                }
                
                if upgradeCost > 0 {
                    profileLoader.changeCoinCount(coinCount: profileLoader.getCoinCount() - upgradeCost)
                } else {
                    profileLoader.changeGemCount(gemCount: profileLoader.getGemCount() + upgradeCost)
                }
                profileLoader.saveData()

                return skinId
            }

        } else if button == crossButton {
            print("cross clicked")
            skinsShop!.disappearWindow()
        } else {
            print("frame clicked")
        }
        return -1
    }

    /// Update frame text
    func updateText() {
        skinName = "pSkin1" + String(skinId)
        icon.texture = SKTexture(imageNamed: skinName)
        nameLabel.text = "\(String(skinName))" // pozdeji pridat pole s nazvy skinu
        nameLabel.position = CGPoint(x: 0, y: icon.position.y + fontSize / 2 + iconSize/2)
        
        
        loadEquipedId()
        setUpgradeCost()

        if skinsUnlocks[skinId]{
            upgradeButtonLabel.text = "Buy" + "(\(upgradeCost)₵)"
        }
        else{
            if skinId == eqipedId{
                upgradeButtonLabel.text = "Equiped"
            }
            else{
                upgradeButton.color = orangeColor
                upgradeButtonLabel.color = UIColor.black
                upgradeButtonLabel.text = "Equip"
            }
            
        }
        if !checkBank() {
            upgradeButton.color = unactiveButtonColor
            upgradeButtonLabel.color = unactiveBlack
        }
        
        upgradeButton.position = CGPoint(x: 0, y: -frameHeight / 2 + 25) // CGPoint(x: frameWidth / 2, y: -frameHeight + 50)
    }

    
    /// Change skin in
    /// - Parameter id: skin id
    func changeId(id: Int) {
        skinId = id
        updateText()
    }

    
    /// Change skin unlocks
    /// - Parameter unlocks: skin unlocks
    func changeUnlocks(unlocks: [Bool]) {
        skinsUnlocks = unlocks
    }

    /// Check coins before updgrading
    /// - Returns: true if enough money
    func checkBank() -> Bool {
        if upgradeCost > 0 {
            if upgradeCost > profileLoader.getCoinCount() {
                return false
            }
        } else {
            if -upgradeCost > profileLoader.getGemCount() {
                return false
            }
        }
        return true
    }
        
    /// Load equiped skin from progile data
    func loadEquipedId(){
        eqipedId = profileLoader.getEquipedSkin()
    }
    
    // Getters and setters:
    
    func setSkinsShop(skinsShop: SkinsShop) {
        self.skinsShop = skinsShop
    }

    func getId() -> Int {
        return skinId
    }

    func setUpgradeCost() {
        if !skinsUnlocks[skinId]{
            upgradeCost = 0
        }
        else{
            upgradeCost = SKINS_COSTS[skinId]
        }
    }
    
}
