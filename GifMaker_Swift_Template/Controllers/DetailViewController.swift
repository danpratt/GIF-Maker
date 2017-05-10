//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/10/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    // Holds Gif
    var gif: Gif?
    
    // IBOutlets
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gif = gif {
            gifImageView.image = gif.gifImage
        }
        
        shareButton.layer.cornerRadius = 4
    }
    
    // MARK: - IBActions
    
    // Shares Gif
    @IBAction func shareGif(_ sender: Any) {
        var itemsToShare = [NSData]()
        itemsToShare.append((self.gif?.gifData)!)
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    // Closes the VC when tapped
    @IBAction func closeDetailViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
