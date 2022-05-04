//
//  Constants.swift
//  MazeGame
//
//  Created by Richard Plesnik on 28/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit

// TODO: move color constants here

/// Class with MazeGame constants
public let COINS_TO_WIN: Int = 90
public let TILE_SIZE = 32

// TODO: add loading from specal file
public let ABILITY_TEXTURES_NAMES = ["coinAbility-64", "magnetAbility-64", "teleportAbility-64", "backAbility-64"]
public let ABILITY_NAMES = ["Path Finder", "Magnet", "Teleport", "Mid Travel"]
public let ABILITY_COOLDOWNS = [[0, 60, 55, 50, 45, 42], [0, 22, 20, 18, 16, 15], [0, 30, 27, 26, 23, 20], [0, 20, 18, 16, 14, 12]]
public let ABILITY_DESCRIPTIONS = ["Use to find a way to the nearest coin.", "Activate ability and select coin from a screen. Coin will be picked up by a magnet.", "Ability that teleports you to the selected location. Tap tile after selection to teleport on it.", "Teleports you to the center of a map."]
public let UPGRADE_COSTS = [100, 150, 250, -1, -3, 0] // +coins, -gems, 0 nothing
public let SKINS_COSTS = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100] // +coi
