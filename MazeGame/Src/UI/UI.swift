//
//  UI.swift
//  MazeGame
//
//  Created by Richard Plesnik on 07/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Class for rendering ingame UI
class UI {
    private var buttonColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
    // Normal state
    var titleNode: SKLabelNode!
    var coinNode: SKSpriteNode!
    var timeLabel: SKLabelNode!
    var timeNode: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    var abilityButton: SKSpriteNode!
    var abilityButton2: SKSpriteNode!
    // Pause state
    var playButton: SKSpriteNode!
    var continueButton: SKSpriteNode!
    var resetButton: SKSpriteNode!
    var quitButton: SKSpriteNode!
    var continueButtonLabel: SKLabelNode!
    var resetButtonLabel: SKLabelNode!
    var quitButtonLabel: SKLabelNode!
    // Ask travel state
    var travelLabel: SKLabelNode!
    var yesButton: SKSpriteNode!
    var yesButtonLabel: SKLabelNode!
    var noButton: SKSpriteNode!
    var noButtonLabel: SKLabelNode!
    var backgroundNode: SKSpriteNode!
    // Won state
    var backgroundNode2: SKSpriteNode!
    var continue2Button: SKSpriteNode!
    var continue2ButtonLabel: SKLabelNode!
    var wonText: SKLabelNode!

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    private var scene: GameScene!
    private var level: Level!

    private var coinCount: Int16!

    var canReset: Bool!
    var paused: Bool!
    var questionPause: Bool!
    var teleportPause: Bool!
    var wonGame: Bool!
    var questionCode = 0 // 0 - trevel, 1 - reset

    var travelTo1 = 0
    var travelTo2 = 0

    var counter = 0.0

    var mapPicture: MapPicture!

    private var backgroundColor = UIColor(red: 33 / 255, green: 33 / 255, blue: 33 / 255, alpha: 1) // 212121
    // var notification: Notification!

    var lastStartTime = Date().timeIntervalSince1970
    var timeSum = Double(0) //

    private var clicked = false

