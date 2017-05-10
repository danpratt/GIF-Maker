//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Pratt on 5/5/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

//@property (nonatomic) NSURL *url;
//@property (nonatomic) NSString *caption;
//@property (nonatomic) UIImage *gifImage;
//@property (nonatomic) NSURL *videoURL;
//@property (nonatomic) NSData *gifData;
//
//-(instancetype)initWithGifURL: (NSURL*)url videoURL:(NSURL*)videoURL caption:(NSString*)caption;
//-(instancetype)initWithName:(NSString*)name;
//@end

class Gif: NSObject, NSCoding {
    
    // Mark: - class properties
    let url: URL
    let videoURL: URL
    let caption: String?
    let gifImage: UIImage
    var gifData: NSData?
    
    init(url: URL, videoURL: URL, caption: String?) {
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString)!
        self.gifData = nil
        
    }
    
    // MARK: - NSCoding Protocol Functions
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as! URL
        self.videoURL = aDecoder.decodeObject(forKey: "videoURL") as! URL
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.gifImage = aDecoder.decodeObject(forKey: "gifImage") as! UIImage
        self.gifData = aDecoder.decodeObject(forKey: "gifData") as? NSData
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.videoURL, forKey: "videoURL")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.gifImage, forKey: "gifImage")
        aCoder.encode(self.gifData, forKey: "gifData")
    }
    
}
