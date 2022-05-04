//
//  LaunchMenu.swift
//  MazeGame
//
//  Created by Richard Plesnik on 12/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class representing selection menu
class SelectionMenu {
    // old orange UIColor(red: 1, green: 62 / 255, blue: 39 / 255, alpha: 1) // ff6e27//UIColor.black

    private var scene: MenuScene!

    var titleNode: SKLabelNode!

    var playButtonNode: SKSpriteNode!
    var playButtonLabel: SKLabelNode!

    var backButton: SKSpriteNode!
    var backButtonLabel: SKLabelNode!

    var leftArrow: SKSpriteNode!
    var leftArrowLabel: SKLabelNode!
    var rightArrow: SKSpriteNode!
    var rightArrowLabel: SKLabelNode!

    var statusLabel1: SKLabelNode!
    var statusLabel2: SKLabelNode!
    var sizeLabel: SKLabelNode!
    var coinsLabel: SKLabelNode!
    var actualTime1: SKLabelNode!
    var bestTime: SKLabelNode!

    // ability prompt
    var descriptionText: SKLabelNode!
    var cancelButton: SKSpriteNode!
    var cancelButtonLabel: SKLabelNode!
    var resetButton: SKSpriteNode!
    var resetButtonLabel: SKLabelNode!
    var continueButton: SKSpriteNode!
    var continueButtonLabel: SKLabelNode!
    var backgroundNode: SKSpriteNode!

    private var askAbility = false
    private var canStart = true
    // var bestTimeLabel: SKLabelNode! // pokud ne played -> "No time"
    // var actualTimeLabel: SKLabelNode!

    var mapFrame: SKShapeNode!

