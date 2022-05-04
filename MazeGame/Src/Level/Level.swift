//
//  Level.swift
//  MazeGame
//
//  Created by Richard Plesnik on 04/03/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Main class representing game level
class Level {
    private var MAP_NAME = "level001-4"

    var running = true
    var paused: Bool!
    var stillRender = false // render game even after pause, dont get input
    private var loading = false

    var finished = false

    private var scene: GameScene!

    private var player: Player!
    private var joystick: Joystick!
    private var ui: UI!
    private var abilitySlots: AbilityManager!
    private var notification: Notification!

    private var screenSize: CGRect = UIScreen.main.bounds
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!

    private var tileMap: TileMap!
    private var screen: Screen!

    private var movementAngle: CGFloat = 0
    private var rotationAngle: CGFloat = 0

    private var lastUpdateTime: CFTimeInterval = 0

    private var coinCount: Int16 = 0

    private var levelLoader: LevelLoader!

    private var spawnPoint = CGPoint(x: 2 * 11 * 32.0, y: 2 * 11 * 32.0)

    private var mapName: String!
    private var mapIndex: Int!
    private var partIndex1: Int!

    var onTeleport = false

    private var uiClicked = false

    private var uiInScene = false

    //tick lock:
    private var lastTime: Double!
    private var timer: Double!
    private let timePerTick: Double = 1000000.0 / 64
    private var delta: Double = 0
    private var ticks: Int = 0

    private var startTime = Date().timeIntervalSince1970

    
    /// Class constructor
    /// - Parameters:
    ///   - scene: game scene
    ///   - mapIndex: map index
    ///   - mapName: map name
    init(scene: GameScene, mapIndex: Int, mapName: String) {
        self.scene = scene
        self.mapName = mapName
        self.mapIndex = mapIndex

        screenWidth = screenSize.width // screenWidth = 750 //screenWidth = screenSize.width
        screenHeight = screenSize.height // screenHeight = 1334//screenHeight = screenSize.height

        start()

        loadNewLevel(id: mapIndex, mapName: mapName)
    }
    
    /// Load new level
    /// - Parameters:
    ///   - id: map id/index
    ///   - mapName: map name
    func loadNewLevel(id: Int, mapName: String) {
        levelLoader = LevelLoader(id: id, mapName: mapName)
        MAP_NAME = levelLoader.getMap()

        tileMap = TileMap(name: MAP_NAME, tileSize: Int(TILE_SIZE), coins: levelLoader.getCoins(), spawnIndex: levelLoader.getSpawnIndex(), level: self)

        player = Player(scene: scene, level: self, x: spawnPoint.x, y: spawnPoint.y, screenWidth: screenWidth, screenHeight: screenHeight, mapSize: (tileMap.width, tileMap.height), tileSize: TILE_SIZE)

        player.setTiles(tiles: tileMap.tiles)

        screen = Screen(width: screenWidth, height: screenHeight, scene: scene, player: player, tileMap: tileMap)
        screen.fillScreen()

        joystick = Joystick(scene: scene, size: 12)

        ui = UI(scene: scene, level: self, screenWidth: screenWidth, screenHeight: screenHeight)
        // nacist indexy abilit pred predanim
        let mapFileLoader = MapFileLoader()
        abilitySlots = AbilityManager(scene: scene, level: self, screenWidth: screenWidth, screenHeight: screenHeight, abilityIndexes: mapFileLoader.getAbilities(mapId: id))
        abilitySlots.setCooldowns(cooldowns: levelLoader.getCooldowns())
        notification = Notification(scene: scene, screenWidth: screenWidth, screenHeight: screenHeight)
        ui.setCoinCount(count: levelLoader.getCoinCount())
        ui.setStartTime(startTime: levelLoader.getTime())
        coinCount = levelLoader.getCoinCount()

        partIndex1 = levelLoader.getPartIndex()

        scene.isPaused = false
    }
    
    /// Calculate 
    /// - Parameters:
    ///   - deltaTime: time from previous tick
    ///   - fingerPosition: cuyrrent finger position
    ///   - canMove: true if player can move
    func tick(deltaTime: TimeInterval, fingerPosition: CGPoint, canMove: Bool) {
        if running {
            if !paused {
                joystick.tick(fingerPosition: fingerPosition, canMove: canMove)

                movementAngle = joystick.getMovementAngle()
                rotationAngle = joystick.getRotationAngle()

                player.tick(deltaTime: deltaTime, movementAngle: movementAngle, rotationAngle: rotationAngle, canMove: canMove)
            }

            if canMove {
                scene.removeAllChildren()
                if !paused || stillRender {
                    player.addToScene()
                    joystick.addToScene()
                    abilitySlots.addToScene()

                    screen.tick()
                }
                ui.addToScene()
            }
            ui.tickTime()
            abilitySlots.tickTime()

            if !paused {
                notification.addToScene()
            }
        }
    }
    
