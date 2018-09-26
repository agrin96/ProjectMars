//
//  overlayUI.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/22/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit


class overlayUI: SKNode {
    
    var upperBar:SKSpriteNode!
    var lowerBar:SKSpriteNode!
    var returnButton:SpriteButton!
    var buildExtractorButton:SpriteButton!
    var endTurnButton:SpriteButton!
    
    var playerTurnCounter:SKLabelNode!
    var permenantTurnCounter:SKLabelNode!
    var gameInformation:SKLabelNode!
    
    var movementOptions:movementUI!
    var extendedElements:extendedUI!
    var cardSelector:cardPickingUI!
    var miniMap:SKSpriteNode!
    var miniMapUnit:CGFloat!    //The length that each province represents on the minimap.
    var miniMapPieces:Array<(section: SKSpriteNode,player: Player?)> = []
    var hasOwnerShipChanged:Bool = true
    
    var nonCombatUIActive:Bool = true
    
    func disableNonCombatUI(){
        self.nonCombatUIActive = false
        self.returnButton.alpha = 0.25
        self.endTurnButton.alpha = 0.25
        self.buildExtractorButton.alpha = 0.25
        self.cardSelector.showHideUIButton.alpha = 0.25
    }
    func enableNonCombatUI(){
        self.nonCombatUIActive = true
        self.returnButton.alpha = 1.0
        self.endTurnButton.alpha = 1.0
        self.buildExtractorButton.alpha = 1.0
        self.cardSelector.showHideUIButton.alpha = 1.0
    }
    
    init(size: CGSize){
        super.init()

        self.createButtonBars(size: size)
        self.addreturnButton(size: size)
        self.addBuildExtractorButton(size: size)
        self.createEndTurnButton(size: size)
        self.createTurnCounter(size: size)
        self.createGameInformation(size: size)
        self.setUpMovementUI(size: size)
        self.createMiniMap(size: size)
        self.setUpExtendedUI(size: size)
        
    }
    
    private func setUpMovementUI(size: CGSize){
        self.movementOptions = movementUI(size: size)
        self.movementOptions.retreatButton.position = CGPoint(x: self.lowerBar.position.x - (size.width / 3) - (size.width / 19), y: self.lowerBar.position.y + self.lowerBar.size.height)
        self.movementOptions.confirmAttackButton.position = CGPoint(x: self.movementOptions.retreatButton.position.x + 100, y: self.lowerBar.position.y + self.lowerBar.size.height)
        self.movementOptions.resolveAll.position = CGPoint(x: self.movementOptions.confirmAttackButton.position.x + 100, y: self.lowerBar.position.y + self.lowerBar.size.height)
        
        self.addChild(self.movementOptions.confirmAttackButton)
        self.addChild(self.movementOptions.retreatButton)
        self.addChild(self.movementOptions.attackerInformation)
        self.addChild(self.movementOptions.defenderInformation)
        self.addChild(self.movementOptions.currentUnitStats)
        self.addChild(self.movementOptions.attackerRoll)
        self.addChild(self.movementOptions.defenderRoll)
        self.addChild(self.movementOptions.resolveAll)
    }
    
    private func setUpExtendedUI(size: CGSize){
        self.extendedElements = extendedUI(size: size)
        self.addChild(self.extendedElements)
        self.cardSelector = cardPickingUI(size: size)
        self.addChild(self.cardSelector)
        
    }
    
