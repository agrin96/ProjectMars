//
//  settingsDetailViews.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/18/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import Foundation
import UIKit

fileprivate let enabledColor:UIColor = UIColor.init(red: 0.7, green: 0.1, blue: 0.1, alpha: 0.6)
fileprivate let disabledColor:UIColor = UIColor.clear

/// Controls the selection inside player count subview of settingsView
class playerSelectView: UIView {
    struct playerCount{
        var twoP:Bool
        var threeP:Bool
        var fourP:Bool
        var fiveP:Bool
        var sixP:Bool
        
        init(){
            twoP = false
            threeP = false
            fourP = false
            fiveP = false
            sixP = false
        }
    }
    @IBOutlet weak var twoButton:UIButton!
    @IBOutlet weak var threeButton:UIButton!
    @IBOutlet weak var fourButton:UIButton!
    @IBOutlet weak var fiveButton:UIButton!
    @IBOutlet weak var sixButton:UIButton!

    private var selected:playerCount!
    private var count:Int = 2
    
    @IBAction private func two(_ sender: UIButton){
        self.selected = playerCount()
        self.selected.twoP = true
        self.resetButtonBG()
        self.twoButton.backgroundColor = enabledColor
        self.count = 2
    }
    @IBAction private func three(_ sender: UIButton){
        self.selected = playerCount()
        self.selected.threeP = true
        self.resetButtonBG()
        self.threeButton.backgroundColor = enabledColor
        self.count = 3
    }
    @IBAction private func four(_ sender: UIButton){
        self.selected = playerCount()
        self.selected.fourP = true
        self.resetButtonBG()
        self.fourButton.backgroundColor = enabledColor
        self.count = 4
    }
    @IBAction private func five(_ sender: UIButton){
        self.selected = playerCount()
        self.selected.fiveP = true
        self.resetButtonBG()
        self.fiveButton.backgroundColor = enabledColor
        self.count = 5
    }
    @IBAction private func six(_ sender: UIButton){
        self.selected = playerCount()
        self.selected.sixP = true
        self.resetButtonBG()
        self.sixButton.backgroundColor = enabledColor
        self.count = 6
    }
    
    /// Update the settings value displayed, from user settings
    private func updateSettingsValues(){
        if self.count == 2{
            self.resetButtonBG()
            self.twoButton.backgroundColor = enabledColor
        }else if self.count == 3{
            self.resetButtonBG()
            self.threeButton.backgroundColor = enabledColor
        }else if self.count == 4{
            self.resetButtonBG()
            self.fourButton.backgroundColor = enabledColor
        }else if self.count == 5{
            self.resetButtonBG()
            self.fiveButton.backgroundColor = enabledColor
        }else if self.count == 6{
            self.resetButtonBG()
            self.sixButton.backgroundColor = enabledColor
        }
    }
    
    private func resetButtonBG(){
        self.twoButton.backgroundColor = disabledColor
        self.threeButton.backgroundColor = disabledColor
        self.fourButton.backgroundColor = disabledColor
        self.fiveButton.backgroundColor = disabledColor
        self.sixButton.backgroundColor = disabledColor
    }
    public func defaultPlayerCount(){
        self.resetButtonBG()
        self.fourButton.backgroundColor = enabledColor
    }
    
    //Getter and Setter methods for the data this class is responsible for
    public func getPlayerCount() -> Int { return self.count }
    public func setPlayerCount(data: Int) { self.count = data; self.updateSettingsValues() }
}




/// Controls the difficulty selection inside subview of settingsView
class difficultySelectView: UIView {
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var medButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    struct difficulty{
        var easy:Bool
        var medium:Bool
        var hard:Bool
        
        init(){
            easy = false
            medium = false
            hard = false
        }
    }
    private var selected:difficulty!
    private var mode:String = "easy"
    
