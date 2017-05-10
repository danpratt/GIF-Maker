//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/4/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !(navigationController?.navigationBar.isHidden)! {
            applyTheme(.Light)
        }
        
        let tinaFeyGif = UIImage.gif(name: "tinaFeyHiFive")
        gifImageView.image = tinaFeyGif
        
        // We have seen the welcome screen, so set the UserDefaults for it
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
    }
    
    
}
