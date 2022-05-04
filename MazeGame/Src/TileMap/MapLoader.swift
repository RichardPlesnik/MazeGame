//
//  MapLoader.swift
//  MazeGame
//
//  Created by Richard Plesnik on 04/03/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import Foundation

/// Class for loading map from a file
class MapLoader{
    private var map : [[Int]] = []
    
    
    /// Class constructor
    init(){
        
    }
    
    
    /// Load map as 2D int array  from file
    /// - Parameter name: map name
    func loadMap(name: String){
        print("_____________________________\n")
        print("-- LOADING MAP: ", name, "... --")
        if let filepath = Bundle.main.path(forResource: name, ofType: "save") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let rows = contents.split(separator: "\n")
                for row in rows{
                    map.append(row.split(separator: " ").map { Int($0)!})
                }
                print("-- MAP HAS BEEN LOADED --\n")
                print("_____________________________")
            } catch {
                print("Map could not be loaded")
            }
        } else {
            print(name, ".save not found")
        }
    }
    
    /// Map getter
    /// - Returns: map as 2D int array
    func getMap() -> [[Int]]{
        return map
    }
    
    /// Gets map width
    /// - Returns: map width
    func getMapWidth() -> Int{
        return map[1].count
    }
    
    /// Get map height
    /// - Returns: map height
    func getMapHeight() -> Int{
        return map.count
    }
    
}
