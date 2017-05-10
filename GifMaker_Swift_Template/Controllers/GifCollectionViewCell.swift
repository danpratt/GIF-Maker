//
//  GifCollectionViewCell.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/10/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureFor(gif: Gif) {
        gifImageView.image = gif.gifImage
    }
    
}
