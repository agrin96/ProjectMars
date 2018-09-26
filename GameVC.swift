//
//  GameVC.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/6/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

//var gGameViewScreen:CGSize

class GameVC:UIViewController{

    var mainScene: GameScene!
    var main:SKView!
    
    var selected:Bool = false
    var endTurnProcessed = true
    var choosingCardPoint = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScene = GameScene(size: self.view.bounds.size)
        main = view as! SKView
        self.selected = false
        self.endTurnProcessed = true
        
        mainScene.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(shiftView(recognizer:)))
        main.addGestureRecognizer(mainScene.panRecognizer)
        
        mainScene.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(testTap(recognizer:)))
        main.addGestureRecognizer(mainScene.tapRecognizer)
        
        mainScene.pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoomView(recognizer:)))
        main.addGestureRecognizer(mainScene.pinchRecognizer)
        
        let viewSize = mainScene.size
        if UIDevice.current.orientation.isLandscape {
            do{
                if try gameState.sharedInstance().isGameInProgress == true{
                    mainScene.tempGameBoard.boardCamera.overlayHUD.updateUIforOrientation(size: viewSize)
                }else{
                    mainScene.tempGameBoard.boardCamera.createHUD(size: CGSize(width: viewSize.height, height: viewSize.width))
                    mainScene.tempGameBoard.boardCamera.overlayHUD.updateUIforOrientation(size: viewSize)
                }
            }catch{ print("Error in GameVC orientation") }
        }else if UIDevice.current.orientation.isPortrait {
            do{
                if try gameState.sharedInstance().isGameInProgress == true{
                    mainScene.tempGameBoard.boardCamera.overlayHUD.updateUIforOrientation(size: viewSize)
                }else{
                    mainScene.tempGameBoard.boardCamera.createHUD(size: viewSize)
                }
            }catch{ print("Error in GameVC orientation") }
        }else{
            do{
                if try gameState.sharedInstance().isGameInProgress == true{
                    mainScene.tempGameBoard.boardCamera.overlayHUD.updateUIforOrientation(size: viewSize)
                }else{
                    mainScene.tempGameBoard.boardCamera.createHUD(size: viewSize)
                }
            }catch{ print("Error in GameVC orientation") }
        }
    
        mainScene.parentViewController = self
        
        main.showsFPS = true
        main.showsNodeCount = true
        main.showsDrawCount = true
        mainScene.scaleMode = .resizeFill
        
        main.presentScene(mainScene)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.mainScene.isPaused = true
