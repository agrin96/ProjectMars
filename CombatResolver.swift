//
//  CombatResolver.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/21/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class unitCombatStats: NSObject, NSCoding{
    var hitPoints:Int!          //How many hits your unit can take before dying
    var currentHitPoints:Int!   //If there are modifiers, this is the current life of the unit
    
    var attackPower:Int!        //How much damage it does on attack actions
    var currentAttackPower:Int!
    
    var defensePower:Int!       //How much damage it does on defense actions
    var currentDefensePower:Int!
    
    var movementPoints:Int!
    override init(){
        self.hitPoints = 1
        self.attackPower = 1
        self.defensePower = 1
        self.movementPoints = 1
        
        self.currentHitPoints = self.hitPoints
        self.currentAttackPower = self.attackPower
        self.currentDefensePower = self.defensePower
    }
    
    func setForLandShip(){
        self.hitPoints = 16
        self.attackPower = 2
        self.defensePower = 2
        self.movementPoints = 1
        
        self.currentHitPoints = self.hitPoints
        self.currentAttackPower = self.attackPower
        self.currentDefensePower = self.defensePower
    }
    
    func setForExtractor(){
        self.hitPoints = 6
        self.attackPower = 0
        self.defensePower = 2
        self.movementPoints = 0
        
        self.currentHitPoints = self.hitPoints
        self.currentAttackPower = self.attackPower
        self.currentDefensePower = self.defensePower
    }
    
    func setForCrawler(){
        self.hitPoints = 2
        self.attackPower = 1
        self.defensePower = 1
        self.movementPoints = 1
        
        self.currentHitPoints = self.hitPoints
        self.currentAttackPower = self.attackPower
        self.currentDefensePower = self.defensePower
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.hitPoints, forKey: "hitpoints")
        aCoder.encode(self.attackPower, forKey: "attack")
        aCoder.encode(self.defensePower, forKey: "defense")
        aCoder.encode(self.movementPoints, forKey: "movement")
        aCoder.encode(self.currentHitPoints, forKey: "cHitpoints")
        aCoder.encode(self.currentAttackPower, forKey: "cAttack")
        aCoder.encode(self.currentDefensePower, forKey: "cMovement")
    }
    required init?(coder aDecoder: NSCoder) {
        self.hitPoints = aDecoder.decodeObject(forKey: "hitpoints") as? Int
        self.attackPower = aDecoder.decodeObject(forKey: "attack") as? Int
        self.defensePower = aDecoder.decodeObject(forKey: "defense") as? Int
        self.movementPoints = aDecoder.decodeObject(forKey: "movement") as? Int
        self.currentHitPoints = aDecoder.decodeObject(forKey: "cHitpoints") as? Int
        self.currentAttackPower = aDecoder.decodeObject(forKey: "cAttack") as? Int
        self.currentDefensePower = aDecoder.decodeObject(forKey: "cMovement") as? Int
    }
}

class combatInformation: NSObject, NSCoding {
    var primaryAttacker:AnyObject?
    var attackingProvince:Province?
    var defendingProvince:Province?
    
    override init(){
        self.primaryAttacker = nil
        self.attackingProvince = nil
        self.defendingProvince = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.primaryAttacker = aDecoder.decodeObject(forKey: "primary") as AnyObject
        self.attackingProvince = aDecoder.decodeObject(forKey: "attacker") as? Province
        self.defendingProvince = aDecoder.decodeObject(forKey: "defending") as? Province
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.primaryAttacker, forKey: "primary")
        aCoder.encode(self.attackingProvince, forKey: "attacker")
        aCoder.encode(self.defendingProvince, forKey: "defender")
    }
}

class combatResolver: NSObject, NSCoding{
    var combatSettings:gameSettings!
    var combatToResolve:combatInformation!
    
    var hasResolvedCombat:Bool = true
    
    var currentAttacker:AnyObject?
    var currentDefender:AnyObject?
    
    
    init(settingsToUse: gameSettings){
        super.init()
        self.combatSettings = settingsToUse
    }
    
