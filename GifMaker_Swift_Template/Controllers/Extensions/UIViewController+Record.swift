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
import AVFoundation

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
    
    func convertVideoToGif(croppedURL: URL, start: NSNumber?, duration: NSNumber?) {
        
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
            let start: NSNumber? = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end: NSNumber? = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: (end!.floatValue) - (start.floatValue))
            } else {
                duration = nil
            }

//            dismiss(animated: true, completion: nil)
////            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
            cropVideoToSquare(rawVideoURL: videoURL, start: start, duration: duration)
        }
        
    }
    
    // MARK: - Cropping to square video
    
    func cropVideoToSquare(rawVideoURL: URL, start: NSNumber?, duration: NSNumber?) {
        
        //Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTimeMakeWithSeconds(60, 30))

        // rotate to portrait
        let tranformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let firstTransform = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2.0)
        let finalTransform = firstTransform.rotated(by: CGFloat.pi / 2)

        tranformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions = [tranformer]
        videoComposition.instructions = [instruction]
        
        // export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        
        let path = createPath()
        exporter.outputURL = URL(fileURLWithPath: path)
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        
        exporter.exportAsynchronously(completionHandler: {
            let croppedURL = (exporter.outputURL)!
            self.convertVideoToGif(croppedURL: croppedURL, start: start, duration: duration)
        })
        
//        NSString *path = [self createPath];
//        exporter.outputURL = [NSURL fileURLWithPath:path];
//        exporter.outputFileType = AVFileTypeQuickTimeMovie;
//        
//        __block NSURL *croppedURL;
//        
//        [exporter exportAsynchronouslyWithCompletionHandler:^(void){
//            croppedURL = exporter.outputURL;
//            [self convertVideoToGif:croppedURL start:start duration:duration];
//            }];

    }
    
    // Create a path
    func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        let manager = FileManager.default
        var outputURL = documentsDirectory.appending("/output")
        try? manager.createDirectory(atPath: outputURL, withIntermediateDirectories: true, attributes: nil)
        outputURL = outputURL.appending("/output.mov")
        
        // Remove Existing File
        try? manager.removeItem(atPath: outputURL)
        
        return outputURL
//        NSFileManager *manager = [NSFileManager defaultManager];
//        NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
//        [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
//        outputURL = [outputURL stringByAppendingPathComponent:@"output.mov"];
//        
//        // Remove Existing File
//        [manager removeItemAtPath:outputURL error:nil];
//        
//        return outputURL;
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
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(gifEditorVC, animated: true)
        }
        
    }
    
}
