//
//  startGameView.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/17/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

fileprivate let enabledColor:UIColor = UIColor.init(red: 0.7, green: 0.1, blue: 0.1, alpha: 0.6)
fileprivate let disabledColor:UIColor = UIColor.clear

class playerSelectionOptions: UIScrollView{
    
    var activatedPlayers:Int!
    var activationButtons:Array<(human: UIButton, computer: UIButton)> = []
    var activationTextfields:Array<UITextField> = []
    var flavorTextStorage:Array<String> = []
    var currentPlayers:Array<Player> = []
    
    var colors:Array<SKColor> = [SKColor.red,
                                 SKColor.blue,
                                 SKColor.cyan,
                                 SKColor.purple,
                                 SKColor.yellow,
                                 SKColor.green]
    var defaultPlayerNames:Array<String> = ["Player1", "Player2", "Player3", "Player4", "Player5", "Player6"]
    
    @IBOutlet weak var playerOneText:UITextField!
    @IBOutlet weak var playerTwoText:UITextField!
    @IBOutlet weak var playerThreeText:UITextField!
    @IBOutlet weak var playerFourText:UITextField!
    @IBOutlet weak var playerFiveText:UITextField!
    @IBOutlet weak var playerSixText:UITextField!
    
    @IBOutlet weak var humanOne:UIButton!
    @IBOutlet weak var humanTwo:UIButton!
    @IBOutlet weak var humanThree:UIButton!
    @IBOutlet weak var humanFour:UIButton!
    @IBOutlet weak var humanFive:UIButton!
    @IBOutlet weak var humanSix:UIButton!
    
    @IBOutlet weak var compOne:UIButton!
    @IBOutlet weak var compTwo:UIButton!
    @IBOutlet weak var compThree:UIButton!
    @IBOutlet weak var compFour:UIButton!
    @IBOutlet weak var compFive:UIButton!
    @IBOutlet weak var compSix:UIButton!
    
    @IBOutlet weak var flavorText:UILabel!
    
    public func importSettings(settings: gameSettings){
        self.activatedPlayers = settings.totalPlayers
        self.activationButtons = [(self.humanOne, self.compOne),
                                  (self.humanTwo, self.compTwo),
                                  (self.humanThree, self.compThree),
                                  (self.humanFour, self.compFour),
                                  (self.humanFive, self.compFive),
                                  (self.humanSix, self.compSix)]
        self.activationTextfields = [self.playerOneText,
                                     self.playerTwoText,
                                     self.playerThreeText,
                                     self.playerFourText,
                                     self.playerFiveText,
                                     self.playerSixText]
        self.disableAllFields()
        self.enableForPlayers()
        self.addFlavorText()
        self.createNewPlayers()
        
    }
    
    private func createNewPlayers(){
        for i in 0..<self.activatedPlayers{
            let player = Player(color: colors[i], Name: defaultPlayerNames[i])
            if activationButtons[i].human.backgroundColor == enabledColor{
                player.isPlayerHuman = true
            }else if activationButtons[i].computer.backgroundColor == enabledColor{
                player.isPlayerHuman = false
            }
            self.currentPlayers.append(player)
        }
    }
    
    private func disableAllFields(){
        for tuple in self.activationButtons{
            tuple.human.isUserInteractionEnabled = false
            tuple.human.alpha = 0.5
            
            tuple.computer.isUserInteractionEnabled = false
            tuple.computer.alpha = 0.5
        }
        for field in self.activationTextfields{
            field.isUserInteractionEnabled = false
            field.text = " "
            field.alpha = 0.5
        }
    }
    private func enableForPlayers(){
        for i in 0..<self.activatedPlayers{
            self.activationButtons[i].human.isUserInteractionEnabled = true
            self.activationButtons[i].human.alpha = 1.0
            if i == 0{
                self.activationButtons[i].human.backgroundColor = enabledColor
            }
            
            self.activationButtons[i].computer.isUserInteractionEnabled = true
            self.activationButtons[i].computer.alpha = 1.0
            if i > 0{
                self.activationButtons[i].computer.backgroundColor = enabledColor
            }
            
            self.activationTextfields[i].isUserInteractionEnabled = true
            self.activationTextfields[i].text = "Player Name"
            self.activationTextfields[i].alpha = 1.0
        }
    }
    private func addFlavorText(){
        let text = " The pride of North American engineering efforts, this landship features a classic 6 wheeled chassis with extensive industrial and military capabilites. Fast and able to tackle terrain that other vehicles would find issue with, this is the most extensively used rover on the red planet."
        
        let jtext = " This awe inspiring creation is the product of cooperation between European designers. A trade secret reactor core powers massive levatation systems capable of keeping the cylindrical machine moving. While it is slower to move, terrain is largely an irrelavent factor."
        
        let rtext = " Eurasian engineers kept this design true to decades of experience. A robust and simple vehicle with a low profile boasting the largest caterpiller tracks ever built. A true monster of the red planet it is nicknamed 'turtle' for its resemblence to the animal. "
        flavorTextStorage.append(text)
        flavorTextStorage.append(jtext)
        flavorTextStorage.append(rtext)
    }
    
