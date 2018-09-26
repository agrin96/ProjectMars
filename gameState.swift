//
//  gameState.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/18/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit



/// Singelton class that will keep persistant game data throughout the app.
class gameState: NSObject, NSCoding {

    var GameSettings:gameSettings   //Structure that stores all the game settings
    var PlayerStats:gameStatistics     //Structure that stores all game stats
    var GameBoard:gameBoard        //Contains the information of the gameboard
    var GameLoop:gameLoop?           //Stores the gameloop in its current state
    var isGameInProgress:Bool = false
    
    private static let Instance = loadgameState()
    
    private override init(){
        self.isGameInProgress = false
        self.GameSettings = gameSettings()
        self.PlayerStats = gameStatistics()
        self.GameBoard = gameBoard()
    }
    
    class func sharedInstance() throws -> gameState{
        return self.Instance
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.GameSettings = (aDecoder.decodeObject(forKey: "GameSettings") as? gameSettings)!
        self.PlayerStats = (aDecoder.decodeObject(forKey: "PlayerStats") as? gameStatistics)!
        self.GameBoard = (aDecoder.decodeObject(forKey: "GameBoard") as? gameBoard)!
        self.GameLoop = aDecoder.decodeObject(forKey: "game") as? gameLoop
        self.isGameInProgress = aDecoder.decodeBool(forKey: "inProgress")
    }
    func encode(with aCoder: NSCoder) {
        do{
            aCoder.encode(try gameState.sharedInstance().GameSettings, forKey: "GameSettings")
            aCoder.encode(try gameState.sharedInstance().PlayerStats, forKey: "PlayerStats")
            aCoder.encode(try gameState.sharedInstance().GameBoard, forKey: "GameBoard")
            aCoder.encode(try gameState.sharedInstance().isGameInProgress, forKey: "inProgress")
            aCoder.encode(try gameState.sharedInstance().GameLoop, forKey: "game")
        }catch{ print("Error in gamestate Encode") }
    }
    
    class func loadgameState() ->gameState {
        //gameState.deleteGameState()
        let path = gameState.getFilePath()
        
        if gameState.fileExistsAtPath(path: path){
            if let rawData = NSData(contentsOfFile: path) {
                /// do we get serialized data back from the attempted path?
                /// if so, unarchive it into an AnyObject, and then convert to a GameData object
                if(rawData.length != 0){
                    if let data = NSKeyedUnarchiver.unarchiveObject(with: rawData as Data) as? gameState {
                        return data
                    }
                }
            }
            return gameState()
        }else{
            return gameState()
        }
    }
    
    class func deleteGameState() {
        let path = gameState.getFilePath()
        let fileManager = FileManager.default
        if gameState.fileExistsAtPath(path: path){
            do { try fileManager.removeItem(atPath: path) }
            catch {
                print("Error in deleteGameState")
            }
        }
    }
    
    func save(){
        do{ try gameState.sharedInstance().isGameInProgress = true } catch { print("Error in gamestate save") }
        let path = gameState.getFilePath()
        
        gameState.deleteGameState()
        let saveData = NSKeyedArchiver.archivedData(withRootObject: self)
        let location = URL(fileURLWithPath: path)
        do { try saveData.write(to: location, options: .atomic) }
        catch _ {
            print("error on saveData")
        }
    }
    
    class func fileExistsAtPath(path:String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            return true
        }else{
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return true
    }

    
    class func getFilePath() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let fileName = "/gameState"
        let path = documentsDirectory + "\(fileName).plist"
        return path
    }
}
