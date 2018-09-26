//
//  StatisticsViews.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/13/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import Foundation
import UIKit


/// Responsible for displaying, reseting and updating the statistics labels
class StatisticsView: UIScrollView {
    
    @IBOutlet weak var ResetPopupView: UIView!
    @IBOutlet weak var mainBackgroundView: UIView!
    var retainedStatistics:gameStatistics!
    
    @IBOutlet weak var GamesPlayed: UILabel!
    @IBOutlet weak var GamesWonNum: UILabel!
    @IBOutlet weak var GamesWonPercent: UILabel!
    
    @IBOutlet weak var GamesLostNum: UILabel!
    @IBOutlet weak var GamesLostPercent: UILabel!
    
    @IBOutlet weak var AssassinationsNum: UILabel!
    @IBOutlet weak var AssassinationsPercent: UILabel!
    
    @IBOutlet weak var ElevatorsNum: UILabel!
    @IBOutlet weak var ElevatorsPercent: UILabel!
    
    @IBOutlet weak var CratersControlled: UILabel!
    
    @IBOutlet weak var landShips: UILabel!
    @IBOutlet weak var extractors: UILabel!
    @IBOutlet weak var crawlers: UILabel!
    
    @IBOutlet weak var ProvincesCaptured: UILabel!
    @IBOutlet weak var ProvincesLost: UILabel!

    @IBOutlet weak var GamesHeader:UILabel!
    @IBOutlet weak var UnitsHeader:UILabel!
    @IBOutlet weak var ProvinceHeader:UILabel!
    @IBOutlet weak var confirmationText: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func encode(with aCoder: NSCoder) {
        //Hello
    }
    
    
    /// Resets all the statistics in case the user wants a fresh experience
    ///
    /// - Parameter sender: ResetButton in StatsView
   private func resetStatistics(){
        if retainedStatistics != nil {
            self.GamesPlayed.text = "0"
            self.GamesWonNum.text = "0"
            self.retainedStatistics.gamesWon = 0
            self.retainedStatistics.gamesWonPercent = NSDecimalNumber.init(value: 0)
            self.GamesWonPercent.text = "0 %"
            
            self.GamesLostNum.text = "0"
            self.retainedStatistics.gamesLost = 0
            self.retainedStatistics.gamesLostPercent = NSDecimalNumber.init(value: 0)
            self.GamesLostPercent.text = "0 %"
            
            self.AssassinationsNum.text = "0"
            self.retainedStatistics.assassinations = 0
            self.retainedStatistics.assassinationsPercent = NSDecimalNumber.init(value: 0)
            self.AssassinationsPercent.text = "0 %"
            
            self.ElevatorsNum.text = "0"
            self.retainedStatistics.elevators = 0
            self.retainedStatistics.elevatorsPercent = NSDecimalNumber.init(value: 0)
            self.ElevatorsPercent.text = "0 %"
            
            self.CratersControlled.text = "0"
            self.retainedStatistics.cratersControlled = 0
            
            self.landShips.text = "0"
            self.retainedStatistics.landShips = 0
            self.extractors.text = "0"
            self.retainedStatistics.extractors = 0
            self.crawlers.text = "0"
            self.retainedStatistics.crawlers = 0
            
            self.ProvincesCaptured.text = "0"
            self.retainedStatistics.provincesCaptured = 0
            self.ProvincesLost.text = "0"
            self.retainedStatistics.provincesLost = 0
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    /// Sets the statistics values in the labels
    private func setStatistics(){
        self.retainedStatistics.gamesPlayed = retainedStatistics.gamesWon + retainedStatistics.gamesLost
        self.GamesPlayed.text = String(retainedStatistics.gamesPlayed)
        self.GamesWonNum.text = String(retainedStatistics.gamesWon)
        self.retainedStatistics.gamesWonPercent = convertToPercent(num: retainedStatistics.gamesWon,
                                                                    total: retainedStatistics.gamesPlayed)
        self.GamesWonPercent.text = String(describing: retainedStatistics.gamesWonPercent) + "%"
        
        self.GamesLostNum.text = String(retainedStatistics.gamesLost)
        self.retainedStatistics.gamesLostPercent = convertToPercent(num: retainedStatistics.gamesLost,
                                                               total: retainedStatistics.gamesPlayed)
        self.GamesLostPercent.text = String(describing: retainedStatistics.gamesLostPercent) + "%"
        
        self.retainedStatistics.assassinationsPercent = convertToPercent(num: retainedStatistics.assassinations,
                                                                    total: retainedStatistics.gamesPlayed)
        self.AssassinationsNum.text = String(retainedStatistics.assassinations)
        self.AssassinationsPercent.text = String(describing: retainedStatistics.assassinationsPercent) + "%"
        
        self.ElevatorsNum.text = String(retainedStatistics.elevators)
        self.retainedStatistics.elevatorsPercent = convertToPercent(num: retainedStatistics.elevators,
                                                               total: retainedStatistics.gamesPlayed)
        self.ElevatorsPercent.text = String(describing: retainedStatistics.elevatorsPercent) + "%"
        
        self.CratersControlled.text = String(retainedStatistics.cratersControlled)
        
        self.landShips.text = String(retainedStatistics.landShips)
        self.extractors.text = String(retainedStatistics.extractors)
        self.crawlers.text = String(retainedStatistics.crawlers)
        
        self.ProvincesCaptured.text = String(retainedStatistics.provincesCaptured)
        self.ProvincesLost.text = String(retainedStatistics.provincesLost)
    }
    
    @IBAction private func MainReset(_ sender: UIButton) {
        self.isUserInteractionEnabled = false
        self.ResetPopupView.isUserInteractionEnabled = true
        self.ResetPopupView.isHidden = false
    }
    @IBAction private func confirmResetStats(_ sender: UIButton) {
        self.resetStatistics()
        self.ResetPopupView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
        self.ResetPopupView.isHidden = true
        
        ///Store the reset statistics into the gameState
        do { try gameState.sharedInstance().PlayerStats = self.retainedStatistics } catch { print("Error in confirmResetStats") }
    }
    @IBAction private func CancelResetStats(_ sender: UIButton) {
        self.ResetPopupView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
        self.ResetPopupView.isHidden = true
    }
    
    
    //Converts number out of total into a percent value with 2 decimal rounding
    private func convertToPercent(num: Int,total: Int) -> NSDecimalNumber {
        let behavior = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.up, scale: 4, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let x = NSDecimalNumber.init(value: num)
        let y = NSDecimalNumber.init(value: total)
        
        return ((x.dividing(by: y, withBehavior: behavior)).multiplying(by: 100, withBehavior: behavior))
    }
    
    public func setStatisticsStyle(style: String){
        GamesHeader.setLabelBackground(backgroundName: style)
        UnitsHeader.setLabelBackground(backgroundName: style)
        ProvinceHeader.setLabelBackground(backgroundName: style)
        confirmationText.setLabelBackground(backgroundName: style)
        mainBackgroundView.setSecondaryBackground(named: "Secondary_BG_final.png")
        ResetPopupView.setSecondaryBackground(named: "Secondary_BG_final.png")
    }
}