//        gameState.sharedInstance().GameBoard = self.mainScene.tempGameBoard
//        gameState.sharedInstance().GameLoop = self.mainScene.GameLoop
//        gameState.sharedInstance().save()
        
    }
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.selected, forKey: "selected")
        aCoder.encode(self.endTurnProcessed, forKey: "endTurn")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selected = aDecoder.decodeBool(forKey: "selected")
        self.endTurnProcessed = aDecoder.decodeBool(forKey: "endTurn")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            mainScene.tempGameBoard.boardCamera.overlayHUD.updateUIforOrientation(size: size)
        }else if UIDevice.current.orientation.isPortrait {
            mainScene.tempGameBoard.boardCamera.overlayHUD.updateUIforOrientation(size: size)
        }
    }
    
    func shiftView(recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            var tapped = recognizer.location(in: self.view)
            tapped = main.convert(tapped, to: mainScene)
            let gamePieceTaps = mainScene.convert(tapped, to: mainScene.tempGameBoard.boardMap)

            if mainScene.tempGameBoard.boardCamera.overlayHUD.nonCombatUIActive == true {
                for node in (mainScene.tempGameBoard.landShipLayer.children as? Array<landship>)! {
                    
                    if node.landShipSprite.contains(gamePieceTaps) {
                        if node.name! == mainScene.GameLoop.currentPlayerActive.playerName! {
                            
                            self.selected = true
                            self.mainScene.GameLoop.selectedNode = node
                            self.mainScene.GameLoop.compoundedDistance = (self.mainScene.GameLoop.selectedNode as! landship).landShipSprite.position
                        }
                    }
                }
                
                for node in (mainScene.tempGameBoard.crawlerLayer.children as? Array<crawler>)! {
                    let tap = mainScene.tempGameBoard.boardMap.convert(gamePieceTaps, to: node.tapZone)
                    if node.tapZone.contains(tap) {
                        if (node.name)! == ("crawler-\(mainScene.GameLoop.currentPlayerActive.playerName!)") {
                            self.selected = true
                            self.mainScene.GameLoop.selectedNode = node
                            self.mainScene.GameLoop.compoundedDistance = self.mainScene.GameLoop.selectedNode.position
                        }
                    }
                }
            }
            break
        case .changed:
            if selected == false{
                let toMove = recognizer.translation(in: self.view)
                var newPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
                let moveModifier:CGFloat = (1.0 * (mainScene.camera?.xScale)!)
                
                newPosition.x = (mainScene.camera?.position.x)! - (toMove.x * moveModifier)
                newPosition.y = (mainScene.camera?.position.y)! + (toMove.y * moveModifier)
                
                mainScene.camera?.run(SKAction.move(to: newPosition, duration: 0.0))
                
                recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            }
            if selected == true{
                var toMove = recognizer.translation(in: self.view)
                toMove = mainScene.convert(toMove, to: self.mainScene.tempGameBoard.boardMap)
                let moveModifier:CGFloat = (1.0 * (mainScene.camera?.xScale)!)
                toMove.x = toMove.x * moveModifier
                toMove.y = toMove.y * moveModifier
                self.mainScene.GameLoop.drawDottedMoveLineTo(destination: toMove)

                recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            }
            break
        case .ended:
            if selected == false{
                var toMove = recognizer.translation(in: self.view)
                var newPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
                
                let velocity = recognizer.velocity(in: self.view)
                let magnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
                let scale = Double((magnitude / 800) * 0.1)
                toMove.x = velocity.x * CGFloat(scale)
                toMove.y = velocity.y * CGFloat(scale)
                
                newPosition.x = (mainScene.camera?.position.x)! - toMove.x
                newPosition.y = (mainScene.camera?.position.y)! + toMove.y
                
                mainScene.camera?.run(SKAction.move(to: newPosition, duration: scale))
                
                recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            }
            if selected == true{
                if let node = self.mainScene.childNode(withName: "line") {
                    node.removeFromParent()
                }
                var finalLocation = recognizer.location(in: self.view)
                finalLocation = main.convert(finalLocation, to: mainScene)
                let convertedFinal = mainScene.convert(finalLocation, to: mainScene.tempGameBoard.boardMap)
                
                var originProvince:Province!
                for prov in mainScene.tempGameBoard.Provinces {
                    if mainScene.GameLoop.selectedNode is crawler {
                        if prov.tapOutline.contains(mainScene.GameLoop.selectedNode.position){
                            originProvince = prov
                        }
                    }else if mainScene.GameLoop.selectedNode is landship {
                        if prov.tapOutline.contains((mainScene.GameLoop.selectedNode as! landship).landShipSprite.position) {
                            originProvince = prov
                        }
                    }
                }
                
                for prov in mainScene.tempGameBoard.Provinces {
                    if prov.tapOutline.contains(convertedFinal){
                        self.mainScene.GameLoop.checkProvinceAdjacency(for: originProvince, and: prov)
                    }
                }
                selected = false
            }
            break
        default:
            break
        }
    }
    
    
    func zoomView(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case UIGestureRecognizerState.changed:
            let currentScale = (mainScene.camera?.xScale)!
            let futureScale = (currentScale * (1 / recognizer.scale))
            
            if futureScale > mainScene.tempGameBoard.boardCamera.maxZoom! ||
                futureScale < mainScene.tempGameBoard.boardCamera.minZoom! {
                recognizer.scale = 1.0
                return
            }else{
                mainScene.camera?.setScale(futureScale)
            }
            recognizer.scale = 1.0
        default:
            break
        }
    }

    func testTap(recognizer: UITapGestureRecognizer){
        var tapped =  recognizer.location(in: self.view)
        tapped = main.convert(tapped, to: mainScene)
        
        let UICheck = mainScene.convert(tapped, to: mainScene.tempGameBoard.boardCamera)
        let nodesTapped = mainScene.tempGameBoard.boardCamera.overlayHUD.nodes(at: UICheck)
        let gamePieceTaps = mainScene.convert(tapped, to: mainScene.tempGameBoard.boardMap)
        let tappedProvince = mainScene.convert(tapped, to: mainScene.tempGameBoard.boardMap)
        
        if self.endTurnProcessed == true{
            if mainScene.tempGameBoard.boardCamera.overlayHUD.nonCombatUIActive == false && mainScene.tempGameBoard.boardCamera.overlayHUD.extendedElements.extendedUIEnabled == true{
                for node in nodesTapped {
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.extendedElements.extendedLowerBar.childNode(withName: "place1") {
                        if node.alpha == 1.0 {
                            mainScene.GameLoop.crawlerDeployAmount = 1
                            mainScene.tempGameBoard.boardCamera.overlayHUD.extendedElements.setSelectionIndicatorPosition(for: mainScene.GameLoop.crawlerDeployAmount)
                            return
                        }
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.extendedElements.extendedLowerBar.childNode(withName: "place5") {
                        if node.alpha == 1.0 {
                            mainScene.GameLoop.crawlerDeployAmount = 5
                            mainScene.tempGameBoard.boardCamera.overlayHUD.extendedElements.setSelectionIndicatorPosition(for: mainScene.GameLoop.crawlerDeployAmount)
                            return
                        }
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.extendedElements.extendedLowerBar.childNode(withName: "placeAll") {
                        if node.alpha == 1.0 {
                            mainScene.GameLoop.crawlerDeployAmount = 10000  //Basiclaly infinite
                            mainScene.tempGameBoard.boardCamera.overlayHUD.extendedElements.setSelectionIndicatorPosition(for: mainScene.GameLoop.crawlerDeployAmount)
                            return
                        }
                    }
                }
            }
        }
        
        /// Allow user to deploy thier crawlers on the game board.
        if self.endTurnProcessed == true{
            if mainScene.tempGameBoard.boardCamera.overlayHUD.nonCombatUIActive == false{
                if mainScene.GameLoop.currentPlayerActive != nil {
                    if mainScene.GameLoop.currentPlayerActive.hasDeployedCrawlers == false{
                        mainScene.GameLoop.deployCrawler(for: tappedProvince)
                    }
                }
            }    
        }
        
        // Actually process the card selection once a province is tapped on.
        if self.choosingCardPoint == true {
            if mainScene.cardActionProcessor(tapped: tappedProvince) {
                // If we are successful then everything is great and we reset.
                self.choosingCardPoint = false
                mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton.isHidden = true
                mainScene.deOribitAsteroidActive = false
                mainScene.deployCrawlersActive = false
                mainScene.deployFactoryActive = false
                mainScene.repairTeamsActive = false
            }
        }
        
        
        /// Check for presses of the four UI Buttons
        if self.endTurnProcessed == true{
            if mainScene.tempGameBoard.boardCamera.overlayHUD.nonCombatUIActive == true{
                for node in nodesTapped {
                    
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.lowerBar.childNode(withName: "Return"){
                        self.performSegue(withIdentifier: "returnToMenu", sender: self)
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.lowerBar.childNode(withName: "Extractor"){
                        for player in mainScene.GameLoop.settingsInstance.gamePlayers {
                            
                            if player.isCurrentlyActive == true{
                                mainScene.GameLoop.handleExtractorButtonPress(for: player)
                            }
                        }
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.lowerBar.childNode(withName: "End Turn"){
                        self.endTurnProcessed = false
                        self.mainScene.GameLoop.handleEndTurnPress(completion: { () in self.endTurnProcessed = true })
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.showHideUIButton {
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.showCardSelectionUI()
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.closeCardMenu {
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.hideCardSelectionUI()
                    }
                    
                    // Indicate the card selection.
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.deOrbitAsteroidCard {
                        self.choosingCardPoint = true
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.hideCardSelectionUI()
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton.isHidden = false
                        mainScene.deOribitAsteroidActive = true
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.factoryDropCard {
                        self.choosingCardPoint = true
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.hideCardSelectionUI()
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton.isHidden = false
                        mainScene.deployFactoryActive = true
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.crawlerDropCard {
                        self.choosingCardPoint = true
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.hideCardSelectionUI()
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton.isHidden = false
                        mainScene.deployCrawlersActive = true
                    }
                    if node == mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.repairTeamsCard {
                        self.choosingCardPoint = true
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.hideCardSelectionUI()
                        mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton.isHidden = false
                        mainScene.repairTeamsActive = true
                    }
                    
                    //Cancel the card selection
                    if self.choosingCardPoint == true && mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton.isHidden == false {
                        if node == mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton {
                            self.choosingCardPoint = false
                            mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.showCardSelectionUI()
                            mainScene.tempGameBoard.boardCamera.overlayHUD.cardSelector.cancelButton.isHidden = true
                            //Reset the selectors
                            mainScene.deOribitAsteroidActive = false
                            mainScene.deployCrawlersActive = false
                            mainScene.deployFactoryActive = false
                            mainScene.repairTeamsActive = false
                        }
                    }
                }
            }
        }
        
        /// Check for combat button presses
        if mainScene.tempGameBoard.boardCamera.overlayHUD.nonCombatUIActive == false{
            for node in nodesTapped {
                if node == mainScene.tempGameBoard.boardCamera.overlayHUD.childNode(withName: "Attack"){
                    //Confirmed Attack
                    mainScene.GameLoop.combatComputer.combatToResolve = mainScene.GameLoop.movementHandler.combatMovement
                    mainScene.GameLoop.combatComputer.resolveCurrentCombat(for: mainScene.GameLoop.currentPlayerActive, resolveAll: false)
                }
                if node == mainScene.tempGameBoard.boardCamera.overlayHUD.childNode(withName: "Resolve"){
                    mainScene.GameLoop.combatComputer.combatToResolve = mainScene.GameLoop.movementHandler.combatMovement
                    mainScene.GameLoop.combatComputer.resolveCurrentCombat(for: mainScene.GameLoop.currentPlayerActive, resolveAll: true)
                }
                if node == mainScene.tempGameBoard.boardCamera.overlayHUD.childNode(withName: "Retreat"){
                    //Retreat
                    mainScene.tempGameBoard.boardMap.enumerateChildNodes(withName: "AttackArrow", using: {
                        node, stop in
                        if node.parent != nil {
                            node.removeFromParent()
                        }else{
                            stop[0] = true
                        }
                    })
                    for ship in mainScene.tempGameBoard.landShipLayer.children {
                        if (ship as! landship).attackState != nil {
                           (ship as! landship).attackState = nil
                        }
                    }
                    for crawler in mainScene.tempGameBoard.crawlerLayer.children {
                        if (crawler as! crawler).attackState != nil {
                           (crawler as! crawler).attackState = nil
                        }
                    }
                    mainScene.tempGameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                    mainScene.tempGameBoard.boardCamera.overlayHUD.movementOptions.clearAttackButtons()
                    mainScene.tempGameBoard.boardCamera.overlayHUD.movementOptions.clearCombatInformation()
                    mainScene.GameLoop.movementHandler.resetAttackingOrder()
                }
            }
        }
        
        /// Check for tapping of game objects to display their current combat stats.
        for node in (mainScene.tempGameBoard.landShipLayer.children as? Array<landship>)! {
            let bounce = SKAction.sequence([SKAction.resize(byWidth: 15, height: 15, duration: 0.3), SKAction.resize(byWidth: -15, height: -15, duration: 0.3)])
            if node.landShipSprite.contains(gamePieceTaps) {
                if node.name! == mainScene.GameLoop.currentPlayerActive.playerName! {
                    node.landShipSprite.run(bounce)
                    self.mainScene.tempGameBoard.boardCamera.overlayHUD.movementOptions.displayCurrentStats(for: node.combatStats)
                }
            }
        }
        for node in (mainScene.tempGameBoard.crawlerLayer.children as? Array<crawler>)! {
            let bounce = SKAction.sequence([SKAction.resize(byWidth: 15, height: 15, duration: 0.3), SKAction.resize(byWidth: -15, height: -15, duration: 0.3)])
            if node.contains(gamePieceTaps) {
                if node.name! == "crawler-\(mainScene.GameLoop.currentPlayerActive.playerName!)"{
                    node.run(bounce)
                    self.mainScene.tempGameBoard.boardCamera.overlayHUD.movementOptions.displayCurrentStats(for: node.combatStats)
                }
            }
        }
        
        /// If the game has not started then we can handle start position settings right now.
        if mainScene.GameLoop.isGameStarted == false{
            var allAssigned:Bool = true
            for player in mainScene.GameLoop.settingsInstance.gamePlayers{
                allAssigned = allAssigned && player.hasStartAssigned
            }
            if allAssigned == false{
                mainScene.customStartHandler(tapped: tappedProvince)
            }else{
                // All starts assigned so we begin the game
                //mainScene.GameLoop.isGameStarted = true
            }
        }
    }

}
