//
//  DataStructures.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/18/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class gameBoard:NSObject, NSCoding {
    var Provinces:Array<Province> = []
    var boardMap:SKSpriteNode!
    var boardCamera:PlayerCamera!
    
    var landShipLayer:SKNode!
    var extractorLayer:SKNode!
    var crawlerLayer:SKNode!
    
    override init() {
        super.init()
        self.boardMap = SKSpriteNode()
        self.boardCamera = PlayerCamera()
        self.landShipLayer = SKNode()
        self.extractorLayer = SKNode()
        self.crawlerLayer = SKNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.Provinces = (aDecoder.decodeObject(forKey: "Provinces") as? Array<Province>)!
        self.boardMap = aDecoder.decodeObject(forKey: "boardMap") as? SKSpriteNode
        self.boardCamera = aDecoder.decodeObject(forKey: "boardCamera") as? PlayerCamera
        
        self.landShipLayer = aDecoder.decodeObject(forKey: "landships") as? SKNode!
        self.extractorLayer = aDecoder.decodeObject(forKey: "extractors") as? SKNode!
        self.crawlerLayer = aDecoder.decodeObject(forKey: "crawlers") as? SKNode!
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Provinces, forKey: "Provinces")
        aCoder.encode(self.boardMap, forKey: "boardMap")
        aCoder.encode(self.boardCamera, forKey: "boardCamera")
        aCoder.encode(self.landShipLayer, forKey: "landships")
        aCoder.encode(self.extractorLayer, forKey: "extractors")
        aCoder.encode(self.crawlerLayer, forKey: "crawlers")
    }
}

class gameStatistics: NSObject, NSCoding {
    //General Game stats
    var gamesPlayed:Int = 0
    var gamesWon:Int = 0
    var gamesWonPercent:NSDecimalNumber = 0
    
    var gamesLost:Int = 0
    var gamesLostPercent:NSDecimalNumber = 0
    
    var assassinations:Int = 0
    var assassinationsPercent:NSDecimalNumber = 0
    
    var elevators:Int = 0
    var elevatorsPercent:NSDecimalNumber = 0
    
    var cratersControlled:Int = 0
    
    //Units destroyed
    var landShips:Int = 0
    var extractors:Int = 0
    var crawlers:Int = 0
    
    //Provinces
    var provincesCaptured:Int = 0
    var provincesLost:Int = 0
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.gamesPlayed = Int(aDecoder.decodeCInt(forKey: "gamesPlayed"))
        self.gamesWon = Int(aDecoder.decodeCInt(forKey: "gamesWon"))
        self.gamesWonPercent = aDecoder.decodeObject(forKey: "gamesWonPercent") as! NSDecimalNumber
        self.gamesLost = Int(aDecoder.decodeCInt(forKey: "gamesLost"))
        self.gamesLostPercent = aDecoder.decodeObject(forKey: "gamesLostPercent") as! NSDecimalNumber
        
        self.assassinations = Int(aDecoder.decodeCInt(forKey: "assassinations"))
        self.assassinationsPercent = aDecoder.decodeObject(forKey: "assassinationsPercent") as! NSDecimalNumber
        
        self.elevators = Int(aDecoder.decodeCInt(forKey: "elevators"))
        self.elevatorsPercent = aDecoder.decodeObject(forKey: "elevatorsPercent") as! NSDecimalNumber
        
        self.cratersControlled = Int(aDecoder.decodeCInt(forKey: "cratersControlled"))
        self.landShips = Int(aDecoder.decodeCInt(forKey: "landShips"))
        self.extractors = Int(aDecoder.decodeCInt(forKey: "extractors"))
        self.crawlers = Int(aDecoder.decodeCInt(forKey: "crawlers"))
        
        self.provincesCaptured = Int(aDecoder.decodeCInt(forKey: "provincesCaptured"))
        self.provincesLost = Int(aDecoder.decodeCInt(forKey: "provincesLost"))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.gamesPlayed, forKey: "gamesPlayed")
        aCoder.encode(self.gamesWon, forKey: "gamesWon")
        aCoder.encode(self.gamesWonPercent, forKey: "gamesWonPercent")
        aCoder.encode(self.gamesLost, forKey: "gamesLost")
        aCoder.encode(self.gamesLostPercent, forKey: "gamesLostPercent")

        aCoder.encode(self.assassinations, forKey: "assassinations")
        aCoder.encode(self.assassinationsPercent, forKey: "assassinationsPercent")
        
        aCoder.encode(self.elevators, forKey: "elevators")
        aCoder.encode(self.elevatorsPercent, forKey: "elevatorsPercent")
        
        aCoder.encode(self.provincesLost, forKey: "provincesLost")
        aCoder.encode(self.landShips, forKey: "landShips")
        aCoder.encode(self.extractors, forKey: "extractors")
        aCoder.encode(self.crawlers, forKey: "crawlers")
        
        aCoder.encode(self.cratersControlled, forKey: "cratersControlled")
        aCoder.encode(self.provincesCaptured, forKey: "provincesCaptured")
    }
}

class gameSettings: NSObject, NSCoding {
    //MainScreen
    var totalPlayers:Int = 4
    var gamePlayers:Array<Player> = []
    var gameDifficulty:String = "easy"
    
    ///Dice options screen
    var sidesPerDice:Int = 6
    var diceAdvantageMode:String = "attacker"
    
    ///Card options screen
    var cardBonusMode:String = "constant"
    var disableAsteroidCard:Bool = false
    
    ///Combat options screen
    var combatAdvantageMode:String = "equal"
    var enableTotalAnnihilation:Bool = false
    
    ///Start Position options screen
    var startPositionMode:String = "custom"
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.totalPlayers = Int(aDecoder.decodeInt32(forKey: "numberOfPlayers"))
        self.gamePlayers = aDecoder.decodeObject(forKey: "gamePlayers") as! Array<Player>
    
        self.gameDifficulty = aDecoder.decodeObject(forKey: "gameDifficulty") as! String
        
        self.sidesPerDice = Int(aDecoder.decodeInt32(forKey: "sidesPerDice"))
        self.diceAdvantageMode = aDecoder.decodeObject(forKey: "diceAdvantageMode") as! String
        
        self.cardBonusMode = aDecoder.decodeObject(forKey: "cardBonusMode") as! String
        self.disableAsteroidCard = aDecoder.decodeBool(forKey: "disableAsteroidCard")
        
        self.combatAdvantageMode = aDecoder.decodeObject(forKey: "combatAdvantageMode") as! String
        self.enableTotalAnnihilation = aDecoder.decodeBool(forKey: "enableTotalAnnihilation")
        
        self.startPositionMode = aDecoder.decodeObject(forKey: "startPositionsMode") as! String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Int32(self.totalPlayers), forKey: "numberOfPlayers")
        aCoder.encode(self.gamePlayers, forKey: "gamePlayers")
        aCoder.encode(self.gameDifficulty, forKey: "gameDifficulty")
        aCoder.encode(Int32(self.sidesPerDice), forKey: "sidesPerDice")
        aCoder.encode(self.diceAdvantageMode, forKey: "diceAdvantageMode")
        aCoder.encode(self.cardBonusMode, forKey: "cardBonusMode")
        aCoder.encode(self.disableAsteroidCard, forKey: "disableAsteroidCard")
        aCoder.encode(self.combatAdvantageMode, forKey: "combatAdvantageMode")
        aCoder.encode(self.enableTotalAnnihilation, forKey: "enableTotalAnnihilation")
        aCoder.encode(self.startPositionMode, forKey: "startPositionsMode")
        
    }
    
}