    func resolveCurrentCombat(for player:Player, resolveAll: Bool){
        if resolveAll == false{
            let attackingUnits = self.getUnit(for: self.combatToResolve.attackingProvince!)
            let defendingUnits = self.getUnit(for: self.combatToResolve.defendingProvince!)
            
            /// Only one attacker at a time. So we obtain the attacking unit.
            for unit in attackingUnits {
                if unit != nil {
                    if self.checkCombatState(for: unit!) != nil {
                         self.currentAttacker = self.checkCombatState(for: unit!)
                    }
                }
            }
            getDefender: for unit in defendingUnits {
                if unit != nil {
                    if self.currentDefender == nil {
                        self.currentDefender = unit
                    }else if self.currentDefender is landship{
                        //Landships should be last thing that defends, after crawlers and extractors
                        if (self.currentDefender as! landship).combatStats.currentHitPoints <= 0{
                            self.currentDefender = unit
                        }else{
                            if unit is crawler || unit is extractor{
                                self.currentDefender = unit
                            }
                        }
                    }else if self.currentDefender is extractor{
                        if (self.currentDefender as! extractor).combatStats.currentHitPoints <= 0{
                            self.currentDefender = unit
                        }else{
                            if unit is crawler {
                                //The default defense unit should be a crawler
                                self.currentDefender = unit
                                break getDefender
                            }
                        }
                    }else if self.currentDefender is crawler {
                        if (self.currentDefender as! crawler).combatStats.currentHitPoints <= 0{
                            self.currentDefender = unit
                        }
                    }
                }
            }
            if self.combatHasEnded() == true {
                return
            }
            
            self.combatResolutionFor(attacker: self.currentAttacker!, defender: self.currentDefender!)
            self.currentDefender = nil
            
            if self.combatToResolve.defendingProvince?.hasCrawlers == false &&
                self.combatToResolve.defendingProvince?.hasLandShip == false &&
                self.combatToResolve.defendingProvince?.hasExtractor == false {
                do {
                    let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                    switch self.currentAttacker {
                    case _ as landship:
                        (scene as! GameScene).GameLoop.movementHandler.handleMovement(from: self.combatToResolve.attackingProvince!, to: self.combatToResolve.defendingProvince!, for: self.currentAttacker!, and: player)
                        break
                    case _ as crawler:
                        (scene as! GameScene).GameLoop.movementHandler.handleMovement(from: self.combatToResolve.attackingProvince!, to: self.combatToResolve.defendingProvince!, for: self.currentAttacker!, and: player)
                        break
                    default:
                        break
                    }
                }catch { print("Error in CombatResolver")}
                self.currentAttacker = nil
                _ = self.combatHasEnded()
                
            }else if self.combatToResolve.attackingProvince?.hasCrawlers == false &&
                self.combatToResolve.attackingProvince?.hasLandShip == false {
                _ = self.combatHasEnded()
            }else{
                self.currentAttacker = nil
            }
        }else if resolveAll == true{
            let attackingUnits = self.getUnit(for: self.combatToResolve.attackingProvince!)
            /// Only one attacker at a time. So we obtain the attacking unit.
            for unit in attackingUnits {
                if unit != nil {
                    if self.checkCombatState(for: unit!) != nil {
                        self.currentAttacker = self.checkCombatState(for: unit!)
                    }
                }
            }
            repeat {
                let defendingUnits = self.getUnit(for: self.combatToResolve.defendingProvince!)
                
                getDefender: for unit in defendingUnits {
                    if unit != nil {
                        if self.currentDefender == nil {
                            self.currentDefender = unit
                        }else if self.currentDefender is landship{
                            //Landships should be last thing that defends, after crawlers and extractors
                            if (self.currentDefender as! landship).combatStats.currentHitPoints <= 0{
                                self.currentDefender = unit
                            }else{
                                if unit is crawler || unit is extractor{
                                    self.currentDefender = unit
                                }
                            }
                        }else if self.currentDefender is extractor{
                            if (self.currentDefender as! extractor).combatStats.currentHitPoints <= 0{
                                self.currentDefender = unit
                            }else{
                                if unit is crawler {
                                    //The default defense unit should be a crawler
                                    self.currentDefender = unit
                                    break getDefender
                                }
                            }
                        }else if self.currentDefender is crawler {
                            if (self.currentDefender as! crawler).combatStats.currentHitPoints <= 0{
                                self.currentDefender = unit
                            }
                        }
                    }
                }
                if self.combatHasEnded() == true {
                    return
                }
                
                self.combatResolutionFor(attacker: self.currentAttacker!, defender: self.currentDefender!)
                
                if self.combatToResolve.defendingProvince?.hasCrawlers == false &&
                    self.combatToResolve.defendingProvince?.hasLandShip == false &&
                    self.combatToResolve.defendingProvince?.hasExtractor == false {
                    self.currentDefender = nil
                    do{
                        let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                        switch self.currentAttacker {
                        case _ as landship:
                            (scene as! GameScene).GameLoop.movementHandler.handleMovement(from: self.combatToResolve.attackingProvince!, to: self.combatToResolve.defendingProvince!, for: self.currentAttacker!, and: player)
                            break
                        case _ as crawler:
                            (scene as! GameScene).GameLoop.movementHandler.handleMovement(from: self.combatToResolve.attackingProvince!, to: self.combatToResolve.defendingProvince!, for: self.currentAttacker!, and: player)
                            break
                        default:
                            break
                        }
                        self.currentAttacker = nil
                        if self.combatHasEnded() == true{
                            return
                        }
                    }catch { print("Error in CombatResolver") }
                    
                }else if self.combatToResolve.attackingProvince?.hasCrawlers == false &&
                    self.combatToResolve.attackingProvince?.hasLandShip == false {
                    self.currentAttacker = nil
                        if self.combatHasEnded() == true {
                            return
                        }
                }
            }while combatHasEnded() == false
            
        }
        
    }
    
