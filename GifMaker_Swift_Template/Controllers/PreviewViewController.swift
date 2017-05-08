//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/4/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var gif: Gif?
    @IBOutlet weak var gifImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gif != nil {
            gifImageView.image = gif?.gifImage
        }
    }

    // MARK: - Sharing GIF
    
    @IBAction func shareGif(_ sender: Any) {
        if let animatedGif = try? Data(contentsOf: (gif?.url)!) {
             let itemsToShare: [Data] = [animatedGif]
            
            let shareController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            shareController.completionWithItemsHandler? = { (activityType, completed, returnedItems, activityError) in
                if completed {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            navigationController?.present(shareController, animated: true, completion: nil)
        }
    }
}
