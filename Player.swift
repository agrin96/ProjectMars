//
//  Player.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/4/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import SpriteKit

/// Represents a player in the game and associated information.
class Player: SKNode{
    var color:SKColor!       //The color of the player
    var playerName:String!         //A name of a player
    var chosenLandShip:landship!
    var chosenExtractor:extractor!
    
    var isPlayerHuman:Bool = true    //If true, human player, if false, computer
    var hasStartAssigned:Bool = false
    var isCurrentlyActive:Bool = false
    var hasDeployedCrawlers:Bool = true
    var isAlive:Bool = true
    
    var builtExtractorProvinces:Array<Province> = []
    var mineralsCollected:Int = 100 //12 base
    var mineralsBeingCollected:Int = 0
    var unitsBeingBuilt:Int = 0
    
    override init(){
        super.init()
        self.color = SKColor.clear
        self.name = String("Player1")
        self.isPlayerHuman = false
    }
    
    convenience init(color: SKColor, Name: String){
        self.init()
        
        self.name = "player"
        self.playerName = Name
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.color = aDecoder.decodeObject(forKey: "color") as? SKColor
        self.playerName = aDecoder.decodeObject(forKey: "playerName") as? String
        self.chosenLandShip = aDecoder.decodeObject(forKey: "chosenLandShip") as? landship
        self.chosenExtractor = aDecoder.decodeObject(forKey: "chosenExtractor") as? extractor
        
        self.isPlayerHuman = aDecoder.decodeBool(forKey: "isPlayerHuman")
        self.hasStartAssigned = aDecoder.decodeBool(forKey: "hasStartAssigned")
        self.isCurrentlyActive = aDecoder.decodeBool(forKey: "isCurrentlyActive")
        self.isAlive = aDecoder.decodeBool(forKey: "isAlive")
        
        self.builtExtractorProvinces = (aDecoder.decodeObject(forKey: "builtExtractors") as? Array<Province>)!
        self.mineralsCollected = aDecoder.decodeInteger(forKey: "collected")
        self.mineralsBeingCollected = aDecoder.decodeInteger(forKey: "beingCollected")
        self.unitsBeingBuilt = aDecoder.decodeInteger(forKey: "beingBuilt")
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.color, forKey: "color")
        aCoder.encode(self.playerName, forKey: "playerName")
        aCoder.encode(self.chosenLandShip, forKey: "chosenLandShip")
        aCoder.encode(self.chosenExtractor, forKey: "chosenExtractor")
        
        aCoder.encode(self.isPlayerHuman, forKey: "isPlayerHuman")
        aCoder.encode(self.hasStartAssigned, forKey: "hasStartAssigned")
        aCoder.encode(self.isCurrentlyActive, forKey: "isCurrentlyActive")
        aCoder.encode(self.isAlive, forKey: "isAlive")
        
        aCoder.encode(self.builtExtractorProvinces, forKey: "builtExtractors")
        aCoder.encode(self.mineralsCollected, forKey: "collected")
        aCoder.encode(self.mineralsBeingCollected, forKey: "beingCollected")
        aCoder.encode(self.unitsBeingBuilt, forKey: "biengBuilt")
    }
}
