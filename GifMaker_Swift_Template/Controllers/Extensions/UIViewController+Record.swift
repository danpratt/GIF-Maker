//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/4/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

// Regift constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // loop forever

// Pink Color
let pinkColor = UIColor(red: 1, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - launch video options
    
    @IBAction func presentVideoOptions(sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            launchPhotoLibrary()
            
        } else {
            // create the action sheet
            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: .actionSheet)
            
            // recordVideo option
            let recordVideo = UIAlertAction(title: "Record a Video", style: .default, handler: { (UIAlertAction) in
                self.launchVideoCamera()
            })
            newGifActionSheet.addAction(recordVideo)
            
            // pick from photo library option
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .default, handler: { (UIAlertAction) in
                self.launchPhotoLibrary()
            })
            newGifActionSheet.addAction(chooseFromExisting)
            
            // cancel
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            newGifActionSheet.view.tintColor = pinkColor
        }
    }
    
    // MARK: - Methods for handling camera and photo library
    
    func launchVideoCamera() {
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = .camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = true
        recordVideoController.delegate = self
        present(recordVideoController, animated: true, completion:  nil)
    }
    
    func launchPhotoLibrary() {
        let photoLibraryController = UIImagePickerController()
        photoLibraryController.sourceType = .photoLibrary
        photoLibraryController.mediaTypes = [kUTTypeMovie as String]
        photoLibraryController.allowsEditing = true
        photoLibraryController.delegate = self
        present(photoLibraryController, animated: true, completion: nil)
    }
    
    // MARK: - Methods to handle video editing
    
    // Trimming
    
    func convertVideoToGif(croppedURL: URL, start: NSNumber?, end: NSNumber?, duration: NSNumber?) {
        
        var regift: Regift
        
        if start == nil {
            // untrimmed
            regift = Regift(sourceFileURL: croppedURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        } else {
            // trimmed
            regift = Regift(sourceFileURL: croppedURL, destinationFileURL: nil, startTime: (start?.floatValue)!, duration: (duration?.floatValue)!, frameRate: frameCount, loopCount: loopCount)
        }
        
        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: croppedURL, caption: nil)
        displayGIF(gif: gif)
    }
    
    
    // MARK: - imagePickerController delegate methods
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            convertVideoToGIF(videoURL: videoURL)
//            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - GIF Conversion Methods
    func convertVideoToGIF(videoURL: URL) {
        let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)
        displayGIF(gif: gif)
    }
    
    func displayGIF(gif: Gif) {
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }
    
}
