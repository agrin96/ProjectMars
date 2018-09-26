//
//  SettingsView.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/13/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIScrollView{
    
    var tapRecognizer:UITapGestureRecognizer!
    var settingsSelected:gameSettings!
    
    @IBOutlet weak var AdvDiceOptView: diceDetailView!
    @IBOutlet weak var AdvCardOptView: cardDetailView!
    @IBOutlet weak var AdvCombatOptView: combatDetailView!
    @IBOutlet weak var AdvStartOptView: startDetailView!
    
    @IBOutlet weak var numPlayerHeader: UILabel!
    @IBOutlet weak var difficultyHeader: UILabel!
    @IBOutlet weak var advancedHeader: UILabel!
    
    @IBOutlet weak var diceBGview: UIView!
    @IBOutlet weak var cardBGview: UIView!
    @IBOutlet weak var combatBGview: UIView!
    @IBOutlet weak var startBGview: UIView!
    @IBOutlet weak var decorativeBGView: UIView!
    
    @IBOutlet weak var numberPlayerView: playerSelectView!
    @IBOutlet weak var gameMode:difficultySelectView!
    
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    ///Handle opening of the advanced settings menus
    @IBAction func OpenDiceOption(_ sender: UIButton) {
        openDetailView(view: AdvDiceOptView)
    }
    @IBAction func OpenCardOption(_ sender: UIButton) {
        openDetailView(view: AdvCardOptView)
    }
    @IBAction func OpenCombatOption(_ sender: UIButton) {
        openDetailView(view: AdvCombatOptView)
    }
    @IBAction func OpenStartOption(_ sender: UIButton) {
        openDetailView(view: AdvStartOptView)
    }
    ///Set the style with which the advanced settings menus open
    fileprivate func openDetailView(view: UIView){
        view.alpha = 1
        view.isHidden = false
        view.isUserInteractionEnabled = true
        defaultButton.isUserInteractionEnabled = false
        returnButton.isUserInteractionEnabled = false
        self.addGestureRecognizer(tapRecognizer)
    }
    
    ///Initializes the advance settings subviews by hiding them and creates a tap gesture recognizer
    func initSettingsViews(){
        self.AdvDiceOptView.isUserInteractionEnabled = false
        self.AdvDiceOptView.isHidden = true
        self.AdvCardOptView.isUserInteractionEnabled = false
        self.AdvCardOptView.isHidden = true
        self.AdvCombatOptView.isUserInteractionEnabled = false
        self.AdvCombatOptView.isHidden = true
        self.AdvStartOptView.isUserInteractionEnabled = false
        self.AdvStartOptView.isHidden = true
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
    }
    

    ///Controls what happens when the TapGestureRecognizer recieves a tap event. In this case,
    ///we exit the respective advances settings view by tapping outside of its bounds.
    func tapped(recognizer: UITapGestureRecognizer){
        if recognizer.state == UIGestureRecognizerState.ended {
            tappedGenericView(view: self.AdvDiceOptView, recognizer: recognizer)
            tappedGenericView(view: self.AdvCardOptView, recognizer: recognizer)
            tappedGenericView(view: self.AdvCombatOptView, recognizer: recognizer)
            tappedGenericView(view: self.AdvStartOptView, recognizer: recognizer)
        }
    }
    
    ///Check that a tap is outside the bounds of the view and if so hide the view and remove the
    ///gesture recognizer
    func tappedGenericView(view: UIView, recognizer: UITapGestureRecognizer){
        if view.bounds.contains(recognizer.location(in: view)) == false {
            view.isHidden = true
            view.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = true
            defaultButton.isUserInteractionEnabled = true
            returnButton.isUserInteractionEnabled = true
            self.removeGestureRecognizer(tapRecognizer)
        }
    }
    
    
    /// Sets the defualt game settings and stores them in the settingsSelected struct
    /// to be accessed and transmitted from the SettingsViewControllers.
    ///
    /// - Parameter sender: the Defualt Button
    @IBAction private func defaultSettings(_ sender: UIButton){
        self.numberPlayerView.defaultPlayerCount()
        self.gameMode.defaultDifficulty()
        self.AdvDiceOptView.defaultDiceSettings()
        self.AdvCardOptView.defaultCardSettings()
        self.AdvCombatOptView.defaultCombatSettings()
        self.AdvStartOptView.defaultStartSettings()
        self.saveUserSettings()
    }
    
    ///Uses the various settings getter functions to store the settings inside
    ///settingsSelected struct for use in access and transmition from the VC
    func saveUserSettings(){
        self.settingsSelected.totalPlayers = self.numberPlayerView.getPlayerCount()
        self.settingsSelected.gameDifficulty = self.gameMode.getDifficulty()
        
        self.settingsSelected.cardBonusMode = self.AdvCardOptView.getCardBonus()
        self.settingsSelected.disableAsteroidCard = self.AdvCardOptView.getAsteroidCardMode()
        
        self.settingsSelected.combatAdvantageMode = self.AdvCombatOptView.getCombatAdv()
        self.settingsSelected.enableTotalAnnihilation = self.AdvCombatOptView.getAnnihilationMode()
        
        self.settingsSelected.diceAdvantageMode = self.AdvDiceOptView.getDiceAdv()
        self.settingsSelected.sidesPerDice = self.AdvDiceOptView.getDiceSides()
        
        self.settingsSelected.startPositionMode = self.AdvStartOptView.getStartPositionMode()
    }
    
    /// Pushes user settings to the view from the stored settings data
    func pushUserSettings(){
        self.numberPlayerView.setPlayerCount(data: self.settingsSelected.totalPlayers)
        self.gameMode.setDifficulty(data: self.settingsSelected.gameDifficulty)
        
        self.AdvCardOptView.setCardBonusAndAsteroid(bonus: self.settingsSelected.cardBonusMode, asteroid: self.settingsSelected.disableAsteroidCard)
        self.AdvCombatOptView.setCombatAdvAndAnnih(adv: self.settingsSelected.combatAdvantageMode, annihilation: self.settingsSelected.enableTotalAnnihilation)
        self.AdvDiceOptView.setDiceSidesAndAdv(sides: self.settingsSelected.sidesPerDice, adv: self.settingsSelected.diceAdvantageMode)
        self.AdvStartOptView.setStartPositionMode(start: self.settingsSelected.startPositionMode)
    }
    
    public func setSettingsStyle(named: String){
        AdvCardOptView.setSecondaryBackground(named: "Secondary_BG_final.png")
        AdvDiceOptView.setSecondaryBackground(named: "Secondary_BG_final.png")
        AdvStartOptView.setSecondaryBackground(named: "Secondary_BG_final.png")
        AdvCombatOptView.setSecondaryBackground(named: "Secondary_BG_final.png")
        
        numPlayerHeader.setLabelBackground(backgroundName: named)
        difficultyHeader.setLabelBackground(backgroundName: named)
        advancedHeader.setLabelBackground(backgroundName: named)
        
        decorativeBGView.setSecondaryBackground(named: "Secondary_BG_final.png")
        
    }
}

