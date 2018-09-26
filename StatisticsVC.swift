//
//  StatisticsVC.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/9/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import UIKit
import SpriteKit

class StatisticsVC: UIViewController {
   
    @IBOutlet weak var StatsScrollView: StatisticsView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setMainBackgroundwithFit(backgroundName: "Main_BG_final.png")
        //Load player stats from the game state
        do { StatsScrollView.retainedStatistics = try gameState.sharedInstance().PlayerStats }catch{ print("Error in StatsVC viewWillAppear") }
        
        StatsScrollView.setStatisticsStyle(style: "Label_BG_final2.png")
        StatsScrollView.ResetPopupView.isUserInteractionEnabled = false
        StatsScrollView.ResetPopupView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.height < 600 {
            StatsScrollView.contentSize.height = 700
        }else{
            StatsScrollView.contentSize.height = UIScreen.main.bounds.height
        }
        StatsScrollView.contentSize.width = UIScreen.main.bounds.width
        StatsScrollView.isUserInteractionEnabled = true
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnToMenu" {
            do{ try gameState.sharedInstance().PlayerStats = self.StatsScrollView.retainedStatistics! } catch { print("Error in StatsVC prepare") }
        }
    }
}
