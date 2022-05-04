//
//  UpgradeWindow.swift
//  MazeGame
//
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Class representing upgrade window (after clicking on ability to upgrade)
class UpgradeWindow {
    private var frame: SKShapeNode!
    private var icon: SKSpriteNode!

    private var nameLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var levelLabel2: SKLabelNode
    private var cooldownLabel: SKLabelNode!
    private var cooldownLabel2: SKLabelNode!
    private var descriptionText: SKLabelNode!
    private var descriptionFrame: SKShapeNode!

    private var upgradeButton: SKSpriteNode!
    private var upgradeButtonLabel: SKLabelNode!
    private var crossButton: SKSpriteNode

    private var scene: MenuScene!
    private var upgradeShop: UpgradeShop?

    private var position: CGPoint!

    private var size: CGSize!

    private var orangeColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1)
    private var grayColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1)
    private var emptyColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    private var greenColor = UIColor(red: 0 / 255, green: 204 / 255, blue: 0 / 255, alpha: 1)
    private var unactiveButtonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 0.5)
    private var unactiveBlack = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5)

    private var abilityId: Int!

    private var abilityLevels: [Int]

    let frameWidth = CGFloat(250)
    let iconSize = CGFloat(50)
    let frameHeight = CGFloat(260)
    var fontSize = CGFloat(27)
    let textOffset = CGFloat(6)
    var yPos = CGFloat(0)
    let descriptionOffset = CGFloat(30)

    private var profileLoader: ProfileLoader!
    private var upgradeCost = 0

    
    /// Class constructor
    /// - Parameters:
    ///   - scene: menu scene
    ///   - profileLoader: profile loader pointer
    ///   - size: window size
    ///   - position: window position
    ///   - abilityId: ability id
    ///   - abilityLevels: ability levels
    init(scene: MenuScene, profileLoader: ProfileLoader, size: CGSize!, position: CGPoint, abilityId: Int, abilityLevels: [Int]) {
        self.scene = scene
        self.profileLoader = profileLoader
        self.position = position
        self.size = size
        self.abilityId = abilityId
        self.abilityLevels = abilityLevels

        frame = SKShapeNode(rectOf: CGSize(width: frameWidth, height: frameHeight))
        frame.lineWidth = 3
        frame.fillColor = grayColor
        frame.strokeColor = orangeColor
        frame.position = CGPoint(x: position.x, y: position.y)
        frame.zPosition = 7

        icon = SKSpriteNode()
        icon.texture = SKTexture(imageNamed: ABILITY_TEXTURES_NAMES[abilityId])
        icon.size = CGSize(width: iconSize, height: iconSize)
        icon.position = CGPoint(x: -frameWidth / 2 + iconSize / 2 + 1, y: +frameHeight / 2 - iconSize / 2 - 1)
        icon.zPosition = 8

        nameLabel = SKLabelNode(fontNamed: "Arial")
        nameLabel.text = "\(ABILITY_NAMES[abilityId])"
        nameLabel.fontColor = orangeColor
        nameLabel.fontSize = fontSize
        nameLabel.position = CGPoint(x: icon.position.x + iconSize / 2 + nameLabel.frame.width / 2 + textOffset, y: icon.position.y - fontSize / 2)
        nameLabel.zPosition = 8
        yPos = icon.position.y - iconSize / 2 - fontSize / 2
        fontSize = CGFloat(21)

        levelLabel = SKLabelNode(fontNamed: "Arial")
        levelLabel.text = "Level: \(abilityLevels[abilityId])"
        levelLabel.fontColor = orangeColor
        levelLabel.fontSize = fontSize
        levelLabel.position = CGPoint(x: -frameWidth / 2 + levelLabel.frame.width / 2 + textOffset, y: yPos - 15)
        levelLabel.zPosition = 8
        levelLabel2 = SKLabelNode(fontNamed: "Arial")
        levelLabel2.text = "→ \(abilityLevels[abilityId] + 1)"
        levelLabel2.fontColor = greenColor
        levelLabel2.fontSize = fontSize
        levelLabel2.zPosition = 8

        cooldownLabel = SKLabelNode(fontNamed: "Arial")
        cooldownLabel.text = "Cooldown: \(ABILITY_COOLDOWNS[abilityId][abilityLevels[abilityId] - 1])s"
        cooldownLabel.fontColor = orangeColor
        cooldownLabel.fontSize = fontSize
        cooldownLabel.zPosition = 8
        cooldownLabel2 = SKLabelNode(fontNamed: "Arial")
        cooldownLabel2.text = "→ \(ABILITY_COOLDOWNS[abilityId][abilityLevels[abilityId]])s"
        cooldownLabel2.fontColor = greenColor
        cooldownLabel2.fontSize = fontSize
        cooldownLabel2.zPosition = 8

        descriptionText = SKLabelNode(fontNamed: "Arial")
        descriptionText.text = ABILITY_DESCRIPTIONS[abilityId]
        descriptionText.fontColor = orangeColor
        descriptionText.fontSize = 20
        descriptionText.zPosition = 8
        descriptionText.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionText.numberOfLines = 8
        descriptionText.preferredMaxLayoutWidth = frameWidth - descriptionOffset

        frame.addChild(icon)
        frame.addChild(nameLabel)
        frame.addChild(levelLabel)
        frame.addChild(cooldownLabel)
        frame.addChild(levelLabel2)
        frame.addChild(cooldownLabel2)
        frame.addChild(descriptionText)

        upgradeButton = SKSpriteNode()
        upgradeButton.color = orangeColor
        upgradeButton.size = CGSize(width: 134, height: 35)
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

        descriptionFrame = SKShapeNode(rectOf: CGSize(width: descriptionText.frame.width + 8, height: descriptionText.frame.height + 8))
        descriptionFrame.lineWidth = 3
        descriptionFrame.fillColor = emptyColor
        descriptionFrame.strokeColor = orangeColor
        descriptionFrame.position = CGPoint(x: 0, y: descriptionText.position.y + descriptionText.frame.height)
        descriptionFrame.zPosition = 7
        frame.addChild(descriptionFrame)
    }

    /// Add menu childrens to scene
    func addChildrens() {
        scene.addChild(frame)
    }
    
    /// Calculate menu clicks
    /// - Parameter touch: touch position
    /// - Returns: ability ID or -1
    func tick(touch: CGPoint) -> Int {
        let nodesArray = scene.nodes(at: touch)

        let button = nodesArray.first

        if button == upgradeButton || button == upgradeButtonLabel {
            print("upgrade clicked")
            if checkBank() {
                if upgradeCost > 0 {
                    profileLoader.changeCoinCount(coinCount: profileLoader.getCoinCount() - upgradeCost)
                } else {
                    profileLoader.changeGemCount(gemCount: profileLoader.getGemCount() + upgradeCost)
                }
                profileLoader.saveData()

                return abilityId
            }
        } else if button == crossButton {
            print("cross clicked")
            upgradeShop!.disappearWindow()
        } else {
            print("frame clicked")
        }
        return -1
    }

    
    /// Update ability upgrade text
    func updateText() {
        icon.texture = SKTexture(imageNamed: ABILITY_TEXTURES_NAMES[abilityId])
        nameLabel.text = "\(ABILITY_NAMES[abilityId])"
        nameLabel.position = CGPoint(x: icon.position.x + iconSize / 2 + nameLabel.frame.width / 2 + textOffset, y: icon.position.y - fontSize / 2)
        levelLabel.text = "Level: \(abilityLevels[abilityId])"
        levelLabel.position = CGPoint(x: -frameWidth / 2 + levelLabel.frame.width / 2 + textOffset, y: yPos - 11)
        cooldownLabel.text = "Cooldown: \(ABILITY_COOLDOWNS[abilityId][abilityLevels[abilityId]])s"
        cooldownLabel.position = CGPoint(x: -frameWidth / 2 + cooldownLabel.frame.width / 2 + textOffset, y: levelLabel.position.y - 25)

        setUpgradeCost()

        if upgradeCost == 0 {
            upgradeButtonLabel.text = "Max level"
        } else if upgradeCost > 0 {
            upgradeButtonLabel.text = "Upgrade" + "(\(upgradeCost)₵)"
        } else {
            upgradeButtonLabel.text = "Upgrade" + "(\(-upgradeCost)°)"
        }

        if abilityLevels[abilityId] == 0 {
            upgradeButtonLabel.text = "Unlock " + "(\(upgradeCost)₵)"
        }
        if abilityLevels[abilityId] != 5 {
            levelLabel2.text = "→ \(abilityLevels[abilityId] + 1)"
            levelLabel2.position = CGPoint(x: levelLabel.position.x + levelLabel.frame.width / 2 + levelLabel2.frame.width / 2 + 5, y: yPos - 11)
            cooldownLabel2.text = "→ \(ABILITY_COOLDOWNS[abilityId][abilityLevels[abilityId] + 1])s"
            cooldownLabel2.position = CGPoint(x: cooldownLabel.position.x + cooldownLabel.frame.width / 2 + cooldownLabel2.frame.width / 2 + 5, y: levelLabel.position.y - 25)
            upgradeButton.color = orangeColor
            upgradeButtonLabel.color = UIColor.black
        } else {
            levelLabel2.text = ""
            cooldownLabel2.text = ""
            upgradeButton.color = unactiveButtonColor
            upgradeButtonLabel.color = unactiveBlack
        }
        if !checkBank() {
            levelLabel2.text = ""
            cooldownLabel2.text = ""
            upgradeButton.color = unactiveButtonColor
            upgradeButtonLabel.color = unactiveBlack
        }

        descriptionText.text = ABILITY_DESCRIPTIONS[abilityId]
        let descriptionTextX: CGFloat  = CGFloat(-frameWidth / 2) + CGFloat(descriptionText.frame.width / 2) + CGFloat(descriptionOffset / 2)
        let descriptionTextY: CGFloat  = cooldownLabel.position.y - descriptionText.frame.size.height - 14
        descriptionText.position = CGPoint(x: descriptionTextX, y: descriptionTextY)
        upgradeButton.position = CGPoint(x: 0, y: -frameHeight / 2 + 25) // CGPoint(x: frameWidth / 2, y: -frameHeight + 50)

        descriptionFrame.removeFromParent()
        descriptionFrame = SKShapeNode(rectOf: CGSize(width: frameWidth - 20, height: 100))
        descriptionFrame.lineWidth = 3
        descriptionFrame.fillColor = emptyColor
        descriptionFrame.strokeColor = orangeColor
        descriptionFrame.position = CGPoint(x: 0, y: cooldownLabel.position.y - 50 - 11)
        descriptionFrame.zPosition = 7
        frame.addChild(descriptionFrame)
    }

    
    /// Change ability to upgrade
    /// - Parameter id: ability id
    func changeId(id: Int) {
        abilityId = id
        updateText()
    }

    
    /// Change abiity levels
    /// - Parameter levels: ability levels
    func changeLevels(levels: [Int]) {
        abilityLevels = levels
    }

    
    /// Set upgrade shop pointer
    /// - Parameter upgradeShop: upgrade shop pointer
    func setUpgradeShop(upgradeShop: UpgradeShop) {
        self.upgradeShop = upgradeShop
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

    //Getters setters:
    
    func getId() -> Int {
        return abilityId
    }

    func setUpgradeCost() {
        upgradeCost = UPGRADE_COSTS[abilityLevels[abilityId]]
    }
    
}