    private func addreturnButton(size: CGSize){
        self.returnButton = SpriteButton()
        self.returnButton.position = CGPoint(x: -(size.width / 2) + (size.width / 7), y: 0)
        self.returnButton.changeButtonText(to: "Return")
        self.returnButton.zPosition = 10
        self.lowerBar.addChild(self.returnButton)
    }
    private func addBuildExtractorButton(size: CGSize){
        self.buildExtractorButton = SpriteButton()
        
        self.buildExtractorButton.position = CGPoint(x: self.returnButton.position.x + 1.25 * (self.returnButton.size.width), y: 0)
        self.buildExtractorButton.changeButtonText(to: "Extractor")
        self.buildExtractorButton.zPosition = 10
        self.lowerBar.addChild(self.buildExtractorButton)
    }
    private func createButtonBars(size: CGSize){
        let image = SKTexture(imageNamed: "Label_BG_final")
        self.upperBar = SKSpriteNode(texture: image)
        self.upperBar.size = CGSize(width: size.width * 3, height: size.height / 14)
        self.upperBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.upperBar.color = SKColor.gray
        self.upperBar.position = CGPoint(x: 0, y: (size.height / 2) - 20)
        self.upperBar.zPosition = 5
        self.upperBar.zRotation = 3.1415

        self.addChild(upperBar)
        
        self.lowerBar = SKSpriteNode(texture: image)
        self.lowerBar.size = CGSize(width: size.width * 3, height: size.height / 16)
        self.lowerBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.lowerBar.color = SKColor.gray
        self.lowerBar.position = CGPoint(x: 0, y: -(size.height / 2) + 20)
        self.lowerBar.zPosition = 5
        
        self.addChild(lowerBar)
    }
    private func createEndTurnButton(size: CGSize){
        self.endTurnButton = SpriteButton()
        self.endTurnButton.position = CGPoint(x: self.buildExtractorButton.position.x + 1.25 * (self.buildExtractorButton.size.width), y: 0)
        self.endTurnButton.changeButtonText(to: "End Turn")
        self.endTurnButton.zPosition = 10
        self.lowerBar.addChild(self.endTurnButton)
    }
    
    private func createTurnCounter(size: CGSize){
        self.playerTurnCounter = SKLabelNode()
        self.playerTurnCounter.fontName = "AvenirNext-Bold"
        self.playerTurnCounter.fontSize = 18
        self.playerTurnCounter.fontColor = SKColor.white
        self.playerTurnCounter.zPosition = 10
        do { self.playerTurnCounter.text = "Your turn: \(try gameState.sharedInstance().GameSettings.gamePlayers[0])" } catch { print("Error in createTurnCounter") }
        self.playerTurnCounter.isUserInteractionEnabled = false
        self.addChild(self.playerTurnCounter)
        
        self.permenantTurnCounter = SKLabelNode()
        self.permenantTurnCounter.fontName = "AvenirNext-Bold"
        self.permenantTurnCounter.fontSize = 18
        self.permenantTurnCounter.fontColor = SKColor.white
        self.permenantTurnCounter.zPosition = 10
        do { self.permenantTurnCounter.text = "\((try gameState.sharedInstance().GameSettings.gamePlayers[0].playerName)!)" }catch { print("Error in createTurnCounter2") }
        self.permenantTurnCounter.isUserInteractionEnabled = false
        self.permenantTurnCounter.position = CGPoint(x: 0 ,y: self.upperBar.position.y - (self.upperBar.size.height) + 5)
        self.addChild(self.permenantTurnCounter)
        
    }
    
    private func createGameInformation(size:CGSize){
        self.gameInformation = SKLabelNode()
        self.gameInformation.fontName = "AvenirNext-Bold"
        self.gameInformation.fontSize = 18
        self.gameInformation.fontColor = SKColor.white
        self.gameInformation.zPosition = 10
        self.gameInformation.text = "default"
        self.gameInformation.isUserInteractionEnabled = false
        self.gameInformation.isHidden = true
        self.addChild(self.gameInformation)
    }
    
    func updateTurnCounter(for player: Player, completion: @escaping ()->()){
        self.playerTurnCounter.text = "Your turn: \(player.playerName!)"
        self.playerTurnCounter.isHidden = false
        let fadeInOut = SKAction.sequence([SKAction.fadeIn(withDuration: 0.25), SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.25)])
        self.permenantTurnCounter.text = "\(player.playerName!)"
        if player.color == SKColor.red {
            self.permenantTurnCounter.fontColor = SKColor.init(colorLiteralRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
        }else{
            self.permenantTurnCounter.fontColor = player.color
        }
        self.playerTurnCounter.run(fadeInOut, completion: { () in
            completion()
        })
    }
    
