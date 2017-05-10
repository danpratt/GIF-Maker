//
//  UIViewController+Theme.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/10/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum Theme {
        case Light, Dark, DarkTranslucent
    }
    
    func applyTheme(_ theme: Theme) {
        
        switch theme {
        case .Light:
            
            navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            
            navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.tintColor = UIColor(red: 1.0, green: 51.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)]
            
            view.backgroundColor = UIColor.white
            
        case .Dark:
            
            view.backgroundColor = UIColor(red: 46.0/255, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.view.backgroundColor = UIColor(red: 46.0/255, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            navigationController?.navigationBar.backgroundColor = UIColor(red: 46.0/255, green: 61.0/255.0, blue: 73.0/255.0, alpha: 1.0)
            edgesForExtendedLayout = UIRectEdge.all
            
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            
        case .DarkTranslucent:
            
            view.backgroundColor = UIColor(red: 46.0/255.0, green: 61.0/255.0, blue: 73.0/255.0, alpha: 0.9)
            
        }
    }
    
}
