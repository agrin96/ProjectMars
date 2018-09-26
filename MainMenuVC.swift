//
//  GameViewController.swift
//  project-mars
//
//  Created by Aleksandr Grin on 12/4/16.
//  Copyright © 2016 AleksandrGrin. All rights reserved.
//

import UIKit
import SpriteKit


class MainMenuVC: UIViewController {

    @IBOutlet weak var SecondaryBackGround: UIView!
    @IBOutlet weak var GameTitle: UILabel!
    @IBOutlet weak var ContinueButton: UIButton!
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var OptionsButton: UIButton!
    @IBOutlet weak var StatisticsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setMainBackgroundwithFit(backgroundName: "Main_BG_final")
        SecondaryBackGround.setSecondaryBackground(named: "Secondary_BG_final")

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait {
            (self.view.subviews[0] as! UIImageView).frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }else if UIDevice.current.orientation.isLandscape {
            (self.view.subviews[0] as! UIImageView).frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "continueGame" {
            do {
                if try gameState.sharedInstance().isGameInProgress == true {
                    return true
                }else{
                    return false
                }
            } catch { print("Error in shouldPreformSegue MainMenuVC") }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGameSegue" {
            do{ try gameState.sharedInstance().isGameInProgress = false } catch { print("Error in MainMenuVC prepare") }
        }
    }
    
    
    //Action for unwinding from the settingsVC 
    @IBAction func returnFromSettings(segue: UIStoryboardSegue){    }
    
}
