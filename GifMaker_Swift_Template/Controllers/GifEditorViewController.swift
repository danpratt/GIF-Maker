//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/4/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import Foundation

class GifEditorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var gif:Gif?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gifImageView.image = gif?.gifImage
        
        // setup text attributes
        let defaultAttributes: [String: Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSStrokeWidthAttributeName: -4.0,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!
            ]
        
        let fadedWhite = UIColor(white: 1, alpha: 0.3)
        let fadedBlack = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        
        let defaultPlaceholderAttributes: [String: Any] = [
            NSStrokeColorAttributeName: fadedBlack,
            NSStrokeWidthAttributeName: -4.0,
            NSForegroundColorAttributeName: fadedWhite,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!
        ]
        
        captionTextField.defaultTextAttributes = defaultAttributes
        captionTextField.textAlignment = .center
        captionTextField.attributedPlaceholder = NSAttributedString(string: "Add Caption", attributes: defaultPlaceholderAttributes)
        
        // subscribe to delegates
        captionTextField.delegate = self
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }

    
    // MARK: - UITextField delegate methods
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Add caption and present preview
    
    @IBAction func presentPreview(_ sender: Any) {
        let regift = Regift(sourceFileURL: (gif?.videoURL)!, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let caption = self.captionTextField.text
        let captionFont = self.captionTextField.font
        let gifURL = regift.createGif(caption: caption, font: captionFont)
        let newGif = Gif(url: gifURL!, videoURL: (gif?.videoURL)!, caption: caption)
        
        let previewVC = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        let savedGifsVC = navigationController?.viewControllers.first
        
        previewVC.gif = newGif
        previewVC.delegate = savedGifsVC as! SavedGifsVewController
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // MARK: - Keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow (_ notification: NSNotification) {
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide (_ notification: NSNotification) {
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardFrameEnd = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrameEnd.cgRectValue.height
    }
}