    @IBAction private func easy(_ sender: UIButton){
        self.selected = difficulty()
        self.selected.easy = true
        self.resetButtonBG()
        self.easyButton.backgroundColor = enabledColor
        self.mode = "easy"
    }
    @IBAction private func medium(_ sender: UIButton){
        self.selected = difficulty()
        self.selected.medium = true
        self.resetButtonBG()
        self.medButton.backgroundColor = enabledColor
        self.mode = "medium"
    }
    @IBAction private func hard(_ sender: UIButton){
        self.selected = difficulty()
        self.selected.hard = true
        self.resetButtonBG()
        self.hardButton.backgroundColor = enabledColor
        self.mode = "hard"
    }
    
    /// Update the settings value displayed, from user settings
    private func updateSettingsValues(){
        if self.mode == "easy" {
            self.resetButtonBG()
            self.easyButton.backgroundColor = enabledColor
        }else if self.mode == "medium" {
            self.resetButtonBG()
            self.medButton.backgroundColor = enabledColor
        }else if self.mode == "hard" {
            self.resetButtonBG()
            self.hardButton.backgroundColor = enabledColor
        }
    }
    
    private func resetButtonBG(){
        self.easyButton.backgroundColor = disabledColor
        self.medButton.backgroundColor = disabledColor
        self.hardButton.backgroundColor = disabledColor
    }
    public func defaultDifficulty(){
        self.resetButtonBG()
        self.easyButton.backgroundColor = enabledColor
    }
    //Getter and Setter methods for the data this class is responsible for
    public func getDifficulty() -> String { return mode }
    public func setDifficulty(data: String) { self.mode = data; self.updateSettingsValues() }
}




/// Handles the Dice options subview of settingsView
class diceDetailView: UIView {
    @IBOutlet weak var tenSided: UIButton!
    @IBOutlet weak var sixSided: UIButton!
    @IBOutlet weak var sixteenSided: UIButton!
    
    @IBOutlet weak var attackerAdv: UIButton!
    @IBOutlet weak var defenderAdv: UIButton!
    @IBOutlet weak var equalLoss: UIButton!
    
    struct diceSelect{
        var sixSided:Bool
        var tenSided:Bool
        var sixteenSided:Bool
        init(){
            self.sixSided = false
            self.tenSided = false
            self.sixteenSided = false
        }
    }
    struct advantageSelect{
        var attacker:Bool
        var defender:Bool
        var equal:Bool
        init(){
            self.attacker = false
            self.defender = false
            self.equal = false
        }
    }
    
    private var diceType:diceSelect!
    private var diceMode:Int = 6
    
    @IBAction private func chooseSixSided(_ sender: UIButton){
        self.diceType = diceSelect()
        self.diceType.sixSided = true
        self.resetDiceButtonBG()
        self.sixSided.backgroundColor = enabledColor
        self.diceMode = 6
    }
    @IBAction private func chooseTenSided(_ sender: UIButton){
        self.diceType = diceSelect()
        self.diceType.tenSided = true
        self.resetDiceButtonBG()
        self.tenSided.backgroundColor = enabledColor
        self.diceMode = 10
    }
    @IBAction private func chooseSixteenSided(_ sender: UIButton){
        self.diceType = diceSelect()
        self.diceType.sixteenSided = true
        self.resetDiceButtonBG()
        self.sixteenSided.backgroundColor = enabledColor
        self.diceMode = 16
    }
    
    private var advantageType:advantageSelect!
    private var advantageMode:String = "equal"
    
    @IBAction private func chooseAttackerAdv(_ sender: UIButton){
        self.advantageType = advantageSelect()
        self.advantageType.attacker = true
        self.resetAdvButtonBG()
        self.attackerAdv.backgroundColor = enabledColor
        self.advantageMode = "attacker"
    }
    @IBAction private func chooseDefenderAdv(_ sender: UIButton){
        self.advantageType = advantageSelect()
        self.advantageType.defender = true
        self.resetAdvButtonBG()
        self.defenderAdv.backgroundColor = enabledColor
        self.advantageMode = "defender"
    }
    @IBAction private func chooseEqualLosses(_ sender: UIButton){
        self.advantageType = advantageSelect()
        self.advantageType.equal = true
        self.resetAdvButtonBG()
        self.equalLoss.backgroundColor = enabledColor
        self.advantageMode = "equal"
    }
    
