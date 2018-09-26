//
//  mainGame.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/6/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    var parentViewController:UIViewController!
    
    var panRecognizer:UIPanGestureRecognizer!
    var tapRecognizer:UITapGestureRecognizer!
    var pinchRecognizer:UIPinchGestureRecognizer!
    
    var tempGameBoard:gameBoard = gameBoard()
    var mapTextures:Array<SKTexture> = []
    var craterTextures:Array<SKTexture> = []
    var rocketSprites:Array<SKSpriteNode> = []
    var rocketLanding:Array<SKTexture> = []
    var rocketFlying:Array<SKTexture> = []
    
    //Game logic class
    var GameLoop:gameLoop!
    
    //Variables for controlling card selection.
    var deOribitAsteroidActive = false
    var deployFactoryActive = false
    var deployCrawlersActive = false
    var repairTeamsActive = false
    
    override func update(_ currentTime: TimeInterval) {
        
        if GameLoop.isGameStarted == false{
            var startGame = true
            for player in self.GameLoop.settingsInstance.gamePlayers {
                startGame = startGame && player.hasStartAssigned
            }
            if startGame == true {
                self.startGame()
                if self.GameLoop.currentPlayerActive != nil && self.GameLoop.isGameStarted == true{
                    do{
                        try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: self.GameLoop.currentPlayerActive)
                    }catch{ print("Error in update") }
                }
            }
        }

        self.tempGameBoard.boardCamera.overlayHUD.updateMiniMap()
        do {
            if try gameState.sharedInstance().GameSettings.gamePlayers.count == 1 {
                try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "GAME OVER", completion: { })
            }
            for player in (try gameState.sharedInstance().GameSettings.gamePlayers) {
                if player.mineralsCollected >= 150 {
                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "GAME OVER", completion: { })
                }
            }
        }catch{ print("Error in update2") }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.createMap(named: "mainmap")
        self.createBackGround(named: "map_background_main1")
        self.createCamera()
        self.addProvinces()
        self.addProvinceTapNodes()
        self.addReasources()
        self.addGamePiecePoints()
        self.createRocket()
        do{
            if try gameState.sharedInstance().isGameInProgress != true{
                try gameState.sharedInstance().GameBoard = self.tempGameBoard   //Savemap
                
                ///This is where the game board is set up with peices and players
                let _ = gameSetup(forPlayers: (try gameState.sharedInstance().GameSettings.gamePlayers), andStartOption: ( try gameState.sharedInstance().GameSettings.startPositionMode))
            }
        }catch{ print("Error in mainGame init") }
    }
    
    override func didMove(to view: SKView) {
        do{
            if try gameState.sharedInstance().isGameInProgress == true{
                self.GameLoop = try gameState.sharedInstance().GameLoop
                self.tempGameBoard.boardCamera.overlayHUD.updateTurnCounter(for: self.GameLoop.currentPlayerActive, completion: { })
            }else{
                self.GameLoop = gameLoop()
                self.tempGameBoard.boardCamera.overlayHUD.updateTurnCounter(for: self.GameLoop.settingsInstance.gamePlayers[0], completion: { })
                self.tempGameBoard.boardCamera.overlayHUD.disableNonCombatUI()
                try gameState.sharedInstance().GameLoop = self.GameLoop
            }
        }catch { print("Error in didMove in mainGame") }
    }
    
    func startGame(){
        self.GameLoop.runGame()
    }
    private func createRocket(){
        let flyingAtlas = SKTextureAtlas(named: "RocketFlight")
        let landingAtlas = SKTextureAtlas(named: "RocketLanding")
        
        var flying = "Rocket_flight-"
        for i in 1..<3 {
            self.rocketFlying.append(flyingAtlas.textureNamed(flying + String(i)))
        }
        flying = "Rocket_Landing-"
        for i in 1..<4 {
            self.rocketLanding.append(landingAtlas.textureNamed(flying + String(i)))
        }
    }
    
    /// Creates the main game map without provinces
    private func createMap(named: String){
        do{
            if try gameState.sharedInstance().isGameInProgress == true {
                self.tempGameBoard.boardMap = try gameState.sharedInstance().GameBoard.boardMap
                self.tempGameBoard.landShipLayer = try gameState.sharedInstance().GameBoard.landShipLayer
                self.tempGameBoard.extractorLayer = try gameState.sharedInstance().GameBoard.extractorLayer
                self.tempGameBoard.crawlerLayer = try gameState.sharedInstance().GameBoard.crawlerLayer
            }else{
                tempGameBoard.boardMap = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 1334, height: 750))
                tempGameBoard.boardMap.size = CGSize(width: 1334, height: 750)
                tempGameBoard.boardMap.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                tempGameBoard.boardMap.position = CGPoint(x: 0, y: 0)
                tempGameBoard.boardMap.zPosition = 0
                
                tempGameBoard.landShipLayer = SKNode()
                tempGameBoard.landShipLayer.zPosition = 3
                tempGameBoard.boardMap.addChild(tempGameBoard.landShipLayer)
                
                tempGameBoard.extractorLayer = SKNode()
                tempGameBoard.extractorLayer.zPosition = 1
                tempGameBoard.boardMap.addChild(tempGameBoard.extractorLayer)
                
                tempGameBoard.crawlerLayer = SKNode()
                tempGameBoard.crawlerLayer.zPosition = 2
                tempGameBoard.boardMap.addChild(tempGameBoard.crawlerLayer)
            }
        }catch { print("Error in createMap") }
        
        if tempGameBoard.boardMap.parent == nil {
            self.addChild(tempGameBoard.boardMap)
        }
    }
    
    private func createBackGround(named: String){
        let backGround = SKSpriteNode(imageNamed: named)
        backGround.size = CGSize(width: 2668, height: 1700)
        backGround.alpha = 0.7
        backGround.position = CGPoint(x: self.tempGameBoard.boardMap.size.width / 2, y: self.tempGameBoard.boardMap.size.height / 2 - 25)
        backGround.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backGround.zPosition = -1
        backGround.name = "BG_center"
        self.addChild(backGround)
    }
    
    /// Creates and adds the main view camera to the scene
    private func createCamera(){
        do{
            if try gameState.sharedInstance().isGameInProgress == true {
                self.tempGameBoard.boardCamera = try gameState.sharedInstance().GameBoard.boardCamera
            }else{
                let contentRect = tempGameBoard.boardMap.calculateAccumulatedFrame()
                let insetRatio = tempGameBoard.boardMap.size.width / tempGameBoard.boardMap.size.height
                let insetRect = contentRect.insetBy(dx: 100 / insetRatio, dy: 100)
                
                let vRange = SKRange(lowerLimit: insetRect.minY ,
                                     upperLimit: insetRect.maxY)
                let hRange = SKRange(lowerLimit: insetRect.minX ,
                                     upperLimit: insetRect.maxX)
                
                self.tempGameBoard.boardCamera = PlayerCamera(hRange: hRange,
                                                              vRange: vRange,
                                                              maxZoom: 2,
                                                              minZoom: 0.5)
                
                self.tempGameBoard.boardCamera.position = CGPoint(x: tempGameBoard.boardMap.size.width / 2,
                                                                  y: tempGameBoard.boardMap.size.height / 2)
            }
            if self.tempGameBoard.boardCamera.parent == nil{
                self.camera = self.tempGameBoard.boardCamera
                self.addChild(self.tempGameBoard.boardCamera)
            }
        }catch { print("Error in createCamera") }
    }
    
    /// Adds textures for all the provinces in the game
    private func addProvinces(){
        var provName = "Province"
        let atlas = SKTextureAtlas(named: "Provinces")
        var n = 1
        var y = 0
        
        for num in 1...43 {
            provName = provName + String(num)
            let temp = atlas.textureNamed(provName)
            mapTextures.append(temp)
            provName = "Province"
        }
        
        for image in mapTextures {
            do{
                if try gameState.sharedInstance().isGameInProgress == true{
                    self.tempGameBoard.Provinces.append(try gameState.sharedInstance().GameBoard.Provinces[y])
                    y += 1
                }else{
                    self.tempGameBoard.Provinces.append(Province(provNum: n, provSprite: image, size: self.tempGameBoard.boardMap.size))
                    n += 1
                }
            }catch { print("Error in addProvinces") }
        }

        for location in self.tempGameBoard.Provinces {
            location.removeFromParent()
            self.tempGameBoard.boardMap.addChild(location)
        }
    }
    /// Adds a masked layer of shape nodes to control tapping on individual provinces.
    private func addProvinceTapNodes(){
        let shapes = shapeContainer()
        var n = 0
        for path in shapes.shapeStorage {
            self.tempGameBoard.Provinces[n].setupTappableArea(path: path)
            n += 1
        }
    }
    
    /// Changes province texture to have craters on province that will have resources
    private func addReasources(){
        let atlas = SKTextureAtlas(named: "ProvincesWithMinerals")
        var provName = "Province"
        for num in 1...43 {
            provName = provName + String(num) + "M"
            let temp = atlas.textureNamed(provName)
            craterTextures.append(temp)
            provName = "Province"
        }
    }
    
    ///Determines the positions in which the gamePieces will be set for movement and placement
    private func addGamePiecePoints(){
        let points = gamePiecePositions()
        var n = 0
        for point in points.extractorPoints{
            self.tempGameBoard.Provinces[n].extractorPosition = point
            n += 1
        }
        n = 0
        for point in points.roverPoints{
            self.tempGameBoard.Provinces[n].landShipPosition = point
            n += 1
        }
    }
    func animateLandShipRocketLanding(to point: CGPoint, color: SKColor, completion: @escaping ()->()){
        let rocketSprite = SKSpriteNode(texture: self.rocketFlying[0])
        
        rocketSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        rocketSprite.size = CGSize(width: 125, height: 125)
        rocketSprite.yScale = rocketSprite.yScale * -1
        rocketSprite.zPosition = 6
        rocketSprite.blendMode = .alpha
        rocketSprite.colorBlendFactor = 0.2
        rocketSprite.color = color
        self.tempGameBoard.boardMap.addChild(rocketSprite)
        
        
        let rocketEntry = SKAction.animate(with: self.rocketFlying, timePerFrame: 0.2)
        let pathTofollow = CGMutablePath()
        let startingPoint = CGPoint(x: (point.x + self.tempGameBoard.boardMap.size.width), y: (point.y + self.tempGameBoard.boardMap.size.height - 200))
        let endPoint = CGPoint(x: point.x, y: point.y + 100)
        let controlPoint = CGPoint(x: point.x, y: startingPoint.y)
        pathTofollow.move(to: startingPoint)
        pathTofollow.addCurve(to: endPoint, control1: controlPoint, control2: controlPoint)
        
        let followEntry = SKAction.follow(pathTofollow, asOffset: false, orientToPath: true, duration: 3)
        let entry = SKAction.group([rocketEntry, followEntry])
        rocketSprite.run(entry, completion: { () in

            rocketSprite.removeAllActions()
            
            let landing = SKAction.animate(with: self.rocketLanding, timePerFrame: 0.4)
            let moveTo = SKAction.move(to: point, duration: 1.2)
            let landingAnimation = SKAction.group([landing, moveTo])
            rocketSprite.run(SKAction.sequence([landingAnimation, SKAction.wait(forDuration: 1)]), completion: { () in
                rocketSprite.removeFromParent()
                completion()
            })
        })
    }
    func animateCrawlerRocketLanding(to point: CGPoint, color: SKColor, completion: @escaping ()->()){
        let rocketSprite = SKSpriteNode(texture: self.rocketFlying[0])
        
        rocketSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        rocketSprite.size = CGSize(width: 80, height: 80)
        rocketSprite.yScale = rocketSprite.yScale * -1
        rocketSprite.zPosition = 6
        rocketSprite.blendMode = .alpha
        rocketSprite.colorBlendFactor = 0.2
        rocketSprite.color = color
        self.tempGameBoard.boardMap.addChild(rocketSprite)
        let randomizationFactor = CGPoint(x: Int.random(range: -20...20), y: Int.random(range: -20...20))
        
        let rocketEntry = SKAction.animate(with: self.rocketFlying, timePerFrame: 0.2)
        let pathTofollow = CGMutablePath()
        let startingPoint = CGPoint(x: (point.x + self.tempGameBoard.boardMap.size.width), y: (point.y + self.tempGameBoard.boardMap.size.height - 200))
        let endPoint = CGPoint(x: (point.x + randomizationFactor.x), y: ((point.y + randomizationFactor.y) + 100))
        let controlPoint = CGPoint(x: point.x, y: startingPoint.y)
        pathTofollow.move(to: startingPoint)
        pathTofollow.addCurve(to: endPoint, control1: controlPoint, control2: controlPoint)
        
        let followEntry = SKAction.follow(pathTofollow, asOffset: false, orientToPath: true, duration: 2)
        let entry = SKAction.group([rocketEntry, followEntry])
        rocketSprite.run(entry, completion: { () in
            
            rocketSprite.removeAllActions()
            
            let landing = SKAction.animate(with: self.rocketLanding, timePerFrame: 0.3)
            let moveTo = SKAction.move(to: CGPoint(x: point.x + randomizationFactor.x, y: point.y + randomizationFactor.y), duration: 0.9)
            let landingAnimation = SKAction.group([landing, moveTo])
            rocketSprite.run(SKAction.sequence([landingAnimation, SKAction.wait(forDuration: 1)]), completion: { () in
                rocketSprite.removeFromParent()
                completion()
            })
        })
    }
    
    /// Helper function for placing a landShip onto the game board during start position placement.
    ///
    /// - Parameters:
    ///   - ship: The landShip to be placed
    ///   - province: The map province where this landShip will be
    ///   - player: The player that this landShip belongs to
    func modifyMapParameters(for ship: inout landship, in province: Province, and player: Player){
        //ship.modifyLandShipSize(newSize: CGSize(width: 80, height: 80))
        ship.modifySpawnPosition(position: province.landShipPosition)
        ship.modifyColor(color: player.color, blendfactor: 0.2, blendMode: SKBlendMode.alpha)

        province.startPositionTaken = true
        province.owningPlayer = player
        province.hasLandShip = true
        ship.removeFromParent()
        ship.landShipSprite.removeAllChildren()
        ship.isHidden = false
        ship.isUserInteractionEnabled = true
    }
    
    
    /// This function is called right before the game starts to make sure that if custom starts are selected
    /// that the players have a chace to select etheir start positions. AI selects empty craters for start positions
    /// - Parameter tapped: Point where use tapped
    func customStartHandler(tapped: CGPoint){
        var pCount = 0
        var currentCount = 0
        var players = self.GameLoop.settingsInstance.gamePlayers

        humanAssign: while pCount < players.count{
            if players[pCount].isPlayerHuman == true && players[pCount].hasStartAssigned == false {
                
                for prov in self.tempGameBoard.Provinces{
                    if prov.tapOutline.contains(tapped){
                        

                        if prov.startPositionTaken == false{
                            prov.isCratered = true
                            prov.provinceImage.texture = self.craterTextures[prov.provinceNumber - 1]
                            prov.changeProvinceColor(toColor: players[pCount].color, toBlendMode: SKBlendMode.alpha, toFactor: 0.3)
                            prov.startPositionTaken = true

                            var newLandShip = players[pCount].chosenLandShip.getNodeCopy(andNameIt: players[pCount].playerName)
                            self.modifyMapParameters(for: &newLandShip, in: prov, and: players[pCount])
                            
                            players[pCount].hasStartAssigned = true
                            
                            // Update the turn counter when people are placing thier landships
                            pCount += 1
                            currentCount = pCount
                            if pCount == self.GameLoop.settingsInstance.gamePlayers.count{
                                pCount = 0
                                currentCount = pCount
                            }
                            self.tempGameBoard.boardCamera.overlayHUD.updateTurnCounter(for: self.GameLoop.settingsInstance.gamePlayers[pCount], completion: { })
                            self.animateLandShipRocketLanding(to: prov.landShipPosition, color: prov.provinceImage.color, completion: { () in
                                self.tempGameBoard.landShipLayer.addChild(newLandShip)
                                newLandShip.addParticleEffect()
                                var truthTable = true

                                for player in self.GameLoop.settingsInstance.gamePlayers{
                                    truthTable = truthTable && player.hasStartAssigned
                                }
                                if truthTable == true{
                                    self.tempGameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                                }
                            })
                            break humanAssign
                        }
                    }
                }
                // If we make it to the end of the for loop then we must have misstapped so we retry 
                return
                
            }else if players[pCount].isPlayerHuman == false && players[pCount].hasStartAssigned == false{
                break humanAssign
            }
            pCount += 1
        }
        computerAssign: while pCount < players.count {
            if players[pCount].isPlayerHuman == false && players[pCount].hasStartAssigned == false {
                while players[pCount].hasStartAssigned == false {
                    let n = Int.random(range: 0...43)
                    for prov in self.tempGameBoard.Provinces{
                        if prov.provinceNumber == n{

                            if prov.startPositionTaken == false{
                                prov.isCratered = true
                                prov.provinceImage.texture = self.craterTextures[prov.provinceNumber - 1]
                                prov.changeProvinceColor(toColor: players[pCount].color, toBlendMode: SKBlendMode.alpha, toFactor: 0.3)
                                prov.startPositionTaken = true
                                
                                var newLandShip = players[pCount].chosenLandShip.getNodeCopy(andNameIt: players[pCount].playerName)
                                self.modifyMapParameters(for: &newLandShip, in: prov, and: players[pCount])
                                players[pCount].hasStartAssigned = true
                                
                                self.animateLandShipRocketLanding(to: prov.landShipPosition, color: prov.provinceImage.color, completion: { () in
                                    self.tempGameBoard.landShipLayer.addChild(newLandShip)

                                    newLandShip.addParticleEffect()
                                    var truthTable = true
                                    for player in self.GameLoop.settingsInstance.gamePlayers{
                                        truthTable = truthTable && player.hasStartAssigned
                                    }
                                    if truthTable == true{
                                        self.tempGameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                                    }
                                })
                            }
                        }
                    }
                }
            }else if players[pCount].isPlayerHuman == true && players[pCount].hasStartAssigned == false{
                break computerAssign
            }
            pCount += 1
        }
    }
    
    // Process the players card selection. Returns true if successful and false if not. ( This can be due to an improper selection
    // or not enought resources)
    func cardActionProcessor(tapped: CGPoint) -> Bool{
        for prov in tempGameBoard.Provinces {
            if prov.tapOutline.contains(tapped) {
                //We have tapped in a valid province so now we need to perform further checks based on card.
                
                if self.deOribitAsteroidActive == true {
                    if GameLoop.currentPlayerActive.mineralsCollected >= 30 {
                        
                        for ship in tempGameBoard.landShipLayer.children {
                            let explosionEffect = SKEmitterNode(fileNamed: "deOrbitExplosion")
                            explosionEffect?.name = "explosion"
                            let explosionAction = SKAction.group([SKAction.fadeIn(withDuration: 1),SKAction.wait(forDuration: 4),SKAction.fadeOut(withDuration: 4)])
                            self.addChild(explosionEffect!)
                            explosionEffect?.position = tapped
                            explosionEffect?.run(explosionAction, completion: {
                                self.childNode(withName: "explosion")?.removeFromParent()
                            })
                            
                            if (ship as! landship).landShipSprite.position == prov.landShipPosition {
                                (ship as! landship).combatStats.currentHitPoints! -= 10
                                
                                if (ship as! landship).combatStats.currentHitPoints <= 0 {
                                    //Player has lost the game
                                    var indexToRemove:Int!
                                    var index = 0
                                    do {
                                        for person in try gameState.sharedInstance().GameSettings.gamePlayers {
                                            if person.color == (ship as! landship).landShipSprite.color {
                                                indexToRemove = index
                                                try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.displayGameInformation(with: "\(person.playerName!) has lost!", completion: { () in
                                                    do { try gameState.sharedInstance().GameSettings.gamePlayers.remove(at: indexToRemove) }
                                                    catch {print("Error in cardActionProcessor") }
                                                })
                                                
                                                for prov in (try gameState.sharedInstance().GameBoard.Provinces) {
                                                    if prov.landShipPosition == (ship as! landship).landShipSprite.position{
                                                        prov.hasLandShip = false
                                                    }
                                                }
                                                (ship as! landship).removeFromParent()
                                            }else{
                                                index += 1
                                            }
                                        }
                                    } catch { print("Error in cardActionProcessor2") }
                                }
                            }
                        }
                        for unit in tempGameBoard.crawlerLayer.children {
                            if (unit as! crawler).position == prov.extractorPosition {
                                var i:Int = 0;
                                
                                while i != 10 {
                                    (unit as! crawler).combatStats.currentHitPoints! -= 1    //Calculate Damage
                                    
                                    if ((unit as! crawler).combatStats.currentHitPoints! % 2 ) <= 0 {
                                        (unit as! crawler).addCrawlersToStack(numberOfCrawlers: -1)
                                        if Int((unit as! crawler).crawlerNumber.text!)! <= 0 {
                                            do{
                                                for prov in (try gameState.sharedInstance().GameBoard.Provinces) {
                                                    if prov.extractorPosition == (unit as! crawler).position{
                                                        prov.hasCrawlers = false
                                                    }
                                                }
                                                (unit as! crawler).removeFromParent()
                                            }catch { print("Error in cardActionProcessor3") }
                                        }
                                    }
                                    i += 1  //Increment Damage Counter
                                }
                                
                            }
                        }
                        for unit in tempGameBoard.extractorLayer.children {
                            if (unit as! extractor).extractorSprite.position == prov.extractorPosition {
                                (unit as! extractor).combatStats.currentHitPoints! -= 10
                            }
                            //Extractor dies.
                            if (unit as! extractor).combatStats.currentHitPoints! <= 0 {
                                do {
                                    for person in try gameState.sharedInstance().GameSettings.gamePlayers {
                                        var index = 0
                                        for location in person.builtExtractorProvinces{
                                            if (unit as! extractor).extractorSprite.position == location.extractorPosition{
                                                person.builtExtractorProvinces.remove(at: index)
                                            }
                                            index += 1
                                        }
                                    }
                                    for prov in (try gameState.sharedInstance().GameBoard.Provinces) {
                                        if prov.extractorPosition == (unit as! extractor).extractorSprite.position{
                                            prov.hasExtractor = false
                                        }
                                    }
                                    (unit as! extractor).removeFromParent()
                                }catch{print("Error in cardActionProcessor4")}
                            }
                        }
                        
                        GameLoop.currentPlayerActive.mineralsCollected -= 30
                        do {
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: GameLoop.currentPlayerActive)
                        }catch{ print("Error in cardActionProcessor5") }
                        
                        return true //Success!
                    }
                }else if self.deployFactoryActive == true {
                    
                    if GameLoop.currentPlayerActive.mineralsCollected >= 10 {
                        if prov.hasExtractor == false && prov.owningPlayer == GameLoop.currentPlayerActive && prov.isCratered == true {
                            
                            GameLoop.currentPlayerActive.mineralsCollected -= 10
                            
                            animateLandShipRocketLanding(to: prov.extractorPosition, color: GameLoop.currentPlayerActive.color, completion: { () in () })
                            let newExtractor = GameLoop.currentPlayerActive.chosenExtractor.getNodeCopy(andNameIt: GameLoop.currentPlayerActive.playerName! + "Ext")
                            newExtractor.extractorSprite.size = CGSize(width: 70, height: 70)
                            newExtractor.modifySpawnPosition(position: prov.extractorPosition)
                            newExtractor.modifyColor(color: GameLoop.currentPlayerActive.color, blendfactor: 0.3, blendMode: .alpha)
                            
                            GameLoop.currentPlayerActive.builtExtractorProvinces.append(prov) //Add this extractor to the player data on their extractors
                            do{
                                try gameState.sharedInstance().GameBoard.extractorLayer.addChild(newExtractor)
                                try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: GameLoop.currentPlayerActive)
                                prov.hasExtractor = true
                                if GameLoop.isUpdatingStatistics == true {
                                    try gameState.sharedInstance().PlayerStats.cratersControlled += 1
                                    try gameState.sharedInstance().PlayerStats.extractors += 1
                                }
                                return true
                            }catch{ print("Error in cardActionProcessor6") }
                        }
                    }
                }else if self.deployCrawlersActive == true {
                    
                    if GameLoop.currentPlayerActive.mineralsCollected >= 20 {
                        GameLoop.currentPlayerActive.mineralsCollected -= 20
                        do{
                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: GameLoop.currentPlayerActive)
                        }catch { print("Error in cardActionProcessor7") }
                        
                        if prov.hasCrawlers == true && prov.owningPlayer == GameLoop.currentPlayerActive {
                            GameLoop.currentPlayerActive.hasDeployedCrawlers = false
                            GameLoop.crawlerDeployAmount = 5
                            GameLoop.currentPlayerActive.unitsBeingBuilt = 5
                            GameLoop.deployCrawler(for: prov.extractorPosition)
                            
                            GameLoop.currentPlayerActive.hasDeployedCrawlers = true
                            GameLoop.currentPlayerActive.unitsBeingBuilt = 0
                            return true
                            
                        }else if prov.hasCrawlers == false && prov.owningPlayer == GameLoop.currentPlayerActive {
                            GameLoop.currentPlayerActive.hasDeployedCrawlers = false
                            GameLoop.crawlerDeployAmount = 5
                            GameLoop.currentPlayerActive.unitsBeingBuilt = 5
                            GameLoop.deployCrawler(for: prov.extractorPosition)
                            
                            GameLoop.currentPlayerActive.hasDeployedCrawlers = true
                            GameLoop.currentPlayerActive.unitsBeingBuilt = 0
                            return true
                            
                        }
                    }
                }else if self.repairTeamsActive == true {
                    if GameLoop.currentPlayerActive.mineralsCollected >= 10 {
                        
                        for ship in tempGameBoard.landShipLayer.children {
                            if (ship as! landship).landShipSprite.position == prov.landShipPosition {
                                if GameLoop.currentPlayerActive.color == (ship as! landship).landShipSprite.color{
                                    if (ship as! landship).combatStats.currentHitPoints < (ship as! landship).combatStats.hitPoints{
                                        
                                        (ship as! landship).combatStats.currentHitPoints = (ship as! landship).combatStats.hitPoints
                                        let repairEffect = SKEmitterNode(fileNamed: "RepairSparks")
                                        repairEffect?.name = "repairs"
                                        repairEffect?.particleSize = CGSize(width: 25, height: 25)
                                        repairEffect?.particleSpeed = 25
                                        self.addChild(repairEffect!)
                                        repairEffect?.position = (ship as! landship).landShipSprite.position
                                        
                                        let effectLoop:Array<SKAction> = [SKAction.fadeIn(withDuration: 1.0), SKAction.wait(forDuration: 20), SKAction.fadeOut(withDuration: 1.0)]
                                        let Effect = SKAction.group(effectLoop)
                                        repairEffect?.run(Effect, completion: {
                                            self.childNode(withName: "repairs")?.removeFromParent()
                                        })
                                        GameLoop.currentPlayerActive.mineralsCollected -= 10
                                        do{
                                            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.extendedElements.updateProductionIndicators(for: GameLoop.currentPlayerActive)
                                        }catch { print("Error in cardActionProcessor8") }
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.parentViewController = aDecoder.decodeObject(forKey: "parent") as! UIViewController!
        
        self.tapRecognizer = aDecoder.decodeObject(forKey: "tap") as! UITapGestureRecognizer!
        self.panRecognizer = aDecoder.decodeObject(forKey: "pan") as! UIPanGestureRecognizer!
        self.pinchRecognizer = aDecoder.decodeObject(forKey: "pinch") as! UIPinchGestureRecognizer!
        
        self.tempGameBoard = aDecoder.decodeObject(forKey: "tempBoard") as! gameBoard!
        self.mapTextures = aDecoder.decodeObject(forKey: "mapTextures") as! Array<SKTexture>!
        self.craterTextures = aDecoder.decodeObject(forKey: "craters") as! Array<SKTexture>!
        self.rocketSprites = aDecoder.decodeObject(forKey: "rocketSprites") as! Array<SKSpriteNode>!
        self.rocketLanding = aDecoder.decodeObject(forKey: "rocketLanding") as! Array<SKTexture>!
        self.rocketFlying = aDecoder.decodeObject(forKey: "rocketFlying") as! Array<SKTexture>!
        
        self.GameLoop = aDecoder.decodeObject(forKey: "game") as! gameLoop!
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.parentViewController, forKey: "parent")
        aCoder.encode(self.tapRecognizer, forKey: "tap")
        aCoder.encode(self.panRecognizer, forKey: "pan")
        aCoder.encode(self.pinchRecognizer, forKey: "pinch")
        
        aCoder.encode(self.tempGameBoard, forKey: "tempBoard")
        aCoder.encode(self.mapTextures, forKey: "mapTextures")
        aCoder.encode(self.craterTextures, forKey: "craters")
        aCoder.encode(self.rocketSprites, forKey: "rocketSprites")
        aCoder.encode(self.rocketLanding, forKey: "rocketLanding")
        aCoder.encode(self.rocketFlying, forKey: "rocketFlying")
        aCoder.encode(self.GameLoop, forKey: "game")
    }
}
