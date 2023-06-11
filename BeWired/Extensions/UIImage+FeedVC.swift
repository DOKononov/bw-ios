//
//  UIImage.swift
//  BeWired
//
//  Created by Dmitry Kononov on 8.06.23.
//

import UIKit

public extension UIImage {
    enum FeedVC {}
}

public extension UIImage.FeedVC {
    
    static var bwLogo: UIImage? {
        UIImage(named: "bwLogo")
    }
    
    static var heart: UIImage? {
        UIImage(named: "heart")
    }
    
    static var magnifier: UIImage? {
        UIImage(named: "magnifier")
    }
    
    static var mic: UIImage? {
        UIImage(named: "mic")
    }
    
}