    private func resetDiceButtonBG(){
        self.sixSided.backgroundColor = disabledColor
        self.tenSided.backgroundColor = disabledColor
        self.sixteenSided.backgroundColor = disabledColor
    }
    private func resetAdvButtonBG(){
        self.attackerAdv.backgroundColor = disabledColor
        self.defenderAdv.backgroundColor = disabledColor
        self.equalLoss.backgroundColor = disabledColor
    }
    
    /// Update the settings value displayed, from user settings
    private func updateSettingsValues(){
        if self.diceMode == 6 {
            self.resetDiceButtonBG()
            self.sixSided.backgroundColor = enabledColor
        }else if self.diceMode == 10 {
            self.resetDiceButtonBG()
            self.tenSided.backgroundColor = enabledColor
        }else if self.diceMode == 16 {
            self.resetDiceButtonBG()
            self.sixteenSided.backgroundColor = enabledColor
        }
        
        if self.advantageMode == "attacker" {
            self.resetAdvButtonBG()
            self.attackerAdv.backgroundColor = enabledColor
        }else if self.advantageMode == "defender" {
            self.resetAdvButtonBG()
            self.defenderAdv.backgroundColor = enabledColor
        }else if self.advantageMode == "equal" {
            self.resetAdvButtonBG()
            self.equalLoss.backgroundColor = enabledColor
        }
    }
    //These are the defualt selections that should be set
    public func defaultDiceSettings(){
        self.resetDiceButtonBG()
        self.sixSided.backgroundColor = enabledColor
        self.resetAdvButtonBG()
        self.attackerAdv.backgroundColor = enabledColor
    }
    
    
    //Getter and Setter methods for the data this class is responsible for
    public func getDiceSides() -> Int { return self.diceMode }
    public func getDiceAdv() -> String { return self.advantageMode }
    public func setDiceSidesAndAdv(sides: Int, adv: String) {
        self.diceMode = sides
        self.advantageMode = adv
        updateSettingsValues() }
}


/// Controls the card settings view of the SettingsView
class cardDetailView:UIView{
    @IBOutlet weak var bonusIncreases:UIButton!
    @IBOutlet weak var bonusConstant:UIButton!
    @IBOutlet weak var bonusIncreasesCap:UIButton!
    @IBOutlet weak var disableAsteroid:UIButton!
    
    struct bonusSelect{
        var increases:Bool
        var constant:Bool
        var increasesCap:Bool
        init(){
            self.increases = false
            self.constant = false
            self.increasesCap = false
        }
    }
    
    private var bonusType:bonusSelect!
    private var bonusMode:String = "constant"
    private var asteroidCardDisable:Bool = false
    
    @IBAction private func chooseBonusIncreases(_ sender: UIButton){
        self.bonusType = bonusSelect()
        self.bonusType.increases = true
        self.resetBonusButtonBG()
        self.bonusIncreases.backgroundColor = enabledColor
        self.bonusMode = "increases"
    }
    @IBAction private func chooseBonusConstant(_ sender: UIButton){
        self.bonusType = bonusSelect()
        self.bonusType.constant = true
        self.resetBonusButtonBG()
        self.bonusConstant.backgroundColor = enabledColor
        self.bonusMode = "constant"
    }
    @IBAction private func chooseIncreaseCap(_ sender: UIButton){
        self.bonusType = bonusSelect()
        self.bonusType.increasesCap = true
        self.resetBonusButtonBG()
        self.bonusIncreasesCap.backgroundColor = enabledColor
        self.bonusMode = "capped"
    }
    
    @IBAction private func chooseDisableAsteroid(_ sender: UIButton){
        if self.disableAsteroid.backgroundColor == disabledColor{
            self.disableAsteroid.backgroundColor = enabledColor
            self.asteroidCardDisable = true
        }else {
            self.resetAsteroidButtonBG()
            self.asteroidCardDisable = false
        }
    }
    
