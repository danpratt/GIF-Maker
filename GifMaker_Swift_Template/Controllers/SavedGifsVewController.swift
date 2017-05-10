//
//  SavedGifsVewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/9/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsVewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, PreviewViewControllerDelegate {
    
    // Mark: - Properties
    
    // Holds saved gifs
    var gifs: [Gif]?
    
    // Constants
    let cellMargin: CGFloat = 12.0
    let reuseId = "GifCell"
    
    // Outlets
    @IBOutlet weak var emptyViewImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyViewImage.isHidden = (gifs?.count != 0 )
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs?.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! GifCollectionViewCell
        if let gif = gifs?[indexPath.item] {
            cell.configureFor(gif: gif)
        } else {
            cell.backgroundColor = UIColor.blue
        }
        
        
        return cell
    }
    
    // MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin * 2)) / 2.0
        return CGSize(width: width, height: width)
    }
    
    // MARK: - PreviewVC Delegate
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        gif.gifData = NSData(contentsOf: gif.url)
        print("set")
    }

}