    private var buttonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    private var unactiveButtonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 0.5) // UIColor(red: 215 / 255, green: 70 / 255, blue: 0 / 255, alpha: 1) // ff6e27
    private var unactiveBlack = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5)

    private var size: CGSize!

    private var mapFileLoader: MapFileLoader!

    private var mapData: [MapData]
    private var mapIndex = 0

    
    /// Class constructor
    /// - Parameter scene: menu scene
    init(scene: MenuScene) {
        self.scene = scene
        size = scene.size

        mapFileLoader = MapFileLoader()
        mapData = []
        mapData = mapFileLoader.getMaps()

        titleNode = SKLabelNode(fontNamed: "Arial")
        titleNode.text = mapData[mapIndex].name
        titleNode.fontColor = buttonColor
        titleNode.fontSize = 45
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - titleNode.fontSize - 20)
        titleNode.zPosition = 3

        playButtonNode = SKSpriteNode()
        playButtonNode = SKSpriteNode()
        playButtonNode.name = "playButton"
        playButtonNode.color = buttonColor
        playButtonNode.size = CGSize(width: 250, height: 55)
        playButtonNode.position = CGPoint(x: size.width / 2, y: 40 + 2)
        playButtonNode.zPosition = 2
        playButtonLabel = SKLabelNode()
        playButtonLabel = SKLabelNode(fontNamed: "Arial")
        playButtonLabel.name = "playButtonLabel"
        playButtonLabel.text = "Start level"
        playButtonLabel.fontColor = UIColor.black
        playButtonLabel.verticalAlignmentMode = .center
        playButtonLabel.horizontalAlignmentMode = .center
        playButtonLabel.zPosition = 3
        playButtonNode.addChild(playButtonLabel)

        backButton = SKSpriteNode()
        backButton = SKSpriteNode()
        backButton.name = "backButton"
        backButton.color = buttonColor
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

        mapFrame = SKShapeNode(rectOf: CGSize(width: 350, height: 200))
        mapFrame.lineWidth = 3
        mapFrame.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        mapFrame.strokeColor = buttonColor
        mapFrame.position = CGPoint(x: size.width / 2, y: size.height / 2)
        mapFrame.zPosition = 4

        leftArrow = SKSpriteNode()
        leftArrow = SKSpriteNode()
        leftArrow.name = "leftArrow"
        leftArrow.color = buttonColor
        leftArrow.size = CGSize(width: 50, height: 50)
        leftArrow.position = CGPoint(x: mapFrame.position.x - mapFrame.frame.width / 2 - 15 - 20, y: size.height / 2)
        leftArrow.zPosition = 2
        leftArrowLabel = SKLabelNode(fontNamed: "Arial")
        leftArrowLabel.name = "leftArrowLabel"
        leftArrowLabel.text = "<"
        leftArrowLabel.fontColor = UIColor.black
        leftArrowLabel.verticalAlignmentMode = .center
        leftArrowLabel.horizontalAlignmentMode = .center
        leftArrowLabel.zPosition = 3
        leftArrow.addChild(leftArrowLabel)

        rightArrow = SKSpriteNode()
        rightArrow = SKSpriteNode()
        rightArrow.name = "rightArrow"
        rightArrow.color = buttonColor
        rightArrow.size = CGSize(width: 50, height: 50)
        rightArrow.position = CGPoint(x: mapFrame.position.x + mapFrame.frame.width / 2 + 15 + 20, y: size.height / 2)
        rightArrow.zPosition = 2
        rightArrowLabel = SKLabelNode(fontNamed: "Arial")
        rightArrowLabel.name = "rightArrowLabel"
        rightArrowLabel.text = ">"
        rightArrowLabel.fontColor = UIColor.black
        rightArrowLabel.verticalAlignmentMode = .center
        rightArrowLabel.horizontalAlignmentMode = .center
        rightArrowLabel.zPosition = 3
        rightArrow.addChild(rightArrowLabel)

        statusLabel1 = SKLabelNode(fontNamed: "Arial")
        statusLabel1.text = "Status: "
        statusLabel1.fontColor = buttonColor
        statusLabel1.zPosition = 3

        statusLabel2 = SKLabelNode(fontNamed: "Arial")
        statusLabel2.fontColor = buttonColor
        statusLabel2.zPosition = 2

        sizeLabel = SKLabelNode(fontNamed: "Arial")
        sizeLabel.fontColor = buttonColor
        sizeLabel.zPosition = 3

        coinsLabel = SKLabelNode(fontNamed: "Arial")
        coinsLabel.fontColor = buttonColor
        coinsLabel.zPosition = 3

        actualTime1 = SKLabelNode(fontNamed: "Arial")
        actualTime1.fontColor = buttonColor
        actualTime1.zPosition = 3

        bestTime = SKLabelNode(fontNamed: "Arial")
        bestTime.fontColor = buttonColor
        bestTime.zPosition = 3

        mapFrame.addChild(statusLabel1)
        mapFrame.addChild(sizeLabel)
        mapFrame.addChild(coinsLabel)
        statusLabel1.addChild(statusLabel2)
        mapFrame.addChild(actualTime1)
        mapFrame.addChild(bestTime)

        // Ability prompt:
        let descriptionOffset = CGFloat(8)
        descriptionText = SKLabelNode(fontNamed: "Arial")
        descriptionText.text = "Level was already started with different abilities. Continue with old abilities or reset the level."
        descriptionText.fontColor = buttonColor
        descriptionText.fontSize = 24
        descriptionText.zPosition = 5
        descriptionText.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionText.numberOfLines = 8
        descriptionText.preferredMaxLayoutWidth = mapFrame.frame.width - 2 * descriptionOffset
        descriptionText.position = CGPoint(x: size.width / 2, y: size.height / 2 + mapFrame.frame.height / 2 - descriptionText.frame.size.height - descriptionOffset)

        let buttonFontSize = CGFloat(24)
        let buttonWidth = CGFloat(104)
        let buttonHeight = CGFloat(40)
        let buttonsY = size.height / 2 - mapFrame.frame.height / 2 + buttonHeight / 2 + CGFloat(22)
        let buttonOffset = mapFrame.frame.width / 2 - buttonWidth / 2 - 12
        cancelButton = SKSpriteNode()
        cancelButton.name = "cancelButton"
        cancelButton.color = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        cancelButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        cancelButton.position = CGPoint(x: size.width / 2 - buttonOffset, y: buttonsY)
        cancelButton.zPosition = 5
        cancelButtonLabel = SKLabelNode(fontNamed: "Arial")
        cancelButtonLabel.name = "cancelButtonLabel"
        cancelButtonLabel.text = "Cancel"
        cancelButtonLabel.fontSize = buttonFontSize
        cancelButtonLabel.fontColor = UIColor.black
        cancelButtonLabel.verticalAlignmentMode = .center
        cancelButtonLabel.horizontalAlignmentMode = .center
        cancelButtonLabel.zPosition = 8
        cancelButton.addChild(cancelButtonLabel)

        resetButton = SKSpriteNode()
        resetButton.name = "resetButton"
        resetButton.color = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        resetButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        resetButton.position = CGPoint(x: size.width / 2, y: buttonsY)
        resetButton.zPosition = 5
        resetButtonLabel = SKLabelNode(fontNamed: "Arial")
        resetButtonLabel.name = "resetButtonLabel"
        resetButtonLabel.text = "Reset"
        resetButtonLabel.fontSize = buttonFontSize
        resetButtonLabel.fontColor = UIColor.black
        resetButtonLabel.verticalAlignmentMode = .center
        resetButtonLabel.horizontalAlignmentMode = .center
        resetButtonLabel.zPosition = 8
        resetButton.addChild(resetButtonLabel)

        continueButton = SKSpriteNode()
        continueButton.name = "continueButton"
        continueButton.color = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        continueButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        continueButton.position = CGPoint(x: size.width / 2 + buttonOffset, y: buttonsY)
        continueButton.zPosition = buttonFontSize
        continueButtonLabel = SKLabelNode(fontNamed: "Arial")
        continueButtonLabel.name = "continueButtonLabel"
        continueButtonLabel.text = "Continue"
        continueButtonLabel.fontSize = buttonFontSize
        continueButtonLabel.fontColor = UIColor.black
        continueButtonLabel.verticalAlignmentMode = .center
        continueButtonLabel.horizontalAlignmentMode = .center
        continueButtonLabel.zPosition = 8
        continueButton.addChild(continueButtonLabel)

        changeMap()
    }

    /// Add menu childrens to scene
    func addChildrens() {
        scene.removeAllChildren()
        scene.addChild(mapFrame)
        scene.addChild(titleNode)

        scene.addChild(backButton)
        scene.addChild(leftArrow)
        scene.addChild(rightArrow)

        if askAbility {
            scene.addChild(descriptionText)
            scene.addChild(cancelButton)
            scene.addChild(resetButton)
            scene.addChild(continueButton)
            mapFrame.removeAllChildren()
        } else {
            scene.addChild(playButtonNode)
        }
    }

    /// Calculate menu clicks
    /// - Parameter touch: touch position
    func tick(touch: CGPoint) {
        let nodesArray = scene.nodes(at: touch)

        let buttonName = nodesArray.first?.name

        if buttonName == "playButton" || buttonName == "playButtonLabel" {
            if !canStart {
                return
            }
            // check choosen abilites
            if !checkAbilities() {
                return
            }
            startGame()
        } else if buttonName == "backButton" || buttonName == "backButtonLabel" {
            scene.changeState(state: 0)
        } else if buttonName == "leftArrow" || buttonName == "leftArrowLabel" {
            if mapIndex > 0 {
                mapIndex -= 1
                changeMap()
            }
        } else if buttonName == "rightArrow" || buttonName == "rightArrowLabel" {
            if mapIndex < mapData.count - 1 {
                mapIndex += 1
                changeMap()
            }
        }
        if askAbility {
            if buttonName == "cancelButton" || buttonName == "cancelButtonLabel" {
                askAbility = false
                mapFrame.addChild(statusLabel1)
                mapFrame.addChild(sizeLabel)
                mapFrame.addChild(coinsLabel)
                mapFrame.addChild(actualTime1)
                mapFrame.addChild(bestTime)
                addChildrens()
            } else if buttonName == "continueButton" || buttonName == "continueButtonLabel" {
                if !canStart {
                    return
                }
                startGame()

            } else if buttonName == "resetButton" || buttonName == "resetButtonLabel" {
                let levelLoader = LevelLoader(id: mapData[mapIndex].id, mapName: mapData[mapIndex].file)
                levelLoader.resetLevel(mapIndex: mapIndex)
                
                let profileLoader = ProfileLoader()
                mapFileLoader.changeAbilities(mapId: mapIndex, abilities: profileLoader.getIndexes())
                mapFileLoader.saveData()
                mapData = mapFileLoader.getMaps()
                startGame()
            }
        }
    }
    
    /// Change displayed map
    func changeMap() {
        titleNode.text = mapData[mapIndex].name
        sizeLabel.text = "Size: \(mapData[mapIndex].size)"
        coinsLabel.text = "Coins: \(mapData[mapIndex].coinCount) / 90"
        setByStatus(statusIndex: mapData[mapIndex].status, node: statusLabel2, startNode: playButtonLabel)
        actualTime1.text = "Actual time: \(getTimeString(time: mapData[mapIndex].actualTime))"
        bestTime.text = "Best time: \(getTimeString(time: mapData[mapIndex].bestTime))"

        if !canStart {
            playButtonNode.color = unactiveButtonColor
            playButtonLabel.fontColor = unactiveBlack
        } else {
            playButtonNode.color = buttonColor
            playButtonLabel.fontColor = UIColor.black
        }

        let fontSize = CGFloat(32) + 2
        let textStartX = -mapFrame.frame.size.width / 2 + 4
        let textStartY = mapFrame.frame.size.height / 2 - 4
        statusLabel1.position = CGPoint(x: textStartX + statusLabel1.frame.size.width / 2 + 4, y: textStartY - fontSize)
        statusLabel2.position = CGPoint(x: statusLabel1.frame.size.width + statusLabel2.frame.size.width / 2 - 35, y: 0)
        sizeLabel.position = CGPoint(x: textStartX + sizeLabel.frame.size.width / 2 + 4, y: textStartY - 2 * fontSize)
        coinsLabel.position = CGPoint(x: textStartX + coinsLabel.frame.size.width / 2 + 4, y: textStartY - 3 * fontSize)
        actualTime1.position = CGPoint(x: textStartX + actualTime1.frame.size.width / 2 + 4, y: textStartY - 4 * fontSize)
        bestTime.position = CGPoint(x: textStartX + bestTime.frame.size.width / 2 + 4, y: textStartY - 5 * fontSize)

        if mapIndex == 0 {
            leftArrow.color = unactiveButtonColor
            leftArrowLabel.fontColor = unactiveBlack
        } else {
            leftArrow.color = buttonColor
            leftArrowLabel.fontColor = UIColor.black
        }
        if mapIndex == mapData.count - 1 {
            rightArrow.color = unactiveButtonColor
            rightArrowLabel.fontColor = unactiveBlack
        } else {
            rightArrow.color = buttonColor
            rightArrowLabel.fontColor = UIColor.black
        }
    }

    /// Set map status
    /// - Parameters:
    ///   - statusIndex: status index
    ///   - node: text node
    ///   - startNode: start button node
    func setByStatus(statusIndex: Int, node: SKLabelNode, startNode: SKLabelNode) {
        canStart = true
        var text = "completed"
        var buttonText = "Play again"
        var color = UIColor.green
        if statusIndex == 0 {
            text = "unlocked"
            buttonText = "Start level"
            color = UIColor.yellow
        } else if statusIndex == 1 {
            text = "in progress"
            buttonText = "Continue"
            color = UIColor.yellow
        } else if statusIndex == 2 {
            text = "locked"
            buttonText = "Start level"
            color = UIColor.red
            canStart = false
        } else if statusIndex == 3 {
            //text = "completed"
            buttonText = "Continue"
            color = UIColor.green
        }
        node.fontColor = color
        node.text = text
        node.zPosition = 3
        startNode.text = buttonText
        startNode.zPosition = 3
        startNode.verticalAlignmentMode = .center
        startNode.horizontalAlignmentMode = .center
    }
    
    /// Creates time string
    /// - Parameter time: time
    /// - Returns: time string
    func getTimeString(time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time - 60 * Double(minutes))
        let mils = Int(round((time - 60 * Double(minutes) - Double(seconds)) * 1000))
        if seconds < 10 {
            return "\(minutes):0\(seconds).\(mils)"
        }
        return "\(minutes):\(seconds).\(mils)"
    }

    /// Check if abilities were changed after pausing
    /// - Returns: true if abilities weren't changed
    func checkAbilities() -> Bool {
        let profileLoader = ProfileLoader()
        if mapData[mapIndex].abilityIndexes != profileLoader.getIndexes() {
            print("different abilities")
            if mapData[mapIndex].status == 0 || mapData[mapIndex].status == 4 {
                mapFileLoader.changeAbilities(mapId: mapIndex, abilities: profileLoader.getIndexes())
                mapFileLoader.saveData()
                mapData = mapFileLoader.getMaps()
                return true
            } else {
                askAbility = true
                addChildrens()
                return false
                
            }
        } else {
            return true
        }
    }
    
    /// Start game
    func startGame() {
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameScene = GameScene(size: size)
        gameScene.mapName = mapData[mapIndex].file
        gameScene.mapIndex = mapData[mapIndex].id
        mapFileLoader = nil
        scene.view?.presentScene(gameScene, transition: transition)
    }
}