    /// After user saves their settings data we need a way to display their choices
    /// on return to the settngsVC.
    private func updateSettingsValues(){
        if self.bonusMode == "increases" {
            self.resetBonusButtonBG()
            self.bonusIncreases.backgroundColor = enabledColor
        }else if self.bonusMode == "constant" {
            self.resetBonusButtonBG()
            self.bonusConstant.backgroundColor = enabledColor
        }else if self.bonusMode == "capped" {
            self.resetBonusButtonBG()
            self.bonusIncreasesCap.backgroundColor = enabledColor
        }
        
        if self.asteroidCardDisable == true {
           self.disableAsteroid.backgroundColor = enabledColor
        }else{
            self.resetAsteroidButtonBG()
        }
    }
    
    private func resetBonusButtonBG(){
        self.bonusIncreases.backgroundColor = disabledColor
        self.bonusConstant.backgroundColor = disabledColor
        self.bonusIncreasesCap.backgroundColor = disabledColor
    }
    private func resetAsteroidButtonBG(){
        self.disableAsteroid.backgroundColor = disabledColor
    }
    
    public func defaultCardSettings(){
        self.resetBonusButtonBG()
        self.resetAsteroidButtonBG()
        self.bonusConstant.backgroundColor = enabledColor
        //self.disableAsteroid.backgroundColor = disabledColor
    }
    
    //Getter and Setter methods for the data this class is responsible for
    public func getCardBonus() -> String { return self.bonusMode }
    public func getAsteroidCardMode() -> Bool { return self.asteroidCardDisable }
    public func setCardBonusAndAsteroid(bonus: String, asteroid: Bool) {
        self.bonusMode = bonus
        self.asteroidCardDisable = asteroid
        self.updateSettingsValues() }
}



/// Controls the combat settings view of settingsView
class combatDetailView:UIView{
    @IBOutlet weak var combatEqual:UIButton!
    @IBOutlet weak var combatAttackerAdv:UIButton!
    @IBOutlet weak var combatDefenderAdv:UIButton!
    @IBOutlet weak var combatTotalAnnihilation:UIButton!
    
    struct combatSelect{
        var equal:Bool
        var attacker:Bool
        var defender:Bool
        init(){
            self.equal = false
            self.attacker = false
            self.defender = false
        }
    }
    private var combatType:combatSelect!
    private var combatMode:String = "equal"
    private var totalAnnihilationEnable:Bool = false
    
    @IBAction private func chooseCombatEqual(_ sender: UIButton){
        self.combatType = combatSelect()
        self.combatType.equal = true
        self.resetCombatButtonBG()
        self.combatEqual.backgroundColor = enabledColor
        self.combatMode = "equal"
    }
    @IBAction private func chooseAttackerAdv(_ sender: UIButton){
        self.combatType = combatSelect()
        self.combatType.attacker = true
        self.resetCombatButtonBG()
        self.combatAttackerAdv.backgroundColor = enabledColor
        self.combatMode = "attacker"
    }
    @IBAction private func chooseDefenderAdv(_ sender: UIButton){
        self.combatType = combatSelect()
        self.combatType.defender = true
        self.resetCombatButtonBG()
        self.combatDefenderAdv.backgroundColor = enabledColor
        self.combatMode = "defender"
    }
    
    @IBAction private func totalAnnihilation(_ sender: UIButton){
        if self.combatTotalAnnihilation.backgroundColor == disabledColor {
            self.combatTotalAnnihilation.backgroundColor = enabledColor
            self.totalAnnihilationEnable = true
        }else{
            self.resetAnnihilationBG()
            self.totalAnnihilationEnable = false
        }
    }
    
    /// Update the settings value displayed, from user settings
    private func updateSettingsValues(){
        if self.combatMode == "equal" {
            self.resetCombatButtonBG()
            self.combatEqual.backgroundColor = enabledColor
        }else if self.combatMode == "attacker" {
            self.resetCombatButtonBG()
            self.combatAttackerAdv.backgroundColor = enabledColor
        }else if self.combatMode == "defender" {
            self.resetCombatButtonBG()
            self.combatDefenderAdv.backgroundColor = enabledColor
        }
        
        if self.totalAnnihilationEnable == true {
            self.combatTotalAnnihilation.backgroundColor = enabledColor
        }else{
            self.resetAnnihilationBG()
        }
    }
    