    func displayGameInformation(with text: String, completion: @escaping ()->()){
        self.gameInformation.isHidden = false
        self.gameInformation.text = text
        let fadeInOut = SKAction.sequence([SKAction.fadeIn(withDuration: 0.25), SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.25)])
        self.gameInformation.run(fadeInOut, completion: { () in
            completion()
        })
    }
    
    func updateUIforOrientation(size: CGSize){
        self.extendedElements.updateUIforOrientation(size: size)
        self.lowerBar.position = CGPoint(x: 0, y: -(size.height / 2) + 20)
        self.upperBar.position = CGPoint(x: 0, y: (size.height / 2) - 20)
        self.returnButton.position = CGPoint(x: -(size.width / 2) + (size.width / 7), y: 0)
        self.buildExtractorButton.position = CGPoint(x: self.returnButton.position.x + 1.25 * (self.returnButton.size.width), y: 0)
        self.endTurnButton.position = CGPoint(x: self.buildExtractorButton.position.x + 1.25 * (self.buildExtractorButton.size.width), y: 0)
        self.permenantTurnCounter.position = CGPoint(x: 0 ,y: self.upperBar.position.y - (self.upperBar.size.height) + 5)
        self.cardSelector.updateUIforOrientation(size: size)
        
        if size.width < size.height {
            self.miniMap.position = CGPoint(x: 0, y: self.upperBar.position.y - 10)
            self.miniMap.size.width = size.width - 40
            self.miniMapUnit = (self.miniMap.frame.width / 43)
            for num in 0..<self.miniMapPieces.count {
                if num == 0 {
                    self.miniMapPieces[num].section.position = CGPoint(x: self.miniMap.frame.minX, y: self.miniMap.position.y)
                }else{
                    self.miniMapPieces[num].section.position.x = self.miniMapPieces[num - 1].section.position.x + self.miniMapPieces[num - 1].section.size.width
                    self.miniMapPieces[num].section.position.y = self.miniMap.position.y
                }
            }
        }else{
            self.miniMap.position = CGPoint(x: 0, y: self.upperBar.position.y)
            self.miniMap.size.width = size.width - 40
            self.miniMapUnit = (self.miniMap.frame.width / 43)
            for num in 0..<self.miniMapPieces.count {
                if num == 0 {
                    self.miniMapPieces[num].section.position = CGPoint(x: self.miniMap.frame.minX, y: self.miniMap.position.y)
                }else{
                    self.miniMapPieces[num].section.position.x = self.miniMapPieces[num - 1].section.position.x + self.miniMapPieces[num - 1].section.size.width
                    self.miniMapPieces[num].section.position.y = self.miniMap.position.y
                }
            }
        }
        
        self.movementOptions.retreatButton.position = CGPoint(x: self.lowerBar.position.x - (size.width / 3) - (size.width / 19), y: self.lowerBar.position.y + self.lowerBar.size.height)
        self.movementOptions.confirmAttackButton.position = CGPoint(x: self.movementOptions.retreatButton.position.x + 100, y: self.lowerBar.position.y + self.lowerBar.size.height)
        
        self.movementOptions.attackerInformation.position = CGPoint(x: -(size.width / 2) + 30, y: 0)
        self.movementOptions.defenderInformation.position = CGPoint(x: ((size.width / 2) - 30) - self.movementOptions.defenderInformation.size.width, y: 0)
        self.movementOptions.attackerRoll.position = CGPoint(x: self.movementOptions.attackerInformation.position.x, y: self.movementOptions.attackerInformation.position.y - 100)
        self.movementOptions.defenderRoll.position = CGPoint(x: self.movementOptions.defenderInformation.position.x + self.movementOptions.defenderInformation.size.width, y: self.movementOptions.defenderInformation.position.y - 100)
        self.movementOptions.resolveAll.position = CGPoint(x: self.movementOptions.confirmAttackButton.position.x + 100, y: self.lowerBar.position.y + self.lowerBar.size.height)
    }
    
    func createMiniMap(size: CGSize){
        self.miniMap = SKSpriteNode(color: SKColor.clear, size: CGSize(width: size.width - 40, height: size.height / 28))
        self.miniMap.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.miniMap.position.x = 0
        self.miniMap.position.y = self.upperBar.position.y - 10
        
        self.miniMapUnit = (self.miniMap.frame.width / 43)

        do {
            for player in try (gameState.sharedInstance().GameSettings.gamePlayers) {
                let newSection = SKSpriteNode(color: player.color, size: CGSize(width: self.miniMapUnit, height: self.miniMap.size.height))
                newSection.anchorPoint = CGPoint(x: 0.0, y: 0.5)
                newSection.position.x = self.miniMap.frame.minX
                newSection.position.y = self.miniMap.position.y
                newSection.name = "miniMap-\(player.playerName!)"
                newSection.zPosition = 5
                newSection.alpha = 0.7
                
                let count = SKLabelNode(text: String(player.builtExtractorProvinces.count))
                count.fontName = "AvenirNext-Bold"
                count.fontSize = 10
                count.fontColor = SKColor.white
                count.position = CGPoint(x: newSection.size.width / 2, y: -6)
                newSection.addChild(count)
                self.miniMapPieces.append((newSection, player))
            }
        }catch { print("Error in createMiniMap") }
        
        let newSection = SKSpriteNode(color: SKColor.brown, size: CGSize(width: self.miniMapUnit, height: self.miniMap.size.height))
        newSection.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        newSection.position.x = self.miniMap.frame.minX
        newSection.position.y = self.miniMap.position.y
        newSection.name = "miniMap-neutral"
        newSection.zPosition = 5
        newSection.alpha = 0.7
        
        let count = SKLabelNode(text: String(1))
        count.fontName = "AvenirNext-Bold"
        count.fontSize = 10
        count.fontColor = SKColor.white
        count.position = CGPoint(x: newSection.size.width / 2, y: -6)
        newSection.addChild(count)
        
        self.miniMapPieces.append((newSection, nil))
        
        for part in self.miniMapPieces {
            self.addChild(part.section)
        }
        self.addChild(self.miniMap)
        self.updateMiniMap()
        self.hasOwnerShipChanged = false
    }
    
    func updateMiniMap() {
        if self.hasOwnerShipChanged == true{
            for num in 0..<self.miniMapPieces.count {
                var ownedProvinces:CGFloat = 0
                do{
                    if num == 0 {
                        for prov in try (gameState.sharedInstance().GameBoard.Provinces){
                            if prov.owningPlayer != nil{
                                if prov.owningPlayer! == self.miniMapPieces[num].player! { ownedProvinces += 1 }
                            }
                        }
                        
                        self.miniMapPieces[num].section.size.width = self.miniMapUnit * ownedProvinces
                        if (self.miniMapPieces[num].player?.builtExtractorProvinces.count)! > 0 {
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).isHidden = false
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).text = String(self.miniMapPieces[num].player!.builtExtractorProvinces.count)
                        }else{
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).isHidden = true
                        }
                        
                        (self.miniMapPieces[num].section.children[0] as! SKLabelNode).position.x = self.miniMapPieces[num].section.size.width / 2
                        ownedProvinces = 0
                        
                        
                    }else if self.miniMapPieces[num].section.name == "miniMap-neutral"{
                        var available:Int = 0
                        for prov in try (gameState.sharedInstance().GameBoard.Provinces){
                            if prov.owningPlayer == nil { ownedProvinces += 1 }
                            if prov.isCratered == true && prov.hasExtractor == false { available += 1 }
                        }
                        self.miniMapPieces[num].section.size.width = self.miniMapUnit * ownedProvinces
                        self.miniMapPieces[num].section.position.x = self.miniMapPieces[num - 1].section.position.x + self.miniMapPieces[num - 1].section.size.width
                        
                        if available > 0 {
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).isHidden = false
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).text = String(available)
                        }else{
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).isHidden = true
                        }
                        
                        (self.miniMapPieces[num].section.children[0] as! SKLabelNode).position.x = self.miniMapPieces[num].section.size.width / 2
                        ownedProvinces = 0
                        
                    }else{
                        for prov in try (gameState.sharedInstance().GameBoard.Provinces){
                            if prov.owningPlayer != nil{
                                if prov.owningPlayer! == self.miniMapPieces[num].player! { ownedProvinces += 1 }
                            }
                        }
                        self.miniMapPieces[num].section.size.width = self.miniMapUnit * ownedProvinces
                        self.miniMapPieces[num].section.position.x = self.miniMapPieces[num - 1].section.position.x + self.miniMapPieces[num - 1].section.size.width
                        
                        
                        if self.miniMapPieces[num].player!.builtExtractorProvinces.count > 0 {
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).isHidden = false
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).text = String(self.miniMapPieces[num].player!.builtExtractorProvinces.count)
                        }else{
                            (self.miniMapPieces[num].section.children[0] as! SKLabelNode).isHidden = true
                        }
                        (self.miniMapPieces[num].section.children[0] as! SKLabelNode).position.x = self.miniMapPieces[num].section.size.width / 2
                        ownedProvinces = 0
                    }
                }catch{ print("Error in updateMiniMap") }
            self.hasOwnerShipChanged = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.upperBar = aDecoder.decodeObject(forKey: "upperBar") as? SKSpriteNode!
        self.lowerBar = aDecoder.decodeObject(forKey: "lowerBar") as? SKSpriteNode!
        self.returnButton = aDecoder.decodeObject(forKey: "returnButton") as? SpriteButton!
        self.buildExtractorButton = aDecoder.decodeObject(forKey: "buildExtractor") as? SpriteButton!
        self.endTurnButton = aDecoder.decodeObject(forKey: "endTurn") as? SpriteButton!
        
        self.playerTurnCounter = aDecoder.decodeObject(forKey: "playerTurnCounter") as? SKLabelNode!
        self.permenantTurnCounter = aDecoder.decodeObject(forKey: "permTurnCounter") as? SKLabelNode!
        self.gameInformation = aDecoder.decodeObject(forKey: "gameInformation") as? SKLabelNode!
        
        self.movementOptions = aDecoder.decodeObject(forKey: "movementOptions") as? movementUI!
        self.extendedElements = aDecoder.decodeObject(forKey: "extendedElements") as? extendedUI!
        self.cardSelector = aDecoder.decodeObject(forKey: "cardSelector") as? cardPickingUI!
        
        self.miniMap = aDecoder.decodeObject(forKey: "miniMap") as? SKSpriteNode!
        self.miniMapUnit = aDecoder.decodeObject(forKey: "miniMapUnit") as? CGFloat!
        //self.miniMapPieces = (aDecoder.decodeObject(forKey: "miniMapPieces") as? Array<(section: SKSpriteNode, player: Player?)>)!
        self.hasOwnerShipChanged = aDecoder.decodeBool(forKey: "hasOwnerShipChanged")
        self.nonCombatUIActive = aDecoder.decodeBool(forKey: "nonCombatUI")
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.upperBar, forKey: "upperBar")
        aCoder.encode(self.lowerBar, forKey: "lowerBar")
        aCoder.encode(self.returnButton, forKey: "returnButton")
        aCoder.encode(self.buildExtractorButton, forKey: "buildExtractor")
        aCoder.encode(self.endTurnButton, forKey: "endTurn")
        aCoder.encode(self.playerTurnCounter, forKey: "playerTurnCounter")
        aCoder.encode(self.permenantTurnCounter, forKey: "permTurnCounter")
        aCoder.encode(self.gameInformation, forKey: "gameInformation")
        aCoder.encode(self.movementOptions, forKey: "movementOptions")
        aCoder.encode(self.extendedElements, forKey: "extendedElements")
        aCoder.encode(self.cardSelector, forKey: "cardSelector")
        aCoder.encode(self.miniMap, forKey: "miniMap")
        aCoder.encode(self.miniMapUnit, forKey: "miniMapUnit")
        //aCoder.encode(self.miniMapPieces, forKey: "miniMapPieces")
        aCoder.encode(self.hasOwnerShipChanged, forKey: "hasOwnerShipChanged")
        aCoder.encode(self.nonCombatUIActive, forKey: "nonCombatUI")
    }
    
}
