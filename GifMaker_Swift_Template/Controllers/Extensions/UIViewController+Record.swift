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

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - launch video camera
    
    @IBAction func launchVideoCamera(sender: AnyObject) {
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = .camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        // will change to true later
        recordVideoController.allowsEditing = false
        recordVideoController.delegate = self
        present(recordVideoController, animated: true, completion:  nil)
    }
    
    
    // MARK: - imagePickerController delegate methods
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