    init(scene: GameScene, level: Level!, screenWidth: CGFloat, screenHeight: CGFloat) {
        self.scene = scene
        self.level = level

        self.screenWidth = screenWidth
        self.screenHeight = screenHeight

        canReset = true
        paused = false
        questionPause = false
        teleportPause = false
        wonGame = false

        coinCount = 0

        // Normla state:
        titleNode = SKLabelNode(fontNamed: "Arial") // Courier Oblique 68   w.0
        titleNode.name = "coinText"
        titleNode.text = "\(coinCount ?? 0)/10₵" // ¢₵₵₵₵¢₵
        titleNode.fontColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        titleNode.position = CGPoint(x: titleNode.frame.width / 2 + 2, y: screenHeight - titleNode.fontSize)
        titleNode.zPosition = 5

        coinNode = SKSpriteNode()
        coinNode.name = "coinNode"
        coinNode.color = backgroundColor // UIColor(red: 56 / 255, green: 62 / 255, blue: 101 / 255, alpha: 1) // 383e65 //212121
        coinNode.size = CGSize(width: titleNode.frame.width, height: 40)
        coinNode.anchorPoint = CGPoint(x: 0, y: 0)
        coinNode.position = CGPoint(x: 0, y: screenHeight - 40)
        coinNode.zPosition = 4

        pauseButton = SKSpriteNode()
        pauseButton.name = "pauseButton"
        pauseButton.texture = SKTexture(imageNamed: "pause32")
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.anchorPoint = CGPoint(x: 0, y: 0)
        pauseButton.position = CGPoint(x: screenWidth - 50, y: screenHeight - 50)
        pauseButton.zPosition = 5

        abilityButton = SKSpriteNode()
        abilityButton.name = "abilityButton"
        abilityButton.texture = SKTexture(imageNamed: "coinAbility1-64")
        abilityButton.size = CGSize(width: 50, height: 50)
        // abilityButton.anchorPoint = CGPoint(x: 0, y: 0)
        abilityButton.position = CGPoint(x: screenWidth - 25, y: 140) // y = 70
        abilityButton.zPosition = 5
        abilityButton2 = SKSpriteNode()
        abilityButton2.name = "abilityButton2"
        abilityButton2.texture = SKTexture(imageNamed: "magnetAbility1-64")
        abilityButton2.size = CGSize(width: 50, height: 50)
        abilityButton2.anchorPoint = CGPoint(x: 0, y: 0)
        abilityButton2.position = CGPoint(x: screenWidth - 50, y: 88) // y = 70
        abilityButton2.zPosition = 5

        timeLabel = SKLabelNode(fontNamed: "Arial") // Courier Oblique 68   w.0
        timeLabel.fontColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        timeLabel.zPosition = 6
        timeNode = SKSpriteNode()
        timeNode.color = backgroundColor // UIColor(red: 56 / 255, green: 62 / 255, blue: 101 / 255, alpha: 1) // 383e65
        timeNode.size = CGSize(width: timeLabel.frame.width, height: 40)
        timeNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        timeNode.position = CGPoint(x: screenWidth - pauseButton.frame.width / 2 - timeLabel.frame.width / 2, y: screenHeight - 20)
        timeNode.zPosition = 8
        timeLabel.verticalAlignmentMode = .center
        timeLabel.horizontalAlignmentMode = .center
        timeNode.addChild(timeLabel)

        // Pause state:
        playButton = SKSpriteNode()
        playButton.name = "playButton"
        playButton.texture = SKTexture(imageNamed: "play32")
        playButton.size = CGSize(width: 50, height: 50)
        playButton.anchorPoint = CGPoint(x: 0, y: 0)
        playButton.position = CGPoint(x: screenWidth - 50, y: screenHeight - 50)
        playButton.zPosition = 5

        continueButton = SKSpriteNode()
        continueButton.name = "continueButton"
        continueButton.color = buttonColor
        continueButton.size = CGSize(width: 250, height: 55)
        continueButton.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 + 68)
        continueButton.zPosition = 5
        continueButtonLabel = SKLabelNode(fontNamed: "Arial")
        continueButtonLabel.name = "continueButtonLabel"
        continueButtonLabel.text = "Continue"
        continueButtonLabel.fontColor = UIColor.black
        continueButtonLabel.verticalAlignmentMode = .center
        continueButtonLabel.horizontalAlignmentMode = .center
        continueButtonLabel.zPosition = 6
        continueButton.addChild(continueButtonLabel)

        resetButton = SKSpriteNode()
        resetButton.name = "resetButton"
        resetButton.color = buttonColor
        resetButton.size = CGSize(width: 250, height: 55)
        resetButton.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        resetButton.zPosition = 5
        resetButtonLabel = SKLabelNode(fontNamed: "Arial")
        resetButtonLabel.name = "resetButtonLabel"
        resetButtonLabel.text = "Reset"
        resetButtonLabel.fontColor = UIColor.black
        resetButtonLabel.verticalAlignmentMode = .center
        resetButtonLabel.horizontalAlignmentMode = .center
        resetButtonLabel.zPosition = 6
        resetButton.addChild(resetButtonLabel)

