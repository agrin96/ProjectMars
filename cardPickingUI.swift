//
//  cardPickingUI.swift
//  project-mars
//
//  Created by Aleksandr Grin on 2/23/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class cardPickingUI: SKNode {
    
    var showHideUIButton:SpriteButton!
    var cancelButton:SpriteButton!
    
    var fullCardSelectionUI:SKSpriteNode!
    var deOrbitAsteroidCard:SpriteButton!
    var factoryDropCard:SpriteButton!
    var crawlerDropCard:SpriteButton!
    var repairTeamsCard:SpriteButton!
    var closeCardMenu:SpriteButton!
    var labelsList:Array<SKLabelNode> = []
    
    init(size: CGSize){
        super.init()
        self.addShowHideButton(size: size)
        self.createMainUIPage(size: size)
        self.hideCardSelectionUI()
        self.addCancelButton(size: size)
        self.addCardButtons(size: size)

    }
    private func addShowHideButton(size: CGSize){
        self.showHideUIButton = SpriteButton()
        self.showHideUIButton.changeButtonText(to: "Cards")
        self.showHideUIButton.changeButtonSize(to: CGSize(width: size.width / 5, height: size.height / 14))
        self.showHideUIButton.position = CGPoint(x: size.width / 2 - 30, y: size.height / 5)
        self.showHideUIButton.zPosition = 5
        self.addChild(self.showHideUIButton)
    }
    private func addCancelButton(size: CGSize){
        self.cancelButton = SpriteButton()
        self.cancelButton.changeButtonText(to: "Cancel")
        self.cancelButton.changeButtonSize(to: CGSize(width: size.width / 5, height: size.height / 14))
        self.cancelButton.position = CGPoint(x: size.width / 2 - 30, y: self.showHideUIButton.position.y - self.showHideUIButton.size.height - 10)
        self.cancelButton.zPosition = 5
        self.cancelButton.isHidden = true
        self.addChild(self.cancelButton)
    }
    private func createMainUIPage(size: CGSize){
        self.fullCardSelectionUI = SKSpriteNode()
        self.fullCardSelectionUI.texture = SKTexture(imageNamed: "Secondary_BG_final")
        self.fullCardSelectionUI.size = CGSize(width: size.width - (size.width / 8), height: size.height - (size.height / 4))
        self.fullCardSelectionUI.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.fullCardSelectionUI.position = CGPoint(x: 0, y: 0)
        self.fullCardSelectionUI.zPosition = 10
        self.addChild(self.fullCardSelectionUI)
    }
    private func addCardButtons(size: CGSize){
        let spacingOffset:CGFloat = 16
        let buttonWidth:CGFloat = 200
        let interOptionSpacingFactor:CGFloat = 3
        let labelSpacingFactor:CGFloat = 1.25
        
        self.deOrbitAsteroidCard = SpriteButton()
        self.deOrbitAsteroidCard.changeButtonText(to: "De-Orbit Asteroid")
        self.deOrbitAsteroidCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
        self.deOrbitAsteroidCard.position = CGPoint(x: 0, y: self.fullCardSelectionUI.size.height / 2 - (self.fullCardSelectionUI.size.height / 10))
        self.deOrbitAsteroidCard.zPosition = 11
        self.deOrbitAsteroidCard.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.fullCardSelectionUI.addChild(self.deOrbitAsteroidCard)
        
        let Asteroidlabel1 = SKLabelNode(text: "Cost: 30 minerals. You can have an asteroid dropped on a ")
        Asteroidlabel1.position = CGPoint(x: 0, y: self.deOrbitAsteroidCard.position.y - self.deOrbitAsteroidCard.size.height*labelSpacingFactor)
        Asteroidlabel1.fontColor = SKColor.white
        Asteroidlabel1.fontName = "AvenirNext-Bold"
        Asteroidlabel1.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(Asteroidlabel1)
        self.labelsList.append(Asteroidlabel1)
        let Asteroidlabel2 = SKLabelNode(text: "province to deal 10 damage to everything in the province.")
        Asteroidlabel2.position = CGPoint(x: 0, y: self.deOrbitAsteroidCard.position.y - self.deOrbitAsteroidCard.size.height*labelSpacingFactor - 15)
        Asteroidlabel2.fontColor = SKColor.white
        Asteroidlabel2.fontName = "AvenirNext-Bold"
        Asteroidlabel2.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(Asteroidlabel2)
        self.labelsList.append(Asteroidlabel2)
        
        self.factoryDropCard = SpriteButton()
        self.factoryDropCard.changeButtonText(to: "Drop Extractor")
        self.factoryDropCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
        self.factoryDropCard.position = CGPoint(x: 0, y: self.deOrbitAsteroidCard.position.y - self.deOrbitAsteroidCard.size.height*interOptionSpacingFactor)
        self.factoryDropCard.zPosition = 11
        self.factoryDropCard.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.fullCardSelectionUI.addChild(self.factoryDropCard)
        
        let ExtractorLabel1 = SKLabelNode(text: "Cost: 10 minerals. You can have an extractor deployed on a ")
        ExtractorLabel1.position = CGPoint(x: 0, y: self.factoryDropCard.position.y - self.factoryDropCard.size.height*labelSpacingFactor)
        ExtractorLabel1.fontColor = SKColor.white
        ExtractorLabel1.fontName = "AvenirNext-Bold"
        ExtractorLabel1.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(ExtractorLabel1)
        self.labelsList.append(ExtractorLabel1)
        let ExtractorLabel2 = SKLabelNode(text: "province you control where the landship is not present.")
        ExtractorLabel2.position = CGPoint(x: 0, y: self.factoryDropCard.position.y - self.factoryDropCard.size.height*labelSpacingFactor - 15)
        ExtractorLabel2.fontColor = SKColor.white
        ExtractorLabel2.fontName = "AvenirNext-Bold"
        ExtractorLabel2.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(ExtractorLabel2)
        self.labelsList.append(ExtractorLabel2)
        
        self.crawlerDropCard = SpriteButton()
        self.crawlerDropCard.changeButtonText(to: "Drop Crawlers")
        self.crawlerDropCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
        self.crawlerDropCard.position = CGPoint(x: 0, y: self.factoryDropCard.position.y - self.factoryDropCard.size.height*interOptionSpacingFactor)
        self.crawlerDropCard.zPosition = 11
        self.crawlerDropCard.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.fullCardSelectionUI.addChild(self.crawlerDropCard)
        
        let CrawlerLabel1 = SKLabelNode(text: "Cost: 20 minerals. You can have a detatchement of 5 ")
        CrawlerLabel1.position = CGPoint(x: 0, y: self.crawlerDropCard.position.y - self.crawlerDropCard.size.height*labelSpacingFactor)
        CrawlerLabel1.fontColor = SKColor.white
        CrawlerLabel1.fontName = "AvenirNext-Bold"
        CrawlerLabel1.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(CrawlerLabel1)
        self.labelsList.append(CrawlerLabel1)
        let CrawlerLabel2 = SKLabelNode(text: "crawlers deployed on a province you control.")
        CrawlerLabel2.position = CGPoint(x: 0, y: self.crawlerDropCard.position.y - self.crawlerDropCard.size.height*labelSpacingFactor - 15)
        CrawlerLabel2.fontColor = SKColor.white
        CrawlerLabel2.fontName = "AvenirNext-Bold"
        CrawlerLabel2.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(CrawlerLabel2)
        self.labelsList.append(CrawlerLabel2)
        
        self.repairTeamsCard = SpriteButton()
        self.repairTeamsCard.changeButtonText(to: "Landship Repair Teams")
        self.repairTeamsCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
        self.repairTeamsCard.position = CGPoint(x: 0, y: self.crawlerDropCard.position.y - self.crawlerDropCard.size.height*interOptionSpacingFactor)
        self.repairTeamsCard.zPosition = 11
        self.repairTeamsCard.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.fullCardSelectionUI.addChild(self.repairTeamsCard)
        
        let repairLabel1 = SKLabelNode(text: "Cost: 10 minerals. Minerals are used to do emergency ")
        repairLabel1.position = CGPoint(x: 0, y: self.repairTeamsCard.position.y - self.repairTeamsCard.size.height*labelSpacingFactor)
        repairLabel1.fontColor = SKColor.white
        repairLabel1.fontName = "AvenirNext-Bold"
        repairLabel1.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(repairLabel1)
        self.labelsList.append(repairLabel1)
        let repairLabel2 = SKLabelNode(text: "repairs on your landship and restore it to full health.")
        repairLabel2.position = CGPoint(x: 0, y: self.repairTeamsCard.position.y - self.repairTeamsCard.size.height*labelSpacingFactor - 15)
        repairLabel2.fontColor = SKColor.white
        repairLabel2.fontName = "AvenirNext-Bold"
        repairLabel2.fontSize = 10
        self.name = "Default"
        self.fullCardSelectionUI.addChild(repairLabel2)
        self.labelsList.append(repairLabel2)
        
        self.closeCardMenu = SpriteButton()
        self.closeCardMenu.changeButtonText(to: "Exit Card Menu")
        self.closeCardMenu.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
        self.closeCardMenu.position = CGPoint(x: 0, y: self.repairTeamsCard.position.y - self.repairTeamsCard.size.height*interOptionSpacingFactor)
        self.closeCardMenu.zPosition = 11
        self.closeCardMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.fullCardSelectionUI.addChild(self.closeCardMenu)
    }
    func hideCardSelectionUI(){
        self.fullCardSelectionUI.isHidden = true
    }
    func showCardSelectionUI(){
        self.fullCardSelectionUI.isHidden = false
    }

    func updateUIforOrientation(size: CGSize){
        
        let spacingOffset:CGFloat = 16
        let buttonWidth:CGFloat = 200
        let interOptionSpacingFactor:CGFloat = 3
        let labelSpacingFactor:CGFloat = 1.25
        
        if self.fullCardSelectionUI != nil {
            self.showHideUIButton.position = CGPoint(x: size.width / 2 - 30, y: size.height / 5)
            self.cancelButton.position = CGPoint(x: size.width / 2 - 30, y: self.showHideUIButton.position.y - self.showHideUIButton.size.height - 10)
            self.fullCardSelectionUI.size = CGSize(width: size.width - (size.width / 8), height: size.height - (size.height / 4))
            self.fullCardSelectionUI.position = CGPoint(x: 0, y: 0)
            
            self.deOrbitAsteroidCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
            self.deOrbitAsteroidCard.position = CGPoint(x: 0, y: self.fullCardSelectionUI.size.height / 2 - (self.fullCardSelectionUI.size.height / 10))
            self.labelsList[0].position = CGPoint(x: 0, y: self.deOrbitAsteroidCard.position.y - self.deOrbitAsteroidCard.size.height*labelSpacingFactor)
            self.labelsList[1].position = CGPoint(x: 0, y: self.deOrbitAsteroidCard.position.y - self.deOrbitAsteroidCard.size.height*labelSpacingFactor - 15)
            
            self.factoryDropCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
            self.factoryDropCard.position = CGPoint(x: 0, y: self.deOrbitAsteroidCard.position.y - self.deOrbitAsteroidCard.size.height*interOptionSpacingFactor)
            self.labelsList[2].position = CGPoint(x: 0, y: self.factoryDropCard.position.y - self.factoryDropCard.size.height*labelSpacingFactor)
            self.labelsList[3].position = CGPoint(x: 0, y: self.factoryDropCard.position.y - self.factoryDropCard.size.height*labelSpacingFactor - 15)
            
            self.crawlerDropCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
            self.crawlerDropCard.position = CGPoint(x: 0, y: self.factoryDropCard.position.y - self.factoryDropCard.size.height*interOptionSpacingFactor)
            self.labelsList[4].position = CGPoint(x: 0, y: self.crawlerDropCard.position.y - self.crawlerDropCard.size.height*labelSpacingFactor)
            self.labelsList[5].position = CGPoint(x: 0, y: self.crawlerDropCard.position.y - self.crawlerDropCard.size.height*labelSpacingFactor - 15)
            
            self.repairTeamsCard.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
            self.repairTeamsCard.position = CGPoint(x: 0, y: self.crawlerDropCard.position.y - self.crawlerDropCard.size.height*interOptionSpacingFactor)
            self.labelsList[6].position = CGPoint(x: 0, y: self.repairTeamsCard.position.y - self.repairTeamsCard.size.height*labelSpacingFactor)
            self.labelsList[7].position = CGPoint(x: 0, y: self.repairTeamsCard.position.y - self.repairTeamsCard.size.height*labelSpacingFactor - 15)
            
            self.closeCardMenu.changeButtonSize(to: CGSize(width: buttonWidth, height: self.fullCardSelectionUI.size.height / spacingOffset))
            self.closeCardMenu.position = CGPoint(x: 0, y: self.repairTeamsCard.position.y - self.repairTeamsCard.size.height*interOptionSpacingFactor)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.showHideUIButton = aDecoder.decodeObject(forKey: "showHideUIButton") as? SpriteButton!
        self.fullCardSelectionUI = aDecoder.decodeObject(forKey: "fullCardSelectionUI") as? SKSpriteNode!
        self.cancelButton = aDecoder.decodeObject(forKey: "cancel") as? SpriteButton!
        self.deOrbitAsteroidCard = aDecoder.decodeObject(forKey: "deOrbit") as? SpriteButton!
        self.factoryDropCard = aDecoder.decodeObject(forKey: "factory") as? SpriteButton!
        self.crawlerDropCard = aDecoder.decodeObject(forKey: "crawler") as? SpriteButton!
        self.repairTeamsCard = aDecoder.decodeObject(forKey: "repair") as? SpriteButton!
        self.closeCardMenu = aDecoder.decodeObject(forKey: "closeMenu") as? SpriteButton!
        self.labelsList = (aDecoder.decodeObject(forKey: "labels") as? Array<SKLabelNode>)!
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.showHideUIButton, forKey: "showHideUIButton")
        aCoder.encode(self.fullCardSelectionUI, forKey: "fullCardSelectionUI")
        aCoder.encode(self.cancelButton, forKey: "cancel")
        aCoder.encode(self.deOrbitAsteroidCard, forKey: "deOrbit")
        aCoder.encode(self.factoryDropCard, forKey: "factory")
        aCoder.encode(self.crawlerDropCard, forKey: "crawler")
        aCoder.encode(self.repairTeamsCard, forKey: "repair")
        aCoder.encode(self.closeCardMenu, forKey: "closeMenu")
        aCoder.encode(self.labelsList, forKey: "labels")
    }
    
}
