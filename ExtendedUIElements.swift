//
//  ExtendedUIElements.swift
//  project-mars
//
//  Created by Aleksandr Grin on 2/11/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class extendedUI: SKNode {
    
    var extendedLowerBar:SKSpriteNode!
    var extendedUpperBar:SKSpriteNode!
    
    var crawlersPlaceOne:SpriteButton!
    var crawlersPlaceFive:SpriteButton!
    var crawlersPlaceAll:SpriteButton!

    var crawlersAvailable:SKLabelNode!
    var mineralsCollected:SKLabelNode!
    
    var selectionIndicator:SKShapeNode!
    
    var extendedUIEnabled:Bool = false
    
    init(size: CGSize){
        super.init()
        self.createExtendedBars(size: size)
        self.createCrawlerPlacemenetButtons()
        self.createResourceLabels(size: size)
        self.extendedLowerBar.isHidden = true
    }
    func updateProductionIndicators(for player: Player){
        var currentCrawlers:Int = 0
        var willBeBuilt:Int = 0
        do{
            for unit in (try gameState.sharedInstance().GameBoard.crawlerLayer.children) {
                if (unit as! crawler).name == "crawler-\(player.playerName!)" {
                    currentCrawlers += Int((unit as! crawler).crawlerNumber.text!)!
                }
            }
        }catch{ print("Error in UpdateProductionIndicators") }
        willBeBuilt = player.unitsBeingBuilt
        
        self.crawlersAvailable.text = "\(currentCrawlers) Crawlers (+\(willBeBuilt))"
        if player.color == SKColor.red {
            self.crawlersAvailable.fontColor = SKColor.init(colorLiteralRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
        }else{
            self.crawlersAvailable.fontColor = player.color
        }
        
        self.mineralsCollected.text = "\(player.mineralsCollected) Resources (+\(player.mineralsBeingCollected))"
        if player.color == SKColor.red {
            self.mineralsCollected.fontColor = SKColor.init(colorLiteralRed: 0.8, green: 0.0, blue: 0.0, alpha: 1.0)
        }else{
            self.mineralsCollected.fontColor = player.color
        }
    }
    
    func disableCrawlerPlacementUI(){
        self.extendedLowerBar.isHidden = true
        self.extendedUIEnabled = false
    }
    func enableCrawlerPlacementUI(){
        self.extendedLowerBar.isHidden = false
        self.extendedUIEnabled = true
    }
    
    func setDeployButtonsBasedOn(player: Player){
        do{
            let scene = try gameState.sharedInstance().GameBoard.boardMap.scene
            
            let toDeploy = player.unitsBeingBuilt
            if toDeploy <= 4 {
                self.crawlersPlaceFive.alpha = 0.25
                self.crawlersPlaceAll.alpha = 0.25
                self.setSelectionIndicator(for: CGPoint(x: self.crawlersPlaceFive.position.x - 200, y: self.crawlersPlaceFive.position.y))
                (scene as! GameScene).GameLoop.crawlerDeployAmount = 1
            }else if toDeploy == 5{
                self.crawlersPlaceFive.alpha = 1.0
                self.crawlersPlaceAll.alpha = 0.25
                self.setSelectionIndicator(for: CGPoint(x: self.crawlersPlaceFive.position.x - 100, y: self.crawlersPlaceFive.position.y))
                (scene as! GameScene).GameLoop.crawlerDeployAmount = 5
            }else if toDeploy >= 6 {
                self.crawlersPlaceFive.alpha = 1.0
                self.crawlersPlaceAll.alpha = 1.0
                self.setSelectionIndicator(for: CGPoint(x: self.crawlersPlaceFive.position.x, y: self.crawlersPlaceFive.position.y))
                (scene as! GameScene).GameLoop.crawlerDeployAmount = 10000
            }
        }catch{ print("Error in setDeployButtons") }
    }
    func setSelectionIndicator(for position: CGPoint){
        self.selectionIndicator.position = position
    }
    func setSelectionIndicatorPosition(for amount: Int){
        if amount <= 4 {
            self.setSelectionIndicator(for: CGPoint(x: self.crawlersPlaceFive.position.x - 200, y: self.crawlersPlaceFive.position.y))
        }else if amount == 5{
            self.setSelectionIndicator(for: CGPoint(x: self.crawlersPlaceFive.position.x - 100, y: self.crawlersPlaceFive.position.y))
        }else if amount >= 6{
            self.setSelectionIndicator(for: CGPoint(x: self.crawlersPlaceFive.position.x, y: self.crawlersPlaceFive.position.y))
        }
    }
    private func createExtendedBars(size: CGSize){
        let image = SKTexture(imageNamed: "Label_BG_final")
        self.extendedUpperBar = SKSpriteNode(texture: image)
        self.extendedUpperBar.size = CGSize(width: size.width * 3, height: size.height / 24)
        self.extendedUpperBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.extendedUpperBar.color = SKColor.gray
        self.extendedUpperBar.position = CGPoint(x: 0, y: (size.height / 2) - 55)
        self.extendedUpperBar.zPosition = 4
        self.extendedUpperBar.zRotation = 3.1415
        
        self.addChild(extendedUpperBar)
        
        self.extendedLowerBar = SKSpriteNode(texture: image)
        self.extendedLowerBar.alpha = 1.0
        self.extendedLowerBar.size = CGSize(width: size.width * 3, height: size.height / 20)
        self.extendedLowerBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.extendedLowerBar.color = SKColor.gray
        self.extendedLowerBar.position = CGPoint(x: 0, y: -(size.height / 2) + 55)
        self.extendedLowerBar.zPosition = 12
        
        self.addChild(extendedLowerBar)
    }
    private func createCrawlerPlacemenetButtons(){
        crawlersPlaceOne = SpriteButton()
        crawlersPlaceFive = SpriteButton()
        crawlersPlaceAll = SpriteButton()
        crawlersPlaceFive.changeButtonSize(to: CGSize(width: 80, height: 30))
        crawlersPlaceFive.changeButtonText(to: "Place 5")
        crawlersPlaceFive.name = "place5"
        crawlersPlaceFive.zPosition = 4
        crawlersPlaceFive.position = CGPoint(x: 0, y: 0)
        self.extendedLowerBar.addChild(crawlersPlaceFive)
        
        crawlersPlaceOne.changeButtonSize(to: CGSize(width: 80, height: 30))
        crawlersPlaceOne.changeButtonText(to: "Place 1")
        crawlersPlaceOne.zPosition = 4
        crawlersPlaceOne.name = "place1"
        crawlersPlaceOne.position = CGPoint(x: self.crawlersPlaceFive.position.x - 100, y: 0)
        self.extendedLowerBar.addChild(crawlersPlaceOne)
        
        crawlersPlaceAll.changeButtonSize(to: CGSize(width: 80, height: 30))
        crawlersPlaceAll.changeButtonText(to: "Place All")
        crawlersPlaceAll.zPosition = 4
        crawlersPlaceAll.name = "placeAll"
        crawlersPlaceAll.position = CGPoint(x: self.crawlersPlaceFive.position.x + 100, y: 0)
        self.extendedLowerBar.addChild(crawlersPlaceAll)
        
        selectionIndicator = SKShapeNode(rect: self.crawlersPlaceAll.frame)
        selectionIndicator.strokeColor = SKColor.white
        selectionIndicator.zPosition = 5
        self.extendedLowerBar.addChild(selectionIndicator)
    }
    private func createResourceLabels(size: CGSize){
        self.crawlersAvailable = SKLabelNode()
        self.mineralsCollected = SKLabelNode()
        
        self.crawlersAvailable.text = "0 Crawlers (+0)"
        self.crawlersAvailable.fontName = "AvenirNext-Bold"
        self.crawlersAvailable.fontSize = 14
        self.crawlersAvailable.fontColor = SKColor.white
        self.crawlersAvailable.zPosition = 4
        self.crawlersAvailable.zRotation = CGFloat(Double.pi)
        self.crawlersAvailable.isUserInteractionEnabled = false
        self.crawlersAvailable.position = CGPoint(x: -(size.width / 2) + 80, y: 5)
        self.extendedUpperBar.addChild(self.crawlersAvailable)
        
        self.mineralsCollected.text = "0 resources (+0)"
        self.mineralsCollected.fontName = "AvenirNext-Bold"
        self.mineralsCollected.fontSize = 14
        self.mineralsCollected.fontColor = SKColor.white
        self.mineralsCollected.zPosition = 4
        self.mineralsCollected.zRotation = CGFloat(Double.pi)
        self.mineralsCollected.isUserInteractionEnabled = false
        self.mineralsCollected.position = CGPoint(x: (size.width / 2) - 80, y: 5)
        self.extendedUpperBar.addChild(self.mineralsCollected)
    }
    func updateUIforOrientation(size: CGSize){
        self.extendedUpperBar.position = CGPoint(x: 0, y: (size.height / 2) - 55)
        self.extendedLowerBar.position = CGPoint(x: 0, y: -(size.height / 2) + 55)
        
        self.crawlersPlaceFive.position = CGPoint(x: 0, y: 0)
        self.crawlersPlaceOne.position = CGPoint(x: self.crawlersPlaceFive.position.x - 100, y: 0)
        self.crawlersPlaceAll.position = CGPoint(x: self.crawlersPlaceFive.position.x + 100, y: 0)
        
        self.crawlersAvailable.position = CGPoint(x: -(size.width / 2) + 80, y: 5)
        self.mineralsCollected.position = CGPoint(x: (size.width / 2) - 80, y: 5)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.extendedLowerBar = aDecoder.decodeObject(forKey: "extendedLowerBar") as? SKSpriteNode!
        self.extendedUpperBar = aDecoder.decodeObject(forKey: "extendedUpperBar") as? SKSpriteNode!
        
        self.crawlersPlaceOne = aDecoder.decodeObject(forKey: "placeOne") as? SpriteButton!
        self.crawlersPlaceFive = aDecoder.decodeObject(forKey: "placeFive") as? SpriteButton!
        self.crawlersPlaceAll = aDecoder.decodeObject(forKey: "placeAll") as? SpriteButton!
        
        self.crawlersAvailable = aDecoder.decodeObject(forKey: "available") as? SKLabelNode!
        self.mineralsCollected = aDecoder.decodeObject(forKey: "mineralsCollected") as? SKLabelNode!
        self.selectionIndicator = aDecoder.decodeObject(forKey: "selectionIndicator") as? SKShapeNode!
        self.extendedUIEnabled = aDecoder.decodeBool(forKey: "Enable") 
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.extendedLowerBar, forKey: "extendedLowerBar")
        aCoder.encode(self.extendedUpperBar, forKey: "extendedUpperBar")
        aCoder.encode(self.crawlersPlaceOne, forKey: "placeOne")
        aCoder.encode(self.crawlersPlaceFive, forKey: "placeFive")
        aCoder.encode(self.crawlersPlaceAll, forKey: "placeAll")
        aCoder.encode(self.crawlersAvailable, forKey: "available")
        aCoder.encode(self.mineralsCollected, forKey: "mineralsCollected")
        aCoder.encode(self.selectionIndicator, forKey: "selectionIndicator")
        aCoder.encode(self.extendedUIEnabled, forKey: "Enable")
    }
    
}
