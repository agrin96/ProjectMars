//
//  movement.swift
//  project-mars
//
//  Created by Aleksandr Grin on 2/3/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class movement:NSObject, NSCoding {
    var combatMovement:combatInformation = combatInformation()
    var hasCompletedMove:Bool = true
    
    override init() {
        super.init()
    }
    
    func handleMovement(from origin: Province, to destination: Province, for piece: AnyObject, and player:Player){
        if origin.provinceNumber != destination.provinceNumber{
            if hasCompletedMove == true {
                var indicator:SKShapeNode!
                if destination.hasCrawlers == true || destination.hasLandShip == true || destination.hasExtractor == true{
                    indicator = self.createArrow(for: piece, from: origin, to: destination)
                }
                
                if piece is crawler {
                    if destination.hasCrawlers == true || destination.hasExtractor == true || destination.hasLandShip == true{
                        if destination.owningPlayer?.color != player.color {
                            
                            //Enemy Territory
                            hasCompletedMove = false
                            if self.checkValidityOfAttack(for: piece, to: destination){
                                self.displayCombatInitialization()
                                do{
                                    try gameState.sharedInstance().GameBoard.boardMap.addChild(indicator)
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setAttackButtons()
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.disableNonCombatUI()
                                }catch { print("Error in handleMovement") }
                                (piece as! crawler).attackState = (origin: origin, destination: destination, attacking: true, attacked: false)
                                hasCompletedMove = true
                            }
                            
                        }else{
                            //Friendly Territory
                            if destination.hasCrawlers == true {
                                do {
                                    let crawlerList = try gameState.sharedInstance().GameBoard.crawlerLayer.children as? Array<crawler>
                                    
                                    for crawler in crawlerList! {
                                        if destination.extractorPosition == crawler.position {
                                            hasCompletedMove = false
                                            (piece as! crawler).run(SKAction.move(to: destination.extractorPosition, duration: 1), completion: { () in
                                                crawler.addCrawlersToStack(numberOfCrawlers: Int((piece as! crawler).crawlerNumber.text!)!)
                                                (piece as! crawler).destroyStack()
                                                
                                                crawler.hasMoved = true
                                                origin.hasCrawlers = false
                                                destination.hasCrawlers = true
                                                self.hasCompletedMove = true
                                            })
                                        }
                                    }
                                }catch{print("Error in handleMovement2")}
                            }else{
                                hasCompletedMove = false
                                (piece as! crawler).run(SKAction.move(to: destination.extractorPosition, duration: 1), completion: {
                                    self.willProvinceHaveCrater(for: destination)
                                    origin.hasCrawlers = false
                                    destination.changeProvinceColor(toColor: player.color, toBlendMode: .alpha, toFactor: 0.3)
                                    destination.owningPlayer = player
                                    destination.hasCrawlers = true
                                    self.hasCompletedMove = true
                                })
                            }
                        }
                    }else{
                        hasCompletedMove = false
                        (piece as! crawler).run(SKAction.move(to: destination.extractorPosition, duration: 1), completion: {
                            self.willProvinceHaveCrater(for: destination)
                            origin.hasCrawlers = false
                            destination.changeProvinceColor(toColor: player.color, toBlendMode: .alpha, toFactor: 0.3)
                            destination.owningPlayer = player
                            destination.hasCrawlers = true
                            self.hasCompletedMove = true
                        })
                    }
                }else if piece is landship{
                    let workingNode = (piece as! landship).landShipSprite!
                    if destination.hasCrawlers == true || destination.hasExtractor == true || destination.hasLandShip == true {
                        if destination.owningPlayer?.color != player.color{
                            //Enemy
                            if workingNode.position.x < destination.landShipPosition.x {
                                if workingNode.xScale > 0 {
                                    workingNode.xScale = workingNode.xScale * -1
                                }
                            }else{
                                if workingNode.xScale < 0 {
                                    workingNode.xScale = workingNode.xScale * -1
                                }
                            }
                            if self.checkValidityOfAttack(for: piece, to: destination){
                                self.displayCombatInitialization()
                                do {
                                    try gameState.sharedInstance().GameBoard.boardMap.addChild(indicator)
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setAttackButtons()
                                    try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.disableNonCombatUI()
                                }catch{ print("Error in cardActionProcessor3") }
                                (piece as! landship).attackState = (origin: origin, destination: destination, attacking: true, attacked: false)
                            }
                        }else{
                            if workingNode.position.x < destination.landShipPosition.x {
                                if workingNode.xScale > 0 {
                                    workingNode.xScale = workingNode.xScale * -1
                                }
                            }else{
                                if workingNode.xScale < 0 {
                                    workingNode.xScale = workingNode.xScale * -1
                                }
                            }
                            
                            hasCompletedMove = false
                            workingNode.run(SKAction.move(to: destination.landShipPosition, duration: 1), completion: { () in
                                self.willProvinceHaveCrater(for: destination)
                                origin.hasLandShip = false
                                destination.changeProvinceColor(toColor: workingNode.color, toBlendMode: .alpha, toFactor: 0.3)
                                destination.owningPlayer = player
                                (piece as! landship).hasMoved = true
                                destination.hasLandShip = true
                                self.hasCompletedMove = true
                            })
                        }
                    }else{
                        //Friendly or neutral
                        if workingNode.position.x < destination.landShipPosition.x {
                            if workingNode.xScale > 0 {
                                workingNode.xScale = workingNode.xScale * -1
                            }
                        }else{
                            if workingNode.xScale < 0 {
                                workingNode.xScale = workingNode.xScale * -1
                            }
                        }
                        
                        hasCompletedMove = false
                        workingNode.run(SKAction.move(to: destination.landShipPosition, duration: 1), completion: { () in
                            self.willProvinceHaveCrater(for: destination)
                            origin.hasLandShip = false
                            destination.changeProvinceColor(toColor: workingNode.color, toBlendMode: .alpha, toFactor: 0.3)
                            destination.owningPlayer = player
                            (piece as! landship).hasMoved = true
                            destination.hasLandShip = true
                            self.hasCompletedMove = true
                        })
                    }
                }
            }
        }
        self.hasCompletedMove = true
    }
    
    func willProvinceHaveCrater(for province: Province){
        let target = 1
        let random = Int.random(range: 0...2)
        if random == target && province.owningPlayer == nil {
            do {
                let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
                province.isCratered = true
                province.provinceImage.texture = (scene as! GameScene).craterTextures[province.provinceNumber - 1]
            }catch { print("Error in willProvinceHaveCrater") }
        }
    }
    
    /// Checks if the attack specified by the player is valid. This is to handle the case that a landShip and crawlers wish to attack
    /// at the same time. This may only be done from the same province. Adjacent Provinces cannot assist.
    private func checkValidityOfAttack(for piece: AnyObject, to destination: Province) -> Bool{
        if self.combatMovement.primaryAttacker == nil {
            self.combatMovement.primaryAttacker = piece
            if piece is crawler {
                do{
                    checkOrigin: for prov in (try gameState.sharedInstance().GameBoard.Provinces){
                        if prov.extractorPosition == (piece as! crawler).position {
                            self.combatMovement.attackingProvince = prov
                            self.combatMovement.defendingProvince = destination
                            break checkOrigin
                        }
                    }
                }catch{ print("Error in checkValidityOfAttack") }
            }else if piece is landship {
                do{
                    checkOrigin: for prov in (try gameState.sharedInstance().GameBoard.Provinces){
                        if prov.landShipPosition == (piece as! landship).landShipSprite.position {
                            self.combatMovement.attackingProvince = prov
                            self.combatMovement.defendingProvince = destination
                            break checkOrigin
                        }
                    }
                }catch{ print("Error in checkValidityOfAttack2") }
            }
            return true
        }else{
            if piece is crawler {
                if self.combatMovement.attackingProvince?.extractorPosition == (piece as! crawler).position
                    && self.combatMovement.defendingProvince?.extractorPosition == destination.extractorPosition{
                    return false
                }
            }else if piece is landship {
                if self.combatMovement.attackingProvince?.landShipPosition == (piece as! landship).landShipSprite.position
                    && self.combatMovement.defendingProvince?.extractorPosition == destination.extractorPosition{
                    return false
                }
            }
            return false
        }
    }
    
    func resetAttackingOrder(){
        self.combatMovement.primaryAttacker = nil
        self.combatMovement.attackingProvince = nil
        self.combatMovement.defendingProvince = nil
    }
    
    
    /// Shows the relative combat statistics of each unit when initiating an attack. This displays the information before an attack is carried out.
    func displayCombatInitialization(){
        var attackerInfo:unitCombatStats!
        var defenderInfo:unitCombatStats!
        
        switch self.combatMovement.primaryAttacker {
        case let piece as landship:
            attackerInfo = piece.combatStats
            break
        case let piece as crawler:
            attackerInfo = piece.combatStats
            break
        default:
            break
        }
        do {
            if self.combatMovement.defendingProvince != nil {
                if (self.combatMovement.defendingProvince?.hasCrawlers)! {
                    for piece in try (gameState.sharedInstance().GameBoard.crawlerLayer.children) {
                        
                        if (piece as! crawler).position == self.combatMovement.defendingProvince?.extractorPosition {
                            defenderInfo = (piece as! crawler).combatStats
                        }
                    }
                }else if (self.combatMovement.defendingProvince?.hasExtractor)! == true
                      && (self.combatMovement.defendingProvince?.hasCrawlers)! == false {
                    
                    for piece in try (gameState.sharedInstance().GameBoard.extractorLayer.children) {
                        if (piece as! extractor).extractorSprite.position == self.combatMovement.defendingProvince?.extractorPosition {
                            defenderInfo = (piece as! extractor).combatStats
                        }
                    }
                }else if (self.combatMovement.defendingProvince?.hasLandShip)! == true
                      && (self.combatMovement.defendingProvince?.hasExtractor)! == false
                      && (self.combatMovement.defendingProvince?.hasCrawlers)! == false {
                    
                    for piece in try (gameState.sharedInstance().GameBoard.landShipLayer.children) {
                        if (piece as! landship).landShipSprite.position == self.combatMovement.defendingProvince?.landShipPosition {
                            defenderInfo = (piece as! landship).combatStats
                        }
                    }
                }
            }
            
            try gameState.sharedInstance().GameBoard.boardCamera.overlayHUD.movementOptions.setCombatInformation(for: attackerInfo, and: defenderInfo)
        }catch{ print("Error in DisplayCombatInitialization")}
    }
    
    /// Creates an arrow on the map to indicate combat operation.
    private func createArrow(for piece: AnyObject, from: Province, to: Province) -> (SKShapeNode){
        var returnedArrow:SKShapeNode!
        var arrowPath:UIBezierPath!
        var color:SKColor!
        
        if piece is crawler {
            color = (piece as! crawler).crawlerNumber.fontColor
            if (to.hasCrawlers == true || to.hasExtractor == true) && to.hasLandShip == false {
                arrowPath = UIBezierPath.arrow(from: from.extractorPosition, to: self.calculatePartialMovement(start: from.extractorPosition, end: to.extractorPosition), tailWidth: 5, headWidth: 20, headLength: 10)
            }else if to.hasLandShip == true && to.hasCrawlers == true{
                arrowPath = UIBezierPath.arrow(from: from.extractorPosition, to: self.calculatePartialMovement(start: from.extractorPosition, end: to.extractorPosition), tailWidth: 5, headWidth: 20, headLength: 10)
            }else if to.hasLandShip == true{
                arrowPath = UIBezierPath.arrow(from: from.extractorPosition, to: self.calculatePartialMovement(start: from.extractorPosition, end: to.landShipPosition), tailWidth: 5, headWidth: 20, headLength: 10)
            }
        }else if piece is landship{
            color = (piece as! landship).landShipSprite.color
            if (to.hasCrawlers == true || to.hasExtractor == true) && to.hasLandShip == false {
                arrowPath = UIBezierPath.arrow(from: from.landShipPosition, to: self.calculatePartialMovement(start: from.landShipPosition, end: to.extractorPosition), tailWidth: 5, headWidth: 20, headLength: 10)
            }else if to.hasLandShip == true && to.hasCrawlers == true{
                arrowPath = UIBezierPath.arrow(from: from.landShipPosition, to: self.calculatePartialMovement(start: from.landShipPosition, end: to.extractorPosition), tailWidth: 5, headWidth: 20, headLength: 10)
            }else if to.hasLandShip == true{
                arrowPath = UIBezierPath.arrow(from: from.landShipPosition, to: self.calculatePartialMovement(start: from.landShipPosition, end: to.landShipPosition), tailWidth: 5, headWidth: 20, headLength: 10)
            }
        }
        
        returnedArrow = SKShapeNode(path: arrowPath.cgPath)
        returnedArrow.fillColor = color
        returnedArrow.strokeColor = SKColor.black
        returnedArrow.name = "AttackArrow"
        return returnedArrow
    }
    
    /// Calculates a position for the arrow so that we can see it better on the map rather than having it meld with other game pieces.
    private func calculatePartialMovement(start: CGPoint, end: CGPoint) -> CGPoint{
        var newDestination:CGPoint!
        if start.x <= end.x && start.y <= end.y{
            newDestination = CGPoint(x: (end.x - 20), y: (end.y - (20)))
        }else if start.x <= end.x && start.y > end.y{
            newDestination = CGPoint(x: (end.x - 20), y: (end.y + (20)))
        }else if start.x > end.x && start.y <= end.y{
            newDestination = CGPoint(x: (end.x + 20), y: (end.y - (20)))
        }else if start.x > end.x && start.y > end.y{
            newDestination = CGPoint(x: (end.x + 20), y: (end.y + (20)))
        }
        return newDestination
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.combatMovement = (aDecoder.decodeObject(forKey: "combatInfo") as? combatInformation)!
        self.hasCompletedMove = aDecoder.decodeBool(forKey: "hasmoved")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.combatMovement, forKey: "combatInfo")
        aCoder.encode(self.hasCompletedMove, forKey: "hasmoved")
    }
}
