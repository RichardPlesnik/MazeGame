//
//  CoinPath.swift
//  MazeGame
//
//  Created by Richard Plesnik on 27/08/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

/// Class used for queue representation
struct Queue<T> {
    private var elements: [T] = []

    mutating func enqueue(_ value: T) {
        elements.append(value)
    }

    mutating func dequeue() -> T {
        return elements.removeFirst()
    }

    var head: T? {
        return elements.first
    }
       
    var tail: T? {
        return elements.last
    }

    mutating func isEmpty() -> Bool {
        return elements.isEmpty
    }
}

/// Class used to find path to shortest coin
class CoinPath {
    private var tileMap: TileMap!

    private var tileSize: CGFloat!

    private var mapWidth: Int!
    private var tiles: [Tile]!

    private var pathIndexes: [Int] = []

    // Used for debuging
    private var cheatMode = false //true
    private var cheatList = [0, 2, 4, 5, 1, 3, 7, 8, 9, 6, 10]
    private var cheatIndex = 0
    
    /// Class constructor
    /// - Parameter tileMap: map of level tiles
    init(tileMap: TileMap) {
        self.tileMap = tileMap

        tileSize = CGFloat(tileMap.tileSize)
        mapWidth = tileMap.width
        tiles = tileMap.getTiles()
    }

    
    /// Find path to shortest coin. (BFS)
    /// - Parameters:
    ///   - xPos: x position of player
    ///   - yPos: y position of player
    func findPath(xPos: CGFloat, yPos: CGFloat) {
        removePath()
        // CheatMode is used for debuging
        if cheatMode {
            cheatPath(spawnPoint: CGPoint(x: xPos, y: yPos))
            return
        }

        let playerIndex = getTileByPos(x: xPos + tileSize / 2, y: yPos + tileSize / 2)

        var tileDistances = [Int](repeating: -1, count: tiles.count)
        var q = Queue<Int>()
        var coinIndex = -1

        tileDistances[playerIndex] = 0
        q.enqueue(playerIndex)

        while !q.isEmpty() {
            let actual = q.dequeue()
            let ns = getNeightbours(i: actual)
            if !ns.isEmpty {
                if ns[0] == -1 {
                    coinIndex = ns[1]
                    tileDistances[coinIndex] = tileDistances[actual] + 1
                    break
                }
            }
            for n in ns {
                if tileDistances[n] == -1 {
                    tileDistances[n] = tileDistances[actual] + 1
                    q.enqueue(n)
                }
            }
        }
        drawPath(tileDistances: tileDistances, coinIndex: coinIndex)
    }

    
    /// Draws found path
    /// - Parameters:
    ///   - tileDistances: actual distance from coin
    ///   - coinIndex: index of coin
    func drawPath(tileDistances: [Int], coinIndex: Int) { // vykresli cestu
        var actualIndex = coinIndex
        var actualDistance = tileDistances[coinIndex]

        while actualDistance != 0 {
            let ns = getNeightbours2(i: actualIndex)
            for n in ns {
                if tileDistances[n] == actualDistance - 1 {
                    actualIndex = n
                    actualDistance = tileDistances[actualIndex]
                    break
                }
            }
            tiles[actualIndex].markTile()
            pathIndexes.append(actualIndex)
        }
    }

    
    /// Removes found path
    func removePath() {
        for index in pathIndexes {
            tiles[index].disappearTile()
        }
        pathIndexes = []
        if cheatMode {
            cheatPath(spawnPoint: CGPoint(x: 100, y: 100))
        }
    }
    