        quitButton = SKSpriteNode()
        quitButton.name = "quitButton"
        quitButton.color = buttonColor
        quitButton.size = CGSize(width: 250, height: 55)
        quitButton.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 - 68)
        quitButton.zPosition = 5
        quitButtonLabel = SKLabelNode(fontNamed: "Arial")
        quitButtonLabel.name = "quitButtonLabel"
        quitButtonLabel.text = "Exit"
        quitButtonLabel.fontColor = UIColor.black
        quitButtonLabel.verticalAlignmentMode = .center
        quitButtonLabel.horizontalAlignmentMode = .center
        quitButtonLabel.zPosition = 6
        quitButton.addChild(quitButtonLabel)

        // Ask state:
        travelLabel = SKLabelNode(fontNamed: "Arial")
        travelLabel.name = "travelLabel"
        travelLabel.text = "Do you want to travel?"
        travelLabel.fontColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        travelLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 + 50)
        travelLabel.zPosition = 5

        yesButton = SKSpriteNode()
        yesButton.name = "yesButton"
        yesButton.color = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        yesButton.size = CGSize(width: 80, height: 50)
        yesButton.position = CGPoint(x: screenWidth / 2 + 60, y: screenHeight / 2 - 20)
        yesButton.zPosition = 5
        yesButtonLabel = SKLabelNode(fontNamed: "Arial")
        yesButtonLabel.name = "yesButtonLabel"
        yesButtonLabel.text = "Yes"
        yesButtonLabel.fontSize = 27
        yesButtonLabel.fontColor = UIColor.black
        yesButtonLabel.verticalAlignmentMode = .center
        yesButtonLabel.horizontalAlignmentMode = .center
        yesButtonLabel.zPosition = 6
        yesButton.addChild(yesButtonLabel)

        noButton = SKSpriteNode()
        noButton.name = "noButton"
        noButton.color = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        noButton.size = CGSize(width: 80, height: 50)
        noButton.position = CGPoint(x: screenWidth / 2 - 60, y: screenHeight / 2 - 20)
        noButton.zPosition = 5
        noButtonLabel = SKLabelNode(fontNamed: "Arial")
        noButtonLabel.name = "noButtonLabel"
        noButtonLabel.text = "No"
        noButtonLabel.fontSize = 27
        noButtonLabel.fontColor = UIColor.black
        noButtonLabel.verticalAlignmentMode = .center
        noButtonLabel.horizontalAlignmentMode = .center
        noButtonLabel.zPosition = 6
        noButton.addChild(noButtonLabel)

        backgroundNode = SKSpriteNode()
        backgroundNode.name = "backgroundNode"
        backgroundNode.color = UIColor.black // (red: 56 / 255, green: 62 / 255, blue: 101 / 255, alpha: 1) // 383e65
        // backgroundNode.size = CGSize(width: travelLabel.frame.width + 40, height: 170)
        // backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.position = CGPoint(x: screenWidth / 2, y: travelLabel.position.y - 170 / 2 + travelLabel.frame.height + 10)
        backgroundNode.zPosition = 4

        // wonGame state
        backgroundNode2 = SKSpriteNode()
        backgroundNode2.name = "backgroundNode"
        backgroundNode2.color = UIColor.black
        backgroundNode2.size = CGSize(width: 400, height: 200)
        backgroundNode2.position = CGPoint(x: screenWidth / 2, y: travelLabel.position.y - 170 / 2 + travelLabel.frame.height + 10)
        backgroundNode2.zPosition = 4

        continue2Button = SKSpriteNode()
        continue2Button.name = "continue2Button"
        continue2Button.color = buttonColor
        continue2Button.size = CGSize(width: 200, height: 45)
        continue2Button.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 - 60)
        continue2Button.zPosition = 5
        continue2ButtonLabel = SKLabelNode(fontNamed: "Arial")
        continue2ButtonLabel.name = "continue2ButtonLabel"
        continue2ButtonLabel.text = "Continue"
        continue2ButtonLabel.fontColor = UIColor.black
        continue2ButtonLabel.verticalAlignmentMode = .center
        continue2ButtonLabel.horizontalAlignmentMode = .center
        continue2ButtonLabel.zPosition = 6
        continue2Button.addChild(continue2ButtonLabel)

        wonText = SKLabelNode(fontNamed: "Arial")
        wonText.text = "You won!"
        wonText.fontColor = UIColor(red: 255 / 255, green: 110 / 255, blue: 39 / 255, alpha: 1) // ff6e27
        wonText.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 + 64)
        wonText.zPosition = 5

        //tpMap
        mapPicture = MapPicture(scene: scene, level: level, ui: self, screenWidth: screenWidth, screenHeight: screenHeight)

        addToScene()
    }

    
    /// Add UI components to scene
    func addToScene() {
        if questionPause {
            scene.addChild(travelLabel)
            scene.addChild(yesButton)
            scene.addChild(noButton)
            scene.addChild(backgroundNode)
        } else if paused {
            scene.addChild(playButton)
            scene.addChild(continueButton)
            scene.addChild(resetButton)
            scene.addChild(quitButton)
        } else if wonGame {
            scene.addChild(backgroundNode2)
            scene.addChild(continue2Button)

            scene.addChild(timeLabel)
            scene.addChild(wonText)
            timeLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        } else if teleportPause {
            mapPicture.addToScene()
        } else {
            scene.addChild(pauseButton)
            // scene.addChild(abilityButton)
            // scene.addChild(abilityButton2)
            scene.addChild(titleNode)
            scene.addChild(coinNode)
            scene.addChild(timeNode)
        }
    }

    
    /// Remove UI components from scene
    func removeFromScene() {
        if paused {
            playButton.removeFromParent()
            continueButton.removeFromParent()
            resetButton.removeFromParent()
            quitButton.removeFromParent()
        } else if wonGame {
            backgroundNode2.removeFromParent()
            continueButton.removeFromParent()

            timeLabel.removeFromParent()
            wonText.removeFromParent()
        } else if questionPause {
            travelLabel.removeFromParent()
            yesButton.removeFromParent()
            noButton.removeFromParent()
            backgroundNode.removeFromParent()
        } else if teleportPause {
            mapPicture.removeFromScene()
        } else {
            pauseButton.removeFromParent()
            abilityButton.removeFromParent()
            abilityButton2.removeFromParent()
            titleNode.removeFromParent()
            coinNode.removeFromParent()
            timeNode.removeFromParent()
        }
    }

    
    /// Increment UI coin count
    func foundCoin() {
        coinCount += 1
        titleNode.text = "\(coinCount ?? 0)/10₵"
        titleNode.position = CGPoint(x: titleNode.frame.width / 2 + 2, y: screenHeight - titleNode.fontSize)
        coinNode.size = CGSize(width: titleNode.frame.width, height: 40)
    }
    
    /// Set UI coin count
    /// - Parameter count: coin count
    func setCoinCount(count: Int16) {
        coinCount = count
        titleNode.text = "\(coinCount ?? 0)/10₵"
        titleNode.position = CGPoint(x: titleNode.frame.width / 2 + 2, y: screenHeight - titleNode.fontSize)
        coinNode.size = CGSize(width: titleNode.frame.width, height: 40)
    }

    
    /// Called on every tick of game
    /// - Parameter fingerPosition: finger position
    func tick(fingerPosition: CGPoint) {
    }

    /// Called on click of game
    /// - Parameter fingerPosition: finger position
    func clickTick(fingerPosition: CGPoint) {
        let nodesArray = scene.nodes(at: fingerPosition)
        let buttonName = nodesArray.first?.name

        if questionPause {
            if buttonName == "yesButton" || buttonName == "yesButtonLabel" {
                print("Yes pressed")
                if questionCode == 0 {
                    questionPause = false
                    level.unpause()
                    level.stillRender = false
                    level.travel(partIndex: travelTo1, spawnIndex: travelTo2)
                } else if questionCode == 1 {
                    questionPause = false
                    questionCode = 0

                    scene.resetMove()
                    canReset = true
                    level.reset()
                    level.unpause()
                    paused = false
                    resetTimer()
                    level.reloadScreen()
                }
            }

            if buttonName == "noButton" || buttonName == "noButtonLabel" {
                print("No pressed")
                if questionCode == 0 {
                    questionPause = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.level.stillRender = false
                        self.level.unpause()
                    }
                } else if questionCode == 1 {
                    questionPause = false
                    questionCode = 0
                }
            }
        } else if paused {
            if buttonName == "continueButton" || buttonName == "continueButtonLabel" {
                print("Continue pressed")
                scene.resetMove()
                canReset = true
                level.unpause()
                paused = false
                resetTimer()
                level.reloadScreen()
            }
            if buttonName == "resetButton" || buttonName == "resetButtonLabel" {
                print("Reset Pressed")
                removeFromScene()
                askReset()
                addToScene()
            }
            if buttonName == "quitButton" || buttonName == "quitButtonLabel" {
                print("Quit Pressed")
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let menuScene = MenuScene(size: scene.size)
                menuScene.setState(state: 1)
                level.exitSave()
                scene.view?.presentScene(menuScene, transition: transition)
            }
            if buttonName == "playButton" {
                print("Unpause pressed")
                paused = false
                counter = 0
                level.unpause()
                counter = Date.timeIntervalSinceReferenceDate
                resetTimer()
            }
        } else if wonGame {
            if buttonName == "continue2Button" || buttonName == "continue2ButtonLabel" {
                print("Continue2 pressed")
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let menuScene = MenuScene(size: scene.size)
                menuScene.setState(state: 1)
                scene.view?.presentScene(menuScene, transition: transition)
            }
        } else if teleportPause {
            mapPicture.tick(fingerPosition: fingerPosition, nodesArray: nodesArray, button: nodesArray.first ?? pauseButton)
        } else {
            clicked = false
            if buttonName == "pauseButton" {
                scene.resetMove()
                print("Pause pressed")
                paused = true
                counter = 0
                level.pause()
                level.stillRender = false
                counter = Date.timeIntervalSinceReferenceDate
                pauseTimer()
                level.reloadScreen()
            }
        }
    }

    
    /// Display travel prompt
    /// - Parameters:
    ///   - partIndex: part index
    ///   - spawnIndex: spawn index
    func askTravel(partIndex: Int, spawnIndex: Int) {
        travelLabel.text = "Do you want to travel?"
        backgroundNode.size = CGSize(width: travelLabel.frame.width + 40, height: 170)
        travelTo1 = partIndex
        travelTo2 = spawnIndex
        level.pause()
        level.stillRender = true
        questionCode = 0

        questionPause = true
    }
    
    /// Display reset prompt
    func askReset() {
        travelLabel.text = "      Reset level?      "
        backgroundNode.size = CGSize(width: travelLabel.frame.width + 120, height: 170)
        questionPause = true
        questionCode = 1
    }

    
    /// Display teleport prompt
    func askTeleport() {
        travelLabel.text = "Do you want to teleport?"
        backgroundNode.size = CGSize(width: travelLabel.frame.width + 40, height: 170)
        level.pause()
        level.stillRender = true
        // paused = true
        teleportPause = true
        mapPicture.steped()
        // for tests:
    }

    
    /// Refresh in game time
    func tickTime() {
        if paused || wonGame {
        } else {
            timeLabel.text = getTimeString()
            timeNode.size = CGSize(width: timeLabel.frame.width + 4, height: 40)
            timeNode.position = CGPoint(x: screenWidth - pauseButton.frame.width - timeLabel.frame.width / 2 - 2, y: screenHeight - 20)

            //timeLabel.position = CGPoint(x: pauseButton.position.x - pauseButton.frame.width - timeLabel.frame.size.width, y: screenHeight - timeLabel.fontSize)
        }
    }

    
    /// Create time stirng
    /// - Returns: time string
    func getTimeString() -> String {
        let time = Date().timeIntervalSince1970 - lastStartTime + timeSum
        let minutes = Int(time / 60)
        let seconds = Int(time - 60 * Double(minutes))
        if minutes > 0 {
            if seconds < 10 {
                return "Time: \(minutes):0\(seconds)"
            }
            return "Time: \(minutes):\(seconds)"
        }
        if seconds < 10 {
            return "Time: 0\(seconds)"
        }
        return "Time: \(seconds)s"
    }

    
    /// Create time stirng
    /// - Returns: descriptiontime string
    func getTimeString2() -> String {
        let time = Date().timeIntervalSince1970 - lastStartTime + timeSum
        let minutes = Int(time / 60)
        let seconds = Int(time - 60 * Double(minutes))
        let mils = Int(round((time - 60 * Double(minutes) - Double(seconds)) * 1000))
        return "Time: \(minutes)min \(seconds)s \(mils)ms"
    }
    
    /// Set start time of level
    /// - Parameter startTime: start time
    func setStartTime(startTime: TimeInterval) {
        timeSum = startTime
    }

    
    /// Resets timer
    func resetTimer() {
        lastStartTime = Date().timeIntervalSince1970
    }

    
    /// Pause timer
    func pauseTimer() {
        timeSum += Date().timeIntervalSince1970 - lastStartTime
    }

    
    /// Time getter
    /// - Returns: time
    func getTime() -> TimeInterval {
        if !paused {
            pauseTimer()
        }
        resetTimer()
        return timeSum
    }
    
    /// Called after finishing game
    func win() {
        wonGame = true
        timeLabel.text = getTimeString2()
        timeNode.removeAllChildren()
        level.resetSave()
    }
    
    /// Return if UI was clickeed
    /// - Returns: true if UI is clicked
    func uiClicked() -> Bool {
        return clicked
    }
    
    /// Level time getter
    /// - Returns: level time
    func getLevelTime() -> TimeInterval {
        return Date().timeIntervalSince1970 - lastStartTime + timeSum
    }
}
