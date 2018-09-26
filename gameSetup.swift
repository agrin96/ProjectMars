//
//  gameSetup.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/17/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit


/// After the map is ready we do additional setup.
class gameSetup{
    var playersInGame:Array<Player>!
    var startMode:String
    var gameMap:gameBoard!
    
    init(forPlayers: Array<Player>, andStartOption: String){
        self.playersInGame = forPlayers
        self.startMode = andStartOption
        do { self.gameMap = try gameState.sharedInstance().GameBoard } catch { print("Error in gameSetup init") }
        self.setPlayerPieces()
    }
    
    /// Helper function for placing a landShip onto the game board during start position placement.
    ///
    /// - Parameters:
    ///   - ship: The landShip to be placed
    ///   - province: The map province where this landShip will be
    ///   - player: The player that this landShip belongs to
    func modifyMapParameters(for ship: inout landship, in province: Province, and player: Player){
        ship.modifyLandShipSize(newSize: CGSize(width: 80, height: 80))
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
    
    /// Assigns start locations of player landships based on settings condition.
    private func setPlayerPieces(){
        var closePositions:Array<Int> = [27, 28, 29, 31, 32, 33]
        var farthestPositions:Array<Int> = [1, 9, 18, 27, 35, 40]
        var n = 0
        let scene = (self.gameMap.boardMap.scene as? GameScene)
        
        
        for player in self.playersInGame {
            switch self.startMode {
            case "random":
                while player.hasStartAssigned == false {
                    
                    let positionToStart = Int.random(range: 1...gameMap.Provinces.count)
                    
                    for prov in self.gameMap.Provinces {
                        if prov.provinceNumber == positionToStart{
                            if prov.startPositionTaken == false{
                                
                                prov.isCratered = true
                                prov.provinceImage.texture = scene?.craterTextures[prov.provinceNumber - 1]
                                var newLandShip = player.chosenLandShip.getNodeCopy(andNameIt: player.playerName)
                                
                                scene?.animateLandShipRocketLanding(to: prov.landShipPosition, color: player.color, completion: {() in
                                    self.modifyMapParameters(for: &newLandShip, in: prov, and: player)
                                    prov.changeProvinceColor(toColor: player.color, toBlendMode: SKBlendMode.alpha, toFactor: 0.3)
                                    self.gameMap.landShipLayer.addChild(newLandShip)
                                    newLandShip.addParticleEffect()
                                    
                                    var truthTable = true
                                    for player in (scene?.GameLoop.settingsInstance.gamePlayers)!{
                                        truthTable = truthTable && player.hasStartAssigned
                                    }
                                    if truthTable == true{
                                        scene?.tempGameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                                    }
                                })
                                player.isAlive = true
                                player.hasStartAssigned = true
                            }
                        }
                    }
                }
                break
            case "close":
                while player.hasStartAssigned == false {
                    for prov in self.gameMap.Provinces {
                        if prov.provinceNumber == closePositions[n] {
                            
                            prov.isCratered = true
                            prov.provinceImage.texture = scene?.craterTextures[prov.provinceNumber - 1]
                            var newLandShip = player.chosenLandShip.getNodeCopy(andNameIt: player.playerName)
                            
                            scene?.animateLandShipRocketLanding(to: prov.landShipPosition, color: player.color, completion: {() in
                                self.modifyMapParameters(for: &newLandShip, in: prov, and: player)
                                prov.changeProvinceColor(toColor: player.color, toBlendMode: SKBlendMode.alpha, toFactor: 0.3)
                                self.gameMap.landShipLayer.addChild(newLandShip)
                                newLandShip.addParticleEffect()
                                
                                var truthTable = true
                                for player in (scene?.GameLoop.settingsInstance.gamePlayers)!{
                                    truthTable = truthTable && player.hasStartAssigned
                                }
                                if truthTable == true{
                                    scene?.tempGameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                                }
                            })
                            player.isAlive = true
                            player.hasStartAssigned = true
                            n += 1
                            break
                        }
                    }
                }
                break
            case "furthest":
                while player.hasStartAssigned == false {
                    for prov in self.gameMap.Provinces {
                        if prov.provinceNumber == farthestPositions[n] {
                            
                            prov.isCratered = true
                            prov.provinceImage.texture = scene?.craterTextures[prov.provinceNumber - 1]
                            var newLandShip = player.chosenLandShip.getNodeCopy(andNameIt: player.playerName)
                            
                            scene?.animateLandShipRocketLanding(to: prov.landShipPosition, color: player.color, completion: {() in
                                self.modifyMapParameters(for: &newLandShip, in: prov, and: player)
                                prov.changeProvinceColor(toColor: player.color, toBlendMode: SKBlendMode.alpha, toFactor: 0.3)
                                self.gameMap.landShipLayer.addChild(newLandShip)
                                newLandShip.addParticleEffect()
                                
                                var truthTable = true
                                for player in (scene?.GameLoop.settingsInstance.gamePlayers)!{
                                    truthTable = truthTable && player.hasStartAssigned
                                }
                                if truthTable == true{
                                    scene?.tempGameBoard.boardCamera.overlayHUD.enableNonCombatUI()
                                }
                            })
                            player.isAlive = true
                            player.hasStartAssigned = true
                            n += 1
                            break
                        }
                    }
                }
                break
            default:
                break
            }
        }
        do{ try gameState.sharedInstance().GameBoard = self.gameMap} catch { print("Error in SetPlayerPieces") }  //Update the map by pushing to global settings
    }
    
}