    /// Calculate operation on click
    /// - Parameter fingerPosition: position of click
    func clickTick(fingerPosition: CGPoint) {
        if running {
            ui.clickTick(fingerPosition: fingerPosition)
            if !paused {
                abilitySlots.tick(fingerPosition: fingerPosition)                
            }
        }
    }
    
    /// Stop level
    func stop() {
        running = false
        paused = true
        scene.removeAllChildren()
    }
    
    /// Start level
    func start() {
        running = true
        paused = false
        loading = false
        lastTime = NSTimeIntervalSince1970
        timer = NSTimeIntervalSince1970
    }
    
    /// Reset level
    func reset() {
        stop()
        levelLoader.resetLevel(mapIndex: mapIndex)
        loadNewLevel(id: mapIndex, mapName: mapName)
        running = true
    }
    
    /// Reset save file
    func resetSave() {
        levelLoader.resetLevel(mapIndex: mapIndex)
    }
    
    /// Pause level
    func pause() {
        paused = true
    }
    
    /// Unpause level
    func unpause() {
        paused = false
    }
    
    /// Loading level state
    func loadingState() {
        running = false
        loading = true
        scene.removeAllChildren()
    }
    
    /// Called after coin is found
    /// - Parameter newIndex: coin index
    func foundCoin(newIndex: Int) {
        abilitySlots.foundCoin()
        setTime()
        coinCount += 1
        ui.foundCoin()
        let countToProfile = tileMap.updateCoins(index: newIndex)
        levelLoader.changeCoins(coins: tileMap.getCoins(), coinCount: coinCount)
        levelLoader.saveData()
        if countToProfile {
          addProfileCoin()
        }
        if levelLoader.getCoinsSum() >= COINS_TO_WIN { // 90
            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            levelLoader.getMapFileLoader().endTime(mapId: mapIndex, time: ui.getTime())
            ui.win()

            pause()
            finished = true
            print("vyhra")
        }
        if coinCount == 10 {
            notification.showNotification(text: "All 10 coins found", time: 1500)
        }
    }

    
    /// Called after finding a door
    /// - Parameters:
    ///   - x: x position
    ///   - y: y position
    func foundDoor(x: Int, y: Int) {
        setTime()
        // 0 1 2
        // 3 4 5
        // 6 7 8
        // left/right +/- 1
        // up/down +/- 3
        let border = (tileMap.getWidth() - 3) * Int(TILE_SIZE)

        resetJoystick()

        var partIndex = levelLoader.getPartIndex()
        var spawnIndex = 0

        if x < 64 { // (57)
            partIndex -= 1
            spawnPoint = CGPoint(x: border - 7, y: y)
            spawnIndex = 2
        } else if x > border { // 1383
            partIndex += 1
            spawnPoint = CGPoint(x: 64, y: y)
            spawnIndex = 4
        } else if y < 64 { // (57)
            partIndex += 3
            spawnPoint = CGPoint(x: x, y: border - 7)
            spawnIndex = 1
        } else if y > border { // 1383
            partIndex -= 3
            spawnPoint = CGPoint(x: x, y: 64)
            spawnIndex = 3
        }
        ui.askTravel(partIndex: partIndex, spawnIndex: spawnIndex)
    }
    
    /// Travel to another map part
    /// - Parameters:
    ///   - partIndex: map part index
    ///   - spawnIndex: spawn index
    func travel(partIndex: Int, spawnIndex: Int) {
        if partIndex1 == partIndex {
            print("same location")
            tileMap.setSpawnIndex(index: spawnIndex)
            tileMap.setSpawn(level: self)
            player.xPos = spawnPoint.x
            player.yPos = spawnPoint.y
            player.setOnTeleport()
            partIndex1 = partIndex

            ui.teleportPause = false
            stillRender = false
            unpause()
            scene.resetMove()
            reloadScreen()
        } else {
            partIndex1 = partIndex
            print("traveling...")            
            setTime()
            levelLoader.changePart(newPartIndex: partIndex, spawnIndex: spawnIndex)
            levelLoader.saveData()
            loadingState()
            loadNewLevel(id: mapIndex, mapName: mapName)
            scene.resetMove()
            start()
        }
    }
    