    func combatResolutionFor(attacker: AnyObject, defender: AnyObject){
        let attackerRoll:Int = rollDice(attacking: true)
        let defenderRoll:Int = rollDice(attacking: false)
        var attackerWon:Bool?   //true means attacker, false means defender, nil is neither
        
        do { try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.displayCurrentRolls(for: attackerRoll, defenderRoll: defenderRoll) }
        catch{ print("Error in CombatResolutionFor") }
        
        if self.combatSettings.diceAdvantageMode == "attacker" {
            if attackerRoll >= defenderRoll{
                attackerWon = true
            }else{
                attackerWon = false
            }
        }else if self.combatSettings.diceAdvantageMode == "defender"{
            if attackerRoll <= defenderRoll {
                attackerWon = false
            }else{
                attackerWon = true
            }
        }else if self.combatSettings.diceAdvantageMode == "equal"{
            if attackerRoll == defenderRoll {
                attackerWon = nil
            }else if attackerRoll > defenderRoll {
                attackerWon = true
            }else{
                attackerWon = false
            }
        }
        
        self.distributeDamage(for: attackerWon, attacker: attacker, defender: defender)
    }
    
    func combatHasEnded() -> Bool{
        do {
            if self.currentAttacker == nil || self.currentDefender == nil{
                try gameState.sharedInstance().GameBoard.boardMap.enumerateChildNodes(withName: "AttackArrow", using: {
                    node, stop in
                    if node.parent != nil {
                        node.removeFromParent()
                    }else{
                        stop[0] = true
                    }
                })
                for ship in try (gameState.sharedInstance().GameBoard.landShipLayer.children) {
                    if (ship as! landship).attackState != nil {
                        (ship as! landship).attackState = nil
                    }
                }
                for crawler in try (gameState.sharedInstance().GameBoard.crawlerLayer.children) {
                    if (crawler as! crawler).attackState != nil {
                        (crawler as! crawler).attackState = nil
                    }
                }
                try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.clearAttackButtons()
                try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.clearCombatInformation()
                let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                (scene as! GameScene).GameLoop.movementHandler.resetAttackingOrder()
                return true
            }else{
                return false
            }
        }catch { print("Error in CombatResolutionFor") }
        return true
    }
    