    private func resetCombatButtonBG(){
        self.combatEqual.backgroundColor = disabledColor
        self.combatAttackerAdv.backgroundColor = disabledColor
        self.combatDefenderAdv.backgroundColor = disabledColor
    }
    private func resetAnnihilationBG(){
        self.combatTotalAnnihilation.backgroundColor = disabledColor
    }
    
    public func defaultCombatSettings(){
        self.resetCombatButtonBG()
        self.resetAnnihilationBG()
        self.combatEqual.backgroundColor = enabledColor
    }
    
    //Getters for the settings of this view
    public func getCombatAdv() ->String {return self.combatMode }
    public func getAnnihilationMode() ->Bool { return self.totalAnnihilationEnable }
    public func setCombatAdvAndAnnih(adv: String, annihilation: Bool){
        self.combatMode = adv
        self.totalAnnihilationEnable = annihilation
        self.updateSettingsValues() }
}



/// Controls the start options view of SettingsView
class startDetailView:UIView{
    @IBOutlet weak var startRandom:UIButton!
    @IBOutlet weak var startFurthest:UIButton!
    @IBOutlet weak var startClose:UIButton!
    @IBOutlet weak var startCustom:UIButton!
    
    struct startSelect{
        var random:Bool
        var furthest:Bool
        var close:Bool
        var custom:Bool
        init(){
            self.random = false
            self.furthest = false
            self.close = false
            self.custom = false
        }
    }
    private var startType:startSelect!
    private var startMode:String = "custom"
    
    @IBAction private func chooseRandom(_ sender: UIButton){
        self.startType = startSelect()
        self.startType.random = true
        self.resetStartButtonBG()
        self.startRandom.backgroundColor = enabledColor
        self.startMode = "random"
    }
    @IBAction private func chooseFurthest(_ sender: UIButton){
        self.startType = startSelect()
        self.startType.furthest = true
        self.resetStartButtonBG()
        self.startFurthest.backgroundColor = enabledColor
        self.startMode = "furthest"
    }
    @IBAction private func chooseClose(_ sender: UIButton){
        self.startType = startSelect()
        self.startType.close = true
        self.resetStartButtonBG()
        self.startClose.backgroundColor = enabledColor
        self.startMode = "close"
    }
    @IBAction private func chooseCustom(_ sender: UIButton){
        self.startType = startSelect()
        self.startType.custom = true
        self.resetStartButtonBG()
        self.startCustom.backgroundColor = enabledColor
        self.startMode = "custom"
    }
    
    /// Update the settings value displayed, from user settings
    private func updateSettingsValues(){
        if self.startMode == "random" {
            self.resetStartButtonBG()
            self.startRandom.backgroundColor = enabledColor
        }else if self.startMode == "furthest" {
            self.resetStartButtonBG()
            self.startFurthest.backgroundColor = enabledColor
        }else if self.startMode == "close" {
            self.resetStartButtonBG()
            self.startClose.backgroundColor = enabledColor
        }else if self.startMode == "custom" {
            self.resetStartButtonBG()
            self.startCustom.backgroundColor = enabledColor
        }
    }
    
    private func resetStartButtonBG(){
        self.startRandom.backgroundColor = disabledColor
        self.startFurthest.backgroundColor = disabledColor
        self.startClose.backgroundColor = disabledColor
        self.startCustom.backgroundColor = disabledColor
    }
    
    public func defaultStartSettings(){
        self.resetStartButtonBG()
        self.startCustom.backgroundColor = enabledColor
    }
    
    ///Getter for the settings in this view
    public func getStartPositionMode()->String { return self.startMode }
    public func setStartPositionMode(start: String) {
        self.startMode = start
        self.updateSettingsValues() }
}











