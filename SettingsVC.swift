//
//  SettingsVC.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/8/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var ScrollView: SettingsView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setMainBackgroundwithFit(backgroundName: "Main_BG_final.png")
            ScrollView.setSettingsStyle(named: "Label_BG_final2.png")

        if ScrollView.settingsSelected == nil{
            do{ ScrollView.settingsSelected = try gameState.sharedInstance().GameSettings } catch { print("Error in SettingsVC viewwillappear") }
            ScrollView.pushUserSettings()
        }
        ScrollView.initSettingsViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.height < 600 {
            ScrollView.contentSize.height = 700
        }else{
            ScrollView.contentSize.height = UIScreen.main.bounds.height
        }
        ScrollView.contentSize.width = UIScreen.main.bounds.width
        ScrollView.isUserInteractionEnabled = true

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
            ScrollView.saveUserSettings()
            do { try gameState.sharedInstance().GameSettings = ScrollView.settingsSelected } catch { print("Error in settingsVC prepare") }
        }
    }
}
