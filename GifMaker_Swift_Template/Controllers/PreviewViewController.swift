//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/4/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

// Mark: - Protocol Declaration
protocol PreviewViewControllerDelegate {
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    // Gif For Preview
    var gif: Gif?
    var delegate: PreviewViewControllerDelegate?
    
    // IBOutlets
    @IBOutlet weak var gifImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if gif != nil {
            gifImageView.image = gif?.gifImage
        }
    }

    // MARK: - Sharing & Saving GIF
    
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
    
    
    @IBAction func createAndSave(_ sender: Any) {
        self.delegate?.previewVC(preview: self, didSaveGif: gif!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