    /// Travel to specific tile
    /// - Parameter tileIndex: tiel index
    func travelOnTile(tileIndex: Int) {
        player.travelOnTile(tileIndex: tileIndex)
        abilitySlots.tpCooldown()
        scene.resetMove()
        reloadScreen()
    }
    
    /// Called after finding a teleport
    /// - Parameters:
    ///   - x: x position
    ///   - y: y postiion
    func foundTeleport(x: Int, y: Int) {
        setTime()

        let border = (tileMap.getWidth() - 3) * TILE_SIZE - 32
        let teleports = levelLoader.getTeleports()

        var teleportIndex = -1

        if y > border && !teleports[1] { // top spawn
            teleportIndex = 1
        } else if x > border && !teleports[2] { // right spawn
            teleportIndex = 2
        } else if y < 96 && !teleports[3] { // bottom spawn
            teleportIndex = 3
        } else if x < 93 && !teleports[4] { // left spawn
            teleportIndex = 4
        } else if x > 99 && y > 93 && x < border && y < border && !teleports[0] { // mid
            teleportIndex = 0
        }

        if teleportIndex == -1 {
            // known teleport
            resetJoystick()
            ui.askTeleport()
        } else {
            // found new teleport
            levelLoader.changeTeleport(teleportIndex: teleportIndex, x: x, y: y)
            tileMap.setTeleports(level: self)
            levelLoader.saveData()
            levelLoader.loadData()            
            notification.showNotification(text: "Teleport activated", time: 1000)
        }
    }
    
    /// Save data after leaving game
    func exitSave() {
        levelLoader.changeTime(newTime: ui.getTime())
        levelLoader.saveData()
    }

    /// Show ability notification
    func ability(index: Int) -> Int {
        if index == 0 {
        } else if index == 2 {
        } else {
            notification = Notification(scene: scene, screenWidth: screenWidth, screenHeight: screenHeight)
            notification.showNotification(text: "Unknown ability", time: 1000)
            return 0
        }
        return 1
    }
    
    /// Increment coin count in profile loader
    func addProfileCoin(){
      let profileLoader = ProfileLoader()
      profileLoader.incrementCoins();
      profileLoader.saveData();
    }
    
    /// Reaload screen
    func reloadScreen() {
        scene.removeAllChildren()
        if !paused || stillRender {
            player.addToScene()
            joystick.addToScene()
            abilitySlots.addToScene()
            screen.tick()
        }
        ui.addToScene()
    }
    
    /// Reset UI joystickl
    func resetJoystick() {
        joystick.resetPosition()
    }
    
    /// Move player to spawn
    func playerOnSpawn() {
        player.xPos = tileMap.getMidPos().x - 16
        player.yPos = tileMap.getMidPos().y - 16
        player.setOnTeleport()
    }
    
    /// <Show notification
    /// - Parameters:
    ///   - text: notification text
    ///   - time: notification duration
    func showNotification(text: String, time: Int) {
        notification = Notification(scene: scene, screenWidth: screenWidth, screenHeight: screenHeight)
        notification.showNotification(text: text, time: time)
    }
    
    /// Reset move
    func resetMove() {
        scene.resetMove()
        reloadScreen()
    }

    //Getters and setters:
    
    func setSpawn(x: Int, y: Int) {
        spawnPoint = CGPoint(x: x, y: y)
    }

    func getTeleports() -> [Bool] {
        return levelLoader.getTeleports()
    }

    func getParts() -> [MapPart] {
        return levelLoader.getParts()
    }

    func getMapWidth() -> Int {
        return tileMap.getWidth() * TILE_SIZE
    }

    func getMapHeight() -> Int {
        return tileMap.getHeight() * TILE_SIZE
    }

    func getPlayerPos() -> CGPoint {
        return CGPoint(x: player.getX(), y: player.getY())
    }

    func getPartIndex() -> Int {
        return levelLoader.getPartIndex()
    }

    func setTime() {
        levelLoader.changeTime(newTime: ui.getTime())
    }

    func getCoinCount() -> Int16 {
        return coinCount
    }

    func getTime() -> TimeInterval {
        return ui.getLevelTime()
    }

    func setCooldowns() {
        levelLoader.changeCooldowns(cooldowns: abilitySlots.getCooldowns())
        levelLoader.saveData()
    }

    func setMove() {
        scene.canMove = true
    }

    func getTileMap() -> TileMap {
        return tileMap
    }
   
}
