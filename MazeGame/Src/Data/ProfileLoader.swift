//
//  ProfileLoader.swift
//  MazeGame
//
//  Created by Richard Plesnik on 25/09/2020.
//  Copyright © 2020 Richard Plesnik. All rights reserved.
//

import SpriteKit


/// Structure for saving profile data. Matched with json representation.
struct ProfileData: Codable {
    var abilityUnclocks: [Int]
    var abilityIndexes: [Int]
    var skinsUnlocks: [Bool]
    var equipedSkin: Int

    var coinCount: Int
    var gemCount: Int
    
}

/// Class used for loading profile data from json file.
class ProfileLoader {
    private var profileData: ProfileData!

    private var fileName = "ProfileData"

    /// Class constructor
    init() {
        print("\n____LOADING PROFILE DATA____")
        loadProfile()
        print("____PROFILE LOADED____\n")
    }

    /// Function used for loading from json data file
    func loadData() {
        let decoder = JSONDecoder()

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            print(fileURL)

            do {
                let data = try Data(contentsOf: fileURL)
                profileData = try decoder.decode(ProfileData.self, from: data)

            } catch {
                print("Decoding error \(error)")
                print("Creating new file")
                initSaveFile()
            }
        }
    }

    /// Creates new json file based on template in Res folder
    func initSaveFile() {
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath)
                print(contents)
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent(fileName)
                    do {
                        try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                    } catch {
                        print("failed to write")
                    }
                }
            } catch {
                print("Default data cannot be loaded")
            }
        } else {
            print("File not found")
        }
        // TODO: add counter/something to prevent infinate loop if file template is missing
        loadData()
    }

    /// Save actual profile data from struct to json file
    func saveData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(profileData)
        // print(String(data: data, encoding: .utf8)!)
        let dataString = String(data: data, encoding: .utf8)!

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)

            do {
                try dataString.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print("failed to write")
            }
        }
    }

    /// Load profile data
    func loadProfile() {
        loadData()
    }
    
    //Getters and setters:

    func changeUnlocks(abilities: [Int]) {
        changeUnlocks2(profile: &profileData, abilities: abilities)
    }
    
    func changeUnlocks2(profile: inout ProfileData, abilities: [Int]) {
        profile.abilityUnclocks = abilities
    }
    
    func getUnclocks() -> [Int] {
        return profileData.abilityUnclocks
    }
    
    func changeSkinsUnlocks(unlocks: [Bool]) {
        changeSkinsUnlocks2(profile: &profileData, unlocks: unlocks)
    }
    
    func changeSkinsUnlocks2(profile: inout ProfileData, unlocks: [Bool]) {
        profile.skinsUnlocks = unlocks
    }
    
    func getSkinsUnlocks() -> [Bool] {
        return profileData.skinsUnlocks
    }
    
    func changeIndexes(indexes: [Int]) {
        changeIndexes2(profile: &profileData, indexes: indexes)
    }
    
    func changeIndexes2(profile: inout ProfileData, indexes: [Int]) {
        profile.abilityIndexes = indexes
    }
    
    func getIndexes() -> [Int] {
        return profileData.abilityIndexes
    }
    
    func getCoinCount() -> Int {
        return profileData.coinCount
    }
    
    func changeCoinCount(coinCount: Int) {
        changeCoinCount2(profile: &profileData, coinCount: coinCount)
    }
    
    func changeCoinCount2(profile: inout ProfileData, coinCount: Int) {
        profile.coinCount = coinCount
    }
    
    func incrementCoins(){
      incrementCoins2(profile: &profileData)
    }
    
    func incrementCoins2(profile: inout ProfileData){
      profile.coinCount += 1;
    }

    func getGemCount() -> Int {
        return profileData.gemCount
    }
    
    func changeGemCount(gemCount: Int) {
        changeGemCount2(profile: &profileData, gemCount: gemCount)
    }
    
    func changeGemCount2(profile: inout ProfileData, gemCount: Int) {
        profile.gemCount = gemCount
    }
    
    func getEquipedSkin() -> Int {
        return profileData.equipedSkin
    }
    
    func changeEquipedSkin(equipedSkin: Int) {
        changeEquipedSkin2(profile: &profileData, equipedSkin: equipedSkin)
    }
    
    func changeEquipedSkin2(profile: inout ProfileData, equipedSkin: Int) {
        profile.equipedSkin = equipedSkin
    }
}
