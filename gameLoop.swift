//
//  gameLoop.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/21/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

//Main Game loop
class gameLoop:NSObject, NSCoding {
    var isUpdatingStatistics:Bool = false
    var settingsInstance:gameSettings!
    var statisticsInstance:gameStatistics!
    var isGameStarted:Bool = false
    var movementHandler:movement!
    
    var currentPlayerActive:Player!
    
    /// These two variable are used in differntiating user input ( whether we are panning camera or moving unit)
    var selectedNode:AnyObject!
    var compoundedDistance:CGPoint = CGPoint(x:0,y:0)
    
    var combatComputer:combatResolver!
    var numberOfturnsProgress:Int = 0
    var crawlersPerFactory:Int = 1
    var crawlerDeployAmount:Int = 1
    
    
    override init() {
        super.init()
        do {
            if try gameState.sharedInstance().isGameInProgress != true{
                self.importGameState()
                self.movementHandler = movement()
                self.combatComputer = combatResolver(settingsToUse: self.settingsInstance)
            }
        }catch { print("Error in gameloop init") }
    }
    
    func runGame(){
        if self.settingsInstance.gamePlayers[0].hasStartAssigned == true {
            loop: for player in self.settingsInstance.gamePlayers{
                if player.isPlayerHuman == true {
                    player.isCurrentlyActive = true
                    self.currentPlayerActive = player
                    do {
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.updateTurnCounter(for: self.currentPlayerActive, completion: { })
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.updateMiniMap()
                    }catch { print("Error in runGame") }
                    break loop
                }
            }
        }
        self.isGameStarted = true
    }
    
    
    /// This functino handles checking if provinces are adjacent. Landships cannot move between non adjacent provinces.
    ///
    /// - Parameters:
    ///   - origin: The origin province of the landship.
    ///   - destination: The destination chosen by the player.
    func checkProvinceAdjacency(for origin: Province, and destination: Province){
        let originPath = UIBezierPath(cgPath: origin.tapOutline.path!)
        let destinationPath = UIBezierPath(cgPath: destination.tapOutline.path!)
        
        var originPoints:Array<CGPoint> = []
        var destinationPoints:Array<CGPoint> = []
        
        for point in originPath {
            if point.getValue().0 != nil {
                originPoints.append(point.getValue().start!)
            }
        }
        for point in destinationPath {
            if point.getValue().0 != nil {
                destinationPoints.append(point.getValue().start!)
            }
        }
        
        var lowestDistance:CGFloat = 100
        for oPoint in originPoints {
            for dPoint in destinationPoints {
                let currentDistance = distanceBetweenPoints(start: oPoint, end: dPoint)
                if currentDistance < lowestDistance {
                    lowestDistance = currentDistance
                }
            }
        }
        
        if lowestDistance < 10 {
            
            //Reset attacking
            self.movementHandler.hasCompletedMove = true
            self.movementHandler.combatMovement.primaryAttacker = nil
            self.movementHandler.combatMovement.defendingProvince = nil
            self.movementHandler.combatMovement.attackingProvince = nil
            self.movementHandler.handleMovement(from: origin, to: destination, for: self.selectedNode, and: self.currentPlayerActive)
        }else{
            let jitter = SKAction.sequence([SKAction.moveBy(x: 10, y: 0, duration: 0.05), SKAction.moveBy(x: -10, y: 0, duration: 0.05)])
            if selectedNode is crawler{
                self.selectedNode.run(SKAction.repeat(jitter, count: 3))
            }else if selectedNode is landship{
                (self.selectedNode as! landship).landShipSprite.run(SKAction.repeat(jitter, count: 3))
            }
        }
    
    }
    
    private func distanceBetweenPoints(start: CGPoint, end: CGPoint) -> CGFloat{
        return sqrt(pow(start.x - end.x, 2) + pow(start.y - end.y, 2))
    }
    