    private func distributeDamage(for state: Bool?, attacker: AnyObject, defender: AnyObject){
        do{
            //Attacker Won
            if state == true{
                switch attacker {
                case let Aunit as landship:
                    switch defender {
                    case let Dunit as landship:
                        
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            //YOU LOSE THE GAME
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Dunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{ try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove) } catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Dunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as crawler:
                        var i:Int = 0;
                        
                        while i != Aunit.combatStats.attackPower! {
                            Dunit.combatStats.currentHitPoints! -= 1    //Calculate Damage
                            
                            if (Dunit.combatStats.currentHitPoints! % 2 ) <= 0 {
                                Dunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Dunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Dunit.position{
                                            prov.hasCrawlers = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }
                            }
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                            i += 1  //Increment Damage Counter
                        }
                        break
                    case let Dunit as extractor:
                        
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            for person in self.combatSettings.gamePlayers {
                                var index = 0
                                for location in person.builtExtractorProvinces{
                                    if Dunit.extractorSprite.position == location.extractorPosition{
                                        person.builtExtractorProvinces.remove(at: index)
                                    }
                                    index += 1
                                }
                            }
                            for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                if prov.extractorPosition == Dunit.extractorSprite.position{
                                    prov.hasExtractor = false
                                }
                            }
                            Dunit.removeFromParent()
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    default:
                        break
                    }
                    break
                case let Aunit as crawler:
                    switch defender {
                    case let Dunit as landship:
                        
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            //YOU LOSE THE GAME
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Dunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{ try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove) }catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Dunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as crawler:
                        var i:Int = 0;
                        
                        while i != Aunit.combatStats.attackPower! {
                            Dunit.combatStats.currentHitPoints! -= 1    //Calculate Damage
                            
                            if (Dunit.combatStats.currentHitPoints! % 2 ) <= 0 {
                                Dunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Dunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Dunit.position{
                                            prov.hasCrawlers = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }
                            }
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                            i += 1  //Increment Damage Counter
                        }
                        break
                    case let Dunit as extractor:
                        
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            for person in self.combatSettings.gamePlayers {
                                var index = 0
                                for location in person.builtExtractorProvinces{
                                    if Dunit.extractorSprite.position == location.extractorPosition{
                                        person.builtExtractorProvinces.remove(at: index)
                                    }
                                    index += 1
                                }
                            }
                            for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                if prov.extractorPosition == Dunit.extractorSprite.position{
                                    prov.hasExtractor = false
                                }
                            }
                            Dunit.removeFromParent()
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    default:
                        break
                    }
                default:
                    break
                }
            }
                
                
                
                //Defender Won
            else if state == false{
                switch attacker {
                case let Aunit as landship:
                    switch defender {
                    case let Dunit as landship:
                        Aunit.combatStats.currentHitPoints! -= Dunit.combatStats.defensePower!
                        if Aunit.combatStats.currentHitPoints! <= 0 {
                            //YOU LOSE THE GAME
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Aunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{
                                            let scene =  try gameState.sharedInstance().GameBoard.boardMap.scene
                                            (scene as! GameScene).GameLoop.handleEndTurnPress(completion: {() in
                                                do{ try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove) }
                                                catch{ print("Error in CombatResolver") }
                                            })
                                        }catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Aunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as crawler:

                        Aunit.combatStats.currentHitPoints! -= Dunit.combatStats.defensePower!
                        if Aunit.combatStats.currentHitPoints! <= 0 {
                            
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Aunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{
                                            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                                            (scene as! GameScene).GameLoop.handleEndTurnPress(completion:  { })
                                            try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove)
                                        }catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Aunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as extractor:
                        Aunit.combatStats.currentHitPoints! -= Dunit.combatStats.defensePower!
                        if Aunit.combatStats.currentHitPoints! <= 0 {
                            
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Aunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{
                                            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                                            (scene as! GameScene).GameLoop.handleEndTurnPress(completion: {() in
                                                do{ try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove)}catch{ print("Error in CombatResolver") }
                                            })
                                        }catch{ print("Error in CombatResolver") }
                                    })

                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Aunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    default:
                        break
                    }
                    break
                case let Aunit as crawler:
                    switch defender {
                    case let Dunit as landship:
                        var i:Int = 0
                        
                        while i != Dunit.combatStats.currentDefensePower! {
                            Aunit.combatStats.currentHitPoints! -= 1
                            if (Aunit.combatStats.currentHitPoints! % 2) <= 0 {
                                Aunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Aunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Aunit.position{
                                            prov.hasCrawlers = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }
                            }
                            i += 1
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as crawler:
                        var i:Int = 0
                        
                        while i != Dunit.combatStats.currentDefensePower! {
                            Aunit.combatStats.currentHitPoints! -= 1
                            if (Aunit.combatStats.currentHitPoints! % 2) <= 0 {
                                Aunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Aunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Aunit.position{
                                            prov.hasCrawlers = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }
                            }
                            i += 1
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as extractor:
                        var i:Int = 0
                        
                        while i != Dunit.combatStats.currentDefensePower! {
                            Aunit.combatStats.currentHitPoints! -= 1
                            if (Aunit.combatStats.currentHitPoints! % 2) <= 0 {
                                Aunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Aunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Aunit.position{
                                            prov.hasCrawlers = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }
                            }
                            i += 1
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    default:
                        break
                    }
                default:
                    break
                }
            }//Tie
            else if state == nil{
                switch attacker {
                case let Aunit as landship:
                    switch defender {
                    case let Dunit as landship:
                        Aunit.combatStats.currentHitPoints! -= Dunit.combatStats.currentDefensePower!
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        if Aunit.combatStats.currentHitPoints! <= 0 {
                            //YOU LOSE THE GAME
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Aunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{ try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove)}
                                        catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Aunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            //YOU LOSE THE GAME
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Dunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{
                                            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                                            (scene as! GameScene).GameLoop.handleEndTurnPress(completion: { })
                                            try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove)
                                        }catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Dunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as crawler:
                        Aunit.combatStats.currentHitPoints! -= Dunit.combatStats.currentDefensePower!
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        if Aunit.combatStats.currentHitPoints! <= 0 {
                            
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Aunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{
                                            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                                            (scene as! GameScene).GameLoop.handleEndTurnPress(completion: { })
                                            try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove)
                                        }catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Aunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        var i:Int = 0;
                        while i != Aunit.combatStats.attackPower! {
                            Dunit.combatStats.currentHitPoints! -= 1    //Calculate Damage
                            
                            if (Dunit.combatStats.currentHitPoints! % 2 ) <= 0 {
                                Dunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Dunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Dunit.position{
                                            prov.hasCrawlers = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }
                            }
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                            i += 1  //Increment Damage Counter
                        }
                        break
                    case let Dunit as extractor:
                        Aunit.combatStats.currentHitPoints! -= Dunit.combatStats.currentDefensePower!
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        if Aunit.combatStats.currentHitPoints! <= 0 {
                            
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Aunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{
                                            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                                            (scene as! GameScene).GameLoop.handleEndTurnPress(completion: { })
                                            try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove)
                                        }catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Aunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            for person in self.combatSettings.gamePlayers {
                                var index = 0
                                for location in person.builtExtractorProvinces{
                                    if Dunit.extractorSprite.position == location.extractorPosition{
                                        person.builtExtractorProvinces.remove(at: index)
                                    }
                                    index += 1
                                }
                            }
                            for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                if prov.extractorPosition == Dunit.extractorSprite.position{
                                    prov.hasExtractor = false
                                }
                            }
                            Dunit.removeFromParent()
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    default:
                        break
                    }
                    break
                case let Aunit as crawler:
                    switch defender {
                    case let Dunit as landship:
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        
                        var i:Int = 0
                        
                        while i != Dunit.combatStats.currentDefensePower! {
                            Aunit.combatStats.currentHitPoints! -= 1
                            if (Aunit.combatStats.currentHitPoints! % 2) <= 0 {
                                Aunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Aunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Aunit.position{
                                            prov.hasCrawlers = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }
                            }
                            i += 1
                        }
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            //YOU LOSE THE GAME
                            var indexToRemove:Int!
                            var index = 0
                            for person in self.combatSettings.gamePlayers {
                                if person.color == Dunit.landShipSprite.color {
                                    indexToRemove = index
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                        do{
                                            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                                            (scene as! GameScene).GameLoop.handleEndTurnPress(completion: { })
                                            try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove)
                                        }catch{ print("Error in CombatResolver") }
                                    })
                                    
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.landShipPosition == Dunit.landShipSprite.position{
                                            prov.hasLandShip = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }else{
                                    index += 1
                                }
                            }
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as crawler:
                        var i:Int = 0;
                        
                        while i != Dunit.combatStats.currentDefensePower! {
                            Aunit.combatStats.currentHitPoints! -= 1
                            if (Aunit.combatStats.currentHitPoints! % 2) <= 0 {
                                Aunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Aunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Aunit.position{
                                            prov.hasCrawlers = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }
                            }
                            i += 1
                        }
                        i = 0;  //Reset Counter
                        while i != Aunit.combatStats.attackPower! {
                            Dunit.combatStats.currentHitPoints! -= 1    //Calculate Damage
                            
                            if (Dunit.combatStats.currentHitPoints! % 2 ) <= 0 {
                                Dunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Dunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Dunit.position{
                                            prov.hasCrawlers = false
                                        }
                                    }
                                    Dunit.removeFromParent()
                                }
                            }
                            i += 1  //Increment Damage Counter
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    case let Dunit as extractor:
                        Dunit.combatStats.currentHitPoints! -= Aunit.combatStats.attackPower!
                        
                        var i:Int = 0
                        
                        while i != Dunit.combatStats.currentDefensePower! {
                            Aunit.combatStats.currentHitPoints! -= 1
                            if (Aunit.combatStats.currentHitPoints! % 2) <= 0 {
                                Aunit.addCrawlersToStack(numberOfCrawlers: -1)
                                if Int(Aunit.crawlerNumber.text!)! <= 0 {
                                    for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == Aunit.position{
                                            prov.hasCrawlers = false
                                            self.currentAttacker = nil
                                        }
                                    }
                                    Aunit.removeFromParent()
                                }
                            }
                            i += 1
                        }
                        if Dunit.combatStats.currentHitPoints! <= 0 {
                            for person in self.combatSettings.gamePlayers {
                                var index = 0
                                for location in person.builtExtractorProvinces{
                                    if Dunit.extractorSprite.position == location.extractorPosition{
                                        person.builtExtractorProvinces.remove(at: index)
                                    }
                                    index += 1
                                }
                            }
                            for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                                if prov.extractorPosition == Dunit.extractorSprite.position{
                                    prov.hasExtractor = false
                                }
                            }
                            Dunit.removeFromParent()
                        }
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: Aunit.combatStats, and: Dunit.combatStats)
                        break
                    default:
                        break
                    }
                    break
                default:
                    break
                }
            }
        }catch{ print("Error in CombatResolver") }
    }
    
    /// We roll the dice and return the amount rolled. as a cummulative value of all the rolled dice.
    private func rollDice(attacking: Bool) -> Int{
        let numberOfSides = self.combatSettings.sidesPerDice
        var roll:Int = 0
        
        /// First determine the number of dice each player is using.
        var numberOfDice:Int = 2
        if self.combatSettings.combatAdvantageMode == "equal" {
            numberOfDice = 2
        }else if self.combatSettings.combatAdvantageMode == "attacker" {
            if attacking == true{
                numberOfDice = 2
            }else{
                numberOfDice = 1
            }
        }else if self.combatSettings.combatAdvantageMode == "defender" {
            if attacking == true {
                numberOfDice = 2
            }else{
                numberOfDice = 3
            }
        }
        
        /// Second, run the roll based on the dice mode.
        if attacking == true {
            for _ in 0..<numberOfDice {
                roll += Int.random(range: 1...numberOfSides)
            }
        }else{
            for _ in 0..<numberOfDice {
                roll += Int.random(range: 1...numberOfSides)
            }
        }
        
        return roll
    }
    
    /// Check which type of unit is attacking.
    private func checkCombatState(for unit: AnyObject) -> AnyObject? {
        if unit is landship {
            if (unit as! landship).attackState?.attacking == true {
                return unit
            }
        }
        if unit is crawler {
            if (unit as! crawler).attackState?.attacking == true {
                return unit
            }
        }
        return nil
    }
    
    private func getUnit(for province: Province) -> Array<AnyObject?>{
        var unitsToReturn:Array<AnyObject?> = [nil, nil, nil]
        do{
            if province.hasLandShip {
                for ship in try (gameState.sharedInstance().GameBoard.landShipLayer.children) {
                    if (ship as! landship).landShipSprite.position == province.landShipPosition {
                        unitsToReturn[0] = (ship as! landship)
                    }
                }
            }
            if province.hasCrawlers {
                for piece in try (gameState.sharedInstance().GameBoard.crawlerLayer.children) {
                    if (piece as! crawler).position == province.extractorPosition {
                        unitsToReturn[1] = (piece as! crawler)
                    }
                }
            }
            if province.hasExtractor {
                for piece in try (gameState.sharedInstance().GameBoard.extractorLayer.children) {
                    if (piece as! extractor).extractorSprite.position == province.extractorPosition {
                        unitsToReturn[2] = (piece as! extractor)
                    }
                }
            }
        }catch{ print("Error in getUnit") }
        return unitsToReturn
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.combatSettings, forKey: "combatSettings")
        aCoder.encode(self.combatToResolve, forKey: "toResolve")
        aCoder.encode(self.hasResolvedCombat, forKey: "hasResolved")
        aCoder.encode(self.currentAttacker, forKey: "attacker")
        aCoder.encode(self.currentDefender, forKey: "defender")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.combatSettings = aDecoder.decodeObject(forKey: "combatSettings") as? gameSettings!
        self.combatToResolve = aDecoder.decodeObject(forKey: "toResolve") as? combatInformation
        self.hasResolvedCombat = aDecoder.decodeBool(forKey: "hasResolved")
        self.currentAttacker = aDecoder.decodeObject(forKey: "attacker") as AnyObject
        self.currentDefender = aDecoder.decodeObject(forKey: "defender") as AnyObject
    }
}