    /// This function saves all the settings into the global instanc ebefore we segue into the actual game.
    func finalizeGameSettings(){
        let skView = self.subviews[0].subviews[2] as! SKView
        let skScene = skView.scene as! vehicleSelect
        
        var n = 0
        for player in self.currentPlayers{
            if player.isPlayerHuman == false{
                player.chosenLandShip = skScene.vehicleList[n * 3].landShip
                player.chosenExtractor = skScene.vehicleList[n * 3].extractor
            }
            n += 1
            //Assures that the sprites are used only for copying and do not have dependencies.
            player.chosenLandShip.removeFromParent()
            player.chosenExtractor.removeFromParent()
        }
        
        for i in 0..<self.currentPlayers.count {
            if self.activationTextfields[i].text == "" || self.activationTextfields[i].text == "Player Name"{
                self.currentPlayers[i].playerName = self.defaultPlayerNames[i]
            }else{
                self.currentPlayers[i].playerName = self.activationTextfields[i].text
            }
        }
        do{ try gameState.sharedInstance().GameSettings.gamePlayers = self.currentPlayers }catch{ print("Error in finalizeGameSettings") }
    }
    
    private func addAdditionalHumanLandShips(){
        var n = 0
        for tuple in self.activationButtons{
            if tuple.human.backgroundColor == enabledColor {
                n += 1
            }
        }
        
        let skView = self.subviews[0].subviews[2] as! SKView
        let skScene = skView.scene as! vehicleSelect
        let vRange = SKRange(lowerLimit: -200 * CGFloat(n - 1),
                             upperLimit: 0)
        let hRange = SKRange(lowerLimit: 0,
                             upperLimit: (200 * CGFloat(3)))
        skScene.mainCamera.changeScrollRange(hRange: hRange, vRange: vRange)
        
        n = 0
        var i = 0
        let yoffset = 200
        for tuple in self.activationButtons{
            if tuple.human.backgroundColor == enabledColor {
                skScene.vehicleList[(3 * n)].landShip.modifySpawnPosition(position: CGPoint(x: 0 , y: 0 - (i * yoffset)))
                skScene.vehicleList[(3 * n)].landShip.isHidden = false
                skScene.vehicleList[(3 * n)].landShip.isUserInteractionEnabled = true
                skScene.vehicleList[(3 * n)].extractor.modifySpawnPosition(position: CGPoint(x: 0 + 50, y: 0 - (i * yoffset) - 50))
                skScene.vehicleList[(3 * n)].extractor.isUserInteractionEnabled = true
                skScene.vehicleList[(3 * n)].extractor.isHidden = false
                
                if skScene.vehicleList[(3 * n)].landShip.landShipSprite.childNode(withName: "player") != nil{
                    skScene.vehicleList[(3 * n)].landShip.landShipSprite.childNode(withName: "player")?.removeFromParent()
                }
                
                let label = SKLabelNode(text: "Player\(i + 1)")
                label.fontSize = 24
                label.fontColor = SKColor.white
                label.fontName = "System Heavy"
                label.position = CGPoint(x: skScene.vehicleList[(3 * n)].landShip.position.x - 50,
                                         y: skScene.vehicleList[(3 * n)].landShip.position.y + 50)
                label.zPosition = 1
                label.name = "player"
                if skScene.vehicleList[(3 * n)].landShip.landShipSprite.childNode(withName: "initlabel") != nil{
                    skScene.vehicleList[(3 * n)].landShip.landShipSprite.childNode(withName: "initlabel")?.removeFromParent()
                }else{
                    skScene.vehicleList[(3 * n)].landShip.landShipSprite.addChild(label)
                }
                
                skScene.vehicleList[(3 * n) + 1].landShip.modifySpawnPosition(position: CGPoint(x: 300, y: 0 - (i * yoffset)))
                skScene.vehicleList[(3 * n) + 1].landShip.isHidden = false
                skScene.vehicleList[(3 * n) + 1].landShip.isUserInteractionEnabled = true
                skScene.vehicleList[(3 * n) + 1].extractor.modifySpawnPosition(position: CGPoint(x: 300 + 50, y: 0 - (i * yoffset) - 50))
                skScene.vehicleList[(3 * n) + 1].extractor.isUserInteractionEnabled = true
                skScene.vehicleList[(3 * n) + 1].extractor.isHidden = false
                
                skScene.vehicleList[(3 * n) + 2].landShip.modifySpawnPosition(position: CGPoint(x: 600, y: 0 - (i * yoffset)))
                skScene.vehicleList[(3 * n) + 2].landShip.isHidden = false
                skScene.vehicleList[(3 * n) + 2].landShip.isUserInteractionEnabled = true
                skScene.vehicleList[(3 * n) + 2].extractor.modifySpawnPosition(position: CGPoint(x: 600 + 50, y: 0 - (i * yoffset) - 50))
                skScene.vehicleList[(3 * n) + 2].extractor.isUserInteractionEnabled = true
                skScene.vehicleList[(3 * n) + 2].extractor.isHidden = false
                n += 1
                i += 1
            }else if tuple.computer.backgroundColor == enabledColor {
                skScene.vehicleList[(3 * n)].landShip.isHidden = true
                skScene.vehicleList[(3 * n)].landShip.isUserInteractionEnabled = false
                skScene.vehicleList[(3 * n)].extractor.isHidden = true
                skScene.vehicleList[(3 * n)].extractor.isUserInteractionEnabled = false
                skScene.vehicleList[(3 * n)].landShip.landShipSprite.removeAllChildren()
                
                skScene.vehicleList[(3 * n) + 1].landShip.isHidden = true
                skScene.vehicleList[(3 * n) + 1].landShip.isUserInteractionEnabled = false
                skScene.vehicleList[(3 * n) + 1].extractor.isHidden = true
                skScene.vehicleList[(3 * n) + 1].extractor.isUserInteractionEnabled = false
                
                skScene.vehicleList[(3 * n) + 2].landShip.isHidden = true
                skScene.vehicleList[(3 * n) + 2].landShip.isUserInteractionEnabled = false
                skScene.vehicleList[(3 * n) + 2].extractor.isHidden = true
                skScene.vehicleList[(3 * n) + 2].extractor.isUserInteractionEnabled = false
                n += 1
            }
        }
        
        let beginButton = self.subviews[0].subviews[24] as! UIButton
        beginButton.alpha = 1.0
        beginButton.isUserInteractionEnabled = true
        for i in 0..<self.activatedPlayers{
            if self.currentPlayers[i].isPlayerHuman == true{
                if self.currentPlayers[i].chosenLandShip == nil {
                    beginButton.alpha = 0.5
                    beginButton.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    @IBAction private func playerActivationSelection(_ sender: UIButton){
        var n = 0
        
        for tuple in self.activationButtons{
            if sender == tuple.human{
                tuple.human.backgroundColor = disabledColor
                tuple.computer.backgroundColor = disabledColor
                
                tuple.human.backgroundColor = enabledColor
                self.currentPlayers[n].isPlayerHuman = true
            }else if sender == tuple.computer{
                tuple.human.backgroundColor = disabledColor
                tuple.computer.backgroundColor = disabledColor
                
                tuple.computer.backgroundColor = enabledColor
                self.currentPlayers[n].isPlayerHuman = false
            }
            self.addAdditionalHumanLandShips()
            n += 1
        }
    }
}