    /// This function handles creating an extractor on a valid tile when the user precess the overLayUI extractor button.
    ///
    /// - Parameter player: The player which is adding the extractor
    func handleExtractorButtonPress(for player: Player) -> (){
        do {
            for prov in (try gameState.sharedInstance().GameBoard.Provinces) {
                let node = (try gameState.sharedInstance().GameBoard.landShipLayer.childNode(withName: player.playerName!)) as? landship
                if node != nil && prov.hasExtractor == false{
                    if prov.landShipPosition == node?.landShipSprite.position && prov.isCratered == true {
                        if player.mineralsCollected >= 4 {
                            player.mineralsCollected -= 4
                            let newExtractor = player.chosenExtractor.getNodeCopy(andNameIt: player.playerName! + "Ext")
                            newExtractor.extractorSprite.size = CGSize(width: 70, height: 70)
                            newExtractor.modifySpawnPosition(position: prov.extractorPosition)
                            newExtractor.modifyColor(color: player.color, blendfactor: 0.3, blendMode: .alpha)
                            
                            player.builtExtractorProvinces.append(prov) //Add this extractor to the player data on their extractors
                            try gameState.sharedInstance().GameBoard.extractorLayer.addChild(newExtractor)
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: player)
                            prov.hasExtractor = true
                            if self.isUpdatingStatistics == true {
                                try gameState.sharedInstance().PlayerStats.cratersControlled += 1
                                try gameState.sharedInstance().PlayerStats.extractors += 1
                            }
                            return
                        }else{
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "Not Enough Resources", completion: { })
                            return
                        }
                    }
                }
            }
            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "Invalid Build Location", completion: { })
        }catch{print("Error in HandleExtractorButtonPress") }
    }
    
    
    /// This function handles dynamically drawing the movement line when a user is moving a unit. Called from panHandler.
    ///
    /// - Parameter destination: The point at which the person's finger is currently
    func drawDottedMoveLineTo(destination: CGPoint){
        do{
            if let node = try gameState.sharedInstance().GameBoard.boardMap.scene?.childNode(withName: "line") {
                node.removeFromParent()
            }
            let toMove = destination
            let selectLine = UIBezierPath()
            var startPoint:CGPoint!
            if self.selectedNode is crawler {
                startPoint = (self.selectedNode as! crawler).position
            }else if self.selectedNode is landship {
                startPoint = (self.selectedNode as! landship).landShipSprite!.position
            }
            
            self.compoundedDistance.x = self.compoundedDistance.x + toMove.x
            self.compoundedDistance.y = self.compoundedDistance.y - toMove.y
            
            selectLine.move(to: startPoint)
            selectLine.addLine(to: self.compoundedDistance)
            let pattern:Array<CGFloat> = [5.0, 5.0]
            let dashed = selectLine.cgPath.copy(dashingWithPhase: 2, lengths: pattern)
            
            let shapeNode = SKShapeNode(path: dashed)
            shapeNode.fillColor = self.currentPlayerActive.color
            shapeNode.strokeColor = self.currentPlayerActive.color
            shapeNode.lineWidth = 5.0
            shapeNode.name = "line"
            try gameState.sharedInstance().GameBoard.boardMap.scene?.addChild(shapeNode)
        }catch{ print("Error in drawDottedMoveLineTo") }
    }
    
    
    
    /// This function is called from tap handler when the HUD botton to end the turn is pressed. It advances the gameturn.
    func handleEndTurnPress(completion: @escaping ()->()){
        playerLoop: for n in 0..<self.settingsInstance.gamePlayers.count {
            if self.settingsInstance.gamePlayers[n].isCurrentlyActive == true {
                let players = self.settingsInstance.gamePlayers
                players[n].isCurrentlyActive = false
                
                do{
                    if n < players.count - 1 {
                        players[n + 1].isCurrentlyActive = true
                        let playerSprite = (try gameState.sharedInstance().GameBoard.landShipLayer.childNode(withName: players[n + 1].playerName!)) as? landship
                        
                        if playerSprite != nil {
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.updateTurnCounter(for: players[n + 1], completion: {() in
                                do { try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.displayCurrentStats(for: (playerSprite?.combatStats)!)
                                }catch{ print("Error in handleEndTurnPress") }
                            })
                            
                            try gameState.sharedInstance().GameBoard.boardCamera.run(SKAction.move(to: (playerSprite?.landShipSprite.position)!, duration: 0.5), completion: {() in
                                if (playerSprite?.combatStats.currentHitPoints)! < (playerSprite?.combatStats.hitPoints)! {
                                    playerSprite?.combatStats.currentHitPoints! += 1    //Heal the landship 1 per turn until max health
                                }
                                self.updateCrawlerCreation(for: players[n + 1])     //Recalculate number of crawlers
                                do{
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: players[n + 1])
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.setDeployButtonsBasedOn(player: players[n + 1])
                                    if players[n + 1].hasDeployedCrawlers == false {
                                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.disableNonCombatUI()   //Disable UI so player can only set down crawlers
                                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.enableCrawlerPlacementUI()
                                    }
                                }catch{ print("Error in handleEndTurnPress") }
                            })
                        }
                        
                        self.currentPlayerActive = players[n + 1]
                    }else{
                        players[0].isCurrentlyActive = true
                        let playerSprite = (try gameState.sharedInstance().GameBoard.landShipLayer.childNode(withName: players[0].playerName!)) as? landship
        
                        if playerSprite != nil{
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.updateTurnCounter(for: players[0], completion: {() in
                                do{ try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.displayCurrentStats(for: (playerSprite?.combatStats)!)
                                }catch{ print("Error in handleEndTurnPress") }
                            })
                            
                            try gameState.sharedInstance().GameBoard.boardCamera.run(SKAction.move(to: (playerSprite?.landShipSprite.position)!, duration: 0.5), completion: {() in
                                if (playerSprite?.combatStats.currentHitPoints)! < (playerSprite?.combatStats.hitPoints)! {
                                    playerSprite?.combatStats.currentHitPoints! += 1    //Heal the landship 1 per turn until max health
                                }
                                self.updateCrawlerCreation(for: players[0])         //Recalculate number of crawlers
                                do {
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: players[0])
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.setDeployButtonsBasedOn(player: players[0])
                                    if players[0].hasDeployedCrawlers == false {
                                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.disableNonCombatUI()   //Disable UI so player can only set down crawlers
                                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.enableCrawlerPlacementUI()
                                    }
                                }catch{print("Error in handleEndTurnPress")}
                            })
                        }
                        self.currentPlayerActive = players[0]
                    }
                }catch{ print("Error in handleEndTurnPress") }
                break playerLoop
            }
        }
        self.numberOfturnsProgress += 1
        completion()
    }
    
    func deployCrawler(for tapped: CGPoint){
        do{
            for prov in try (gameState.sharedInstance().GameBoard.Provinces) {
                if prov.tapOutline.contains(tapped) {
                    if prov.owningPlayer?.playerName == self.currentPlayerActive.playerName {
                        if self.currentPlayerActive.unitsBeingBuilt > 0{
                            
                            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                            if prov.hasCrawlers == true{
                                
                                let listOfCrawlers = try (gameState.sharedInstance().GameBoard.crawlerLayer.children) as? Array<crawler>
                                for unit in listOfCrawlers!{
                                    if prov.extractorPosition == unit.position{
                                        if self.crawlerDeployAmount == 1 {
                                            unit.addCrawlersToStack(numberOfCrawlers: 1)
                                            self.currentPlayerActive.unitsBeingBuilt -= 1
                                            (scene as! GameScene).animateCrawlerRocketLanding(to: prov.extractorPosition, color: prov.provinceImage.color, completion: { })
                                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.setDeployButtonsBasedOn(player: self.currentPlayerActive)
                                        }else if self.crawlerDeployAmount == 5 && self.currentPlayerActive.unitsBeingBuilt >= 5{
                                            unit.addCrawlersToStack(numberOfCrawlers: 5)
                                            self.currentPlayerActive.unitsBeingBuilt -= 5
                                            if self.currentPlayerActive.unitsBeingBuilt < 5 {
                                                self.crawlerDeployAmount = 1
                                                try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.setDeployButtonsBasedOn(player: self.currentPlayerActive)
                                            }
                                            (scene as! GameScene).animateCrawlerRocketLanding(to: prov.extractorPosition,color: prov.provinceImage.color, completion: { })
                                        }else if self.crawlerDeployAmount == 10000 && self.currentPlayerActive.unitsBeingBuilt >= 5{
                                            unit.addCrawlersToStack(numberOfCrawlers: self.currentPlayerActive.unitsBeingBuilt)
                                            self.currentPlayerActive.unitsBeingBuilt = 0
                                            (scene as! GameScene).animateCrawlerRocketLanding(to: prov.extractorPosition,color: prov.provinceImage.color, completion: { })
                                        }
                                    }
                                }
                            }else{
                                let newCrawler = crawler(player: self.currentPlayerActive)
                                newCrawler.position = prov.extractorPosition
                                prov.hasCrawlers = true
                                self.currentPlayerActive.unitsBeingBuilt -= 1
                                (scene as! GameScene).animateCrawlerRocketLanding(to: prov.extractorPosition,color: prov.provinceImage.color, completion: { })
                                    
                                if self.crawlerDeployAmount == 5 && self.currentPlayerActive.unitsBeingBuilt >= 4{
                                    newCrawler.addCrawlersToStack(numberOfCrawlers: 4)
                                    self.currentPlayerActive.unitsBeingBuilt -= 4
                                    if self.currentPlayerActive.unitsBeingBuilt < 5 {
                                        self.crawlerDeployAmount = 1
                                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.setDeployButtonsBasedOn(player: self.currentPlayerActive)
                                    }
                                    (scene as! GameScene).animateCrawlerRocketLanding(to: prov.extractorPosition,color: prov.provinceImage.color, completion: { })
                                }else if self.crawlerDeployAmount == 10000 && self.currentPlayerActive.unitsBeingBuilt >= 5{
                                    newCrawler.addCrawlersToStack(numberOfCrawlers: self.currentPlayerActive.unitsBeingBuilt)
                                    self.currentPlayerActive.unitsBeingBuilt = 0
                                    (scene as! GameScene).animateCrawlerRocketLanding(to: prov.extractorPosition,color: prov.provinceImage.color, completion: { })
                                }
                                try gameState.sharedInstance().GameBoard.crawlerLayer.addChild(newCrawler)
                            }
                        }
                        if self.currentPlayerActive.unitsBeingBuilt == 0{
                            self.currentPlayerActive.hasDeployedCrawlers = true
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.disableCrawlerPlacementUI()
                        }
                    }
                }
            }
            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: self.currentPlayerActive)
        }catch{ print("Error in deployCrawler") }
    }
    
    func updateCrawlerCreation(for player: Player){
        do {
            let numberOfFactories = player.builtExtractorProvinces.count
            if self.settingsInstance.cardBonusMode == "increases" {
                if try self.numberOfturnsProgress % (gameState.sharedInstance().GameSettings.gamePlayers.count) == 0{
                    self.crawlersPerFactory += 1
                }
            }else if self.settingsInstance.cardBonusMode == "constant" {
                if try self.numberOfturnsProgress % (gameState.sharedInstance().GameSettings.gamePlayers.count) == 0{
                    self.crawlersPerFactory = 2
                }
            }else if self.settingsInstance.cardBonusMode == "capped" {
                if try self.numberOfturnsProgress % (gameState.sharedInstance().GameSettings.gamePlayers.count) == 0{
                    if self.crawlersPerFactory < 4 {
                        self.crawlersPerFactory += 1
                    }
                }
            }
            player.unitsBeingBuilt = (numberOfFactories * self.crawlersPerFactory)
            if player.unitsBeingBuilt == 0{
                player.hasDeployedCrawlers = true
            }else{
                player.hasDeployedCrawlers = false
            }
            player.mineralsBeingCollected = (numberOfFactories * 1) //1 mineral per factory
            player.mineralsCollected += (player.mineralsBeingCollected)
        }catch{ print("Error in updateCrawlerCreation") }
    }
    
    //Gets a local instance of the settings and checks if the game is singular play.
    private func importGameState(){
        do{
            if try gameState.sharedInstance().isGameInProgress == true{
                self.settingsInstance = gameSettings()
            }else{
                self.settingsInstance = try gameState.sharedInstance().GameSettings
            }
            
            if self.settingsInstance != nil {
                var n = 0
                for player in self.settingsInstance.gamePlayers{
                    if player.isPlayerHuman == true{
                        n += 1
                    }
                }
                if n > 1 {
                    self.isUpdatingStatistics = false
                }else {
                    self.isUpdatingStatistics = true
                    if try gameState.sharedInstance().isGameInProgress == true{
                        self.statisticsInstance = gameStatistics()
                    }else{
                        self.statisticsInstance = try gameState.sharedInstance().PlayerStats
                    }
                }
            }
        }catch{ print("Error in importGameState") }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isUpdatingStatistics = aDecoder.decodeBool(forKey: "updatingStats")
        self.settingsInstance = aDecoder.decodeObject(forKey: "settings") as? gameSettings!
        self.statisticsInstance = aDecoder.decodeObject(forKey: "statistics") as? gameStatistics!
        self.isGameStarted = aDecoder.decodeBool(forKey: "gameStarted")
        self.movementHandler = aDecoder.decodeObject(forKey: "movement") as? movement!
        
        self.currentPlayerActive = aDecoder.decodeObject(forKey: "activeplayer") as? Player!
        
        self.selectedNode = aDecoder.decodeObject(forKey: "selected") as AnyObject!
        self.compoundedDistance = aDecoder.decodeCGPoint(forKey: "compounded")
        
        self.combatComputer = aDecoder.decodeObject(forKey: "combatComputer") as? combatResolver!
        self.numberOfturnsProgress = aDecoder.decodeInteger(forKey: "numTurns")
        self.crawlersPerFactory = aDecoder.decodeInteger(forKey: "crawlers")
        self.crawlerDeployAmount = aDecoder.decodeInteger(forKey: "deploy")
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.isUpdatingStatistics, forKey: "updatingStats")
        aCoder.encode(self.settingsInstance, forKey: "settings")
        aCoder.encode(self.statisticsInstance, forKey: "statistics")
        aCoder.encode(self.isGameStarted, forKey: "gameStarted")
        aCoder.encode(self.movementHandler, forKey: "movement")
        aCoder.encode(self.currentPlayerActive, forKey: "activeplayer")
        aCoder.encode(self.selectedNode, forKey: "selected")
        aCoder.encode(self.compoundedDistance, forKey: "compounded")
        aCoder.encode(self.combatComputer, forKey: "combatComputer")
        aCoder.encode(self.numberOfturnsProgress, forKey: "numTurns")
        aCoder.encode(self.crawlersPerFactory, forKey: "crawlers")
        aCoder.encode(self.crawlerDeployAmount, forKey: "deploy")
    }
}
