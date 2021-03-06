//
//  SavedGifsVewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/9/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import QuartzCore

class SavedGifsVewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, PreviewViewControllerDelegate {
    
    // Mark: - Properties
    
    // Holds saved gifs
    var gifs: [Gif] = [Gif]()
    var gifsSavePath: String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/savedGifs"
    }
    
    // Constants
    let cellMargin: CGFloat = 12.0
    let reuseId = "GifCell"
    
    // Outlets
    @IBOutlet weak var emptyViewImage: UIImageView!
    @IBOutlet weak var emptyViewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Load up archived gifs
    override func viewDidLoad() {
        
        // Bottom Blur
        let bottomBlur = CAGradientLayer()
        bottomBlur.frame = CGRect(x: 0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 100)
        bottomBlur.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(bottomBlur, above: collectionView.layer)
        
        // no point in checking for saved Gifs if this is the first launch
        if !showWelcomeScreen() {
            if let savedGifs = (NSKeyedUnarchiver.unarchiveObject(withFile: gifsSavePath) as? [Gif]) {
                gifs = savedGifs
            }
        }
        
        
        
    }
    
    // Setup collection view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "My Collection"
        
        // set theme
        applyTheme(.Light)
        
        emptyViewImage.isHidden = (gifs.count != 0 )
        if emptyViewImage.isHidden {
            emptyViewLabel.isHidden = true
        } else {
            self.navigationController?.navigationBar.isHidden = true
        }

        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        self.title = ""
    }
    
    // MARK: - Welcome Screen
    
    private func showWelcomeScreen() -> Bool {
        if UserDefaults.standard.bool(forKey: "WelcomeViewSeen") != true {
            let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController?.pushViewController(welcomeVC, animated: true)
            return true
        }
        return false
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! GifCollectionViewCell
        let gif = gifs[indexPath.item]
        cell.configureFor(gif: gif)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = gifs[indexPath.row]
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.gif = gif
        
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(detailVC, animated: true, completion: nil)
    }
    
    // MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin * 2)) / 2.0
        return CGSize(width: width, height: width)
    }
    
    // MARK: - PreviewVC Delegate
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        gif.gifData = NSData(contentsOf: gif.url)
        gifs.append(gif)
        NSKeyedArchiver.archiveRootObject(gifs, toFile: gifsSavePath)
    }

}