    /// Finds shortest distance between 2 tiles (BFS)
    /// - Parameters:
    ///   - index1: index of first tile
    ///   - index2: index of second tile
    /// - Returns: distance between two tiles
    func pathDistance(index1: Int, index2: Int) -> Int { // najde vzdalenost mezi 2 tilama
        var tileDistances = [Int](repeating: -1, count: tiles.count)
        var q = Queue<Int>()

        tileDistances[index1] = 0
        q.enqueue(index1)

        while !q.isEmpty() {
            let actual = q.dequeue()
            let ns = getNeightbours2(i: actual)
            for n in ns {
                if n == index2 {
                    return tileDistances[actual] + 1
                }
                if tileDistances[n] == -1 {
                    tileDistances[n] = tileDistances[actual] + 1
                    q.enqueue(n)
                }
            }
        }
        return 0
    }

    
    /// Used fo rebuging coin path finding.
    /// - Parameter spawnPoint: position of player
    func cheatPath(spawnPoint: CGPoint) { // ukazuje nejkratsi cestu podle seznamu uzlu
        var tileDistances = [Int](repeating: -1, count: tiles.count)
        var q = Queue<Int>()

        let playerIndex = getTileByPos(x: spawnPoint.x + tileSize / 2, y: spawnPoint.y + tileSize / 2)
        var coinIndexes: [Int] = [playerIndex]
        for i in tileMap.coinIndexes {
            coinIndexes.append(i)
        }
        if cheatIndex == 10 {
            return
        }
        let index1 = coinIndexes[cheatList[cheatIndex]]
        let index2 = coinIndexes[cheatList[cheatIndex + 1]]
        cheatIndex += 1

        tileDistances[index1] = 0
        q.enqueue(index1)

        while !q.isEmpty() {
            let actual = q.dequeue()
            let ns = getNeightbours2(i: actual)
            for n in ns {
                if n == index2 {
                    tileDistances[n] = tileDistances[actual] + 1
                    break
                }
                if tileDistances[n] == -1 {
                    tileDistances[n] = tileDistances[actual] + 1
                    q.enqueue(n)
                }
            }
        }
        drawPath(tileDistances: tileDistances, coinIndex: index2)
    }

    
    /// Finds which tiles around "i" are floor tiles.
    ///  No outOfRange handeling, couse map has always solid border.
    /// - Parameter i: index of curent tile
    /// - Returns: list of floor neighbour tiles or [-1, coin index] if coin was found
    func getNeightbours(i: Int) -> [Int] {
        var neightbours: [Int] = []
        if !tiles[i - 1].isSolid { // left
            neightbours.append(i - 1)
        }
        if !tiles[i + 1].isSolid { // right
            neightbours.append(i + 1)
        }
        if !tiles[i - mapWidth].isSolid { // up
            neightbours.append(i - mapWidth)
        }
        if !tiles[i + mapWidth].isSolid { // down
            neightbours.append(i + mapWidth)
        }
        for n in neightbours {
            if tiles[n].id == 2 {
                neightbours = [-1]
                neightbours.append(n)
            }
        }
        return neightbours
    }

    
    /// Finds which tiles around "i" are floor tiles.
    ///  No outOfRange handeling, couse map has always solid border.
    /// - Parameter i: index of curent tile
    /// - Returns: list of floor neighbour tiles
    func getNeightbours2(i: Int) -> [Int] {
        var neightbours: [Int] = [] // indexy sousedu
        if !tiles[i - 1].isSolid { // levo
            neightbours.append(i - 1)
        }
        if !tiles[i + 1].isSolid { // pravo
            neightbours.append(i + 1)
        }
        if !tiles[i - mapWidth].isSolid { // nahoru
            neightbours.append(i - mapWidth)
        }
        if !tiles[i + mapWidth].isSolid { // dolu
            neightbours.append(i + mapWidth)
        }
        return neightbours
    }

    
    /// Find tile on given postition
    /// - Parameters:
    ///   - x: x position
    ///   - y: y position
    /// - Returns: index of found tile
    func getTileByPos(x: CGFloat, y: CGFloat) -> Int {
        let tileIndex = Int(y / tileSize) * tileMap.width + Int(x / tileSize)
        return tileIndex
    }
}
