//
//  startGameVC.swift
//  project-mars
//
//  Created by Aleksandr Grin on 1/17/17.
//  Copyright © 2017 AleksandrGrin. All rights reserved.
//

import Foundation
import SpriteKit

class startGameVC:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var SecondaryBackGround: UIView!
    @IBOutlet weak var VehicleView: SKView!
    
    @IBOutlet weak var BeginGameButton: UIButton!
    @IBOutlet weak var MainScrollView: playerSelectionOptions!
    
    var vehicleScroll:vehicleSelect!
    var sessionSettings:gameSettings!           ///Where you pull options from
    var colors:Array<SKColor> = [SKColor.red,
                                 SKColor.blue,
                                 SKColor.cyan,
                                 SKColor.purple,
                                 SKColor.yellow,
                                 SKColor.green]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setMainBackgroundwithFit(backgroundName: "Main_BG_final")
        SecondaryBackGround.setSecondaryBackground(named: "Secondary_BG_final")
        
        BeginGameButton.isUserInteractionEnabled = false
        BeginGameButton.alpha = 0.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameBegin" {
            //Saves the settings that the user chose inside this VC
            self.MainScrollView.finalizeGameSettings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{ self.sessionSettings = try gameState.sharedInstance().GameSettings } catch { print("Error in startGameVC viewDidLoad") }
        
        MainScrollView.importSettings(settings: self.sessionSettings)
        
        vehicleScroll = vehicleSelect(size: VehicleView.bounds.size)
        
        vehicleScroll.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(shiftView(recognizer:)))
        VehicleView.addGestureRecognizer(vehicleScroll.panRecognizer)
        vehicleScroll.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
        VehicleView.addGestureRecognizer(vehicleScroll.tapRecognizer)
        
        VehicleView.presentScene(vehicleScroll)
        
        for field in MainScrollView.activationTextfields {
            field.delegate = self
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    /// Gets rid of text entry after return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for field in MainScrollView.activationTextfields {
            if field == textField{
                field.resignFirstResponder()
                return true
            }
        }
        return true
    }
    
    func shiftView(recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began:
            break
        case .changed:
            let toMove = recognizer.translation(in: self.view)
            var newPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
            
            newPosition.x = (vehicleScroll.camera?.position.x)! - toMove.x
            newPosition.y = (vehicleScroll.camera?.position.y)! + toMove.y
            
            vehicleScroll.camera?.run(SKAction.move(to: newPosition, duration: 0.0))
            
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            break
        case .ended:
            var toMove = recognizer.translation(in: self.view)
            var newPosition:CGPoint = CGPoint(x: 0.0, y: 0.0)
            
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
            let scale = Double((magnitude / 800) * 0.1)
            toMove.x = velocity.x * CGFloat(scale)
            toMove.y = velocity.y * CGFloat(scale)
            
            newPosition.x = (vehicleScroll.camera?.position.x)! - toMove.x
            newPosition.y = (vehicleScroll.camera?.position.y)! + toMove.y
            
            vehicleScroll.camera?.run(SKAction.move(to: newPosition, duration: scale))
            
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            break
        default:
            break
        }
        
    }
    
    func tapped(recognizer: UITapGestureRecognizer){
        var point = recognizer.location(in: VehicleView)
        point = vehicleScroll.convertPoint(fromView: point)
        
        var n = 0
        for tuple in vehicleScroll.vehicleList{
            if tuple.landShip.contains(point) || tuple.extractor.contains(point){
                if tuple.landShip.isHidden == false && tuple.extractor.isHidden == false{
                    MainScrollView.currentPlayers[(n / 3)].chosenLandShip = nil
                    MainScrollView.currentPlayers[(n / 3)].chosenExtractor = nil
                    resetTappedVehicles(row: (n / 3))
                    MainScrollView.currentPlayers[(n / 3)].chosenLandShip = tuple.landShip
                    MainScrollView.currentPlayers[(n / 3)].chosenExtractor = tuple.extractor
                    setTappedVehicles(tuple: tuple, color: colors[(n / 3)], index: (n % 3))
                }
            }
            n += 1
        }
    }
    
    private func resetTappedVehicles(row: Int){
        var n = 0
        for tuple in vehicleScroll.vehicleList{
            if (n / 3) == row{
                tuple.landShip.modifyColor(color: SKColor.clear, blendfactor: 0.0, blendMode: SKBlendMode.alpha)
                tuple.extractor.modifyColor(color: SKColor.clear, blendfactor: 0.0, blendMode: SKBlendMode.alpha)
                tuple.landShip.landShipSprite.childNode(withName: "selected")?.removeFromParent()
            }
            n += 1
        }
    }
    private func setTappedVehicles(tuple: (landShip: landship,extractor: extractor), color: SKColor, index:Int){
        tuple.landShip.modifyColor(color: color, blendfactor: 0.5, blendMode: SKBlendMode.alpha)
        tuple.extractor.modifyColor(color: color, blendfactor: 0.5, blendMode: SKBlendMode.alpha)
        
        let label = SKLabelNode(text: "Selected")
        label.fontSize = 24
        label.fontColor = SKColor.white
        label.fontName = "System Heavy"
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = 1
        label.name = "selected"
        tuple.landShip.landShipSprite.addChild(label)
        
        BeginGameButton.isUserInteractionEnabled = true
        BeginGameButton.alpha = 1.0
        ///Enable button to begin game
        for player in MainScrollView.currentPlayers{
            if player.isPlayerHuman == true{
                if player.chosenLandShip == nil || player.chosenExtractor == nil {
                    BeginGameButton.isUserInteractionEnabled = false
                    BeginGameButton.alpha = 0.5
                }
            }
        }
        
        ///Focus Camera on Selection
        vehicleScroll.mainCamera.run(SKAction.move(to: tuple.landShip.landShipSprite.position, duration: 0.5))
        MainScrollView.flavorText.text = MainScrollView.flavorTextStorage[index]
        MainScrollView.flavorText.font = UIFont.boldSystemFont(ofSize: 14)
        MainScrollView.flavorText.textAlignment = NSTextAlignment.justified
        MainScrollView.flavorText.numberOfLines = 10
    }
}
