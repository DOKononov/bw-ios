//
//  UIImage.swift
//  BeWired
//
//  Created by Dmitry Kononov on 8.06.23.
//

import UIKit

public extension UIImage {
    enum SplashVC {}
    enum FeedVC {}
    enum AudioPlayerView {}
    enum Profile {}
}

public extension UIImage.SplashVC {
    
    static var womanWithPhone: UIImage? {
        UIImage(named: "womanWithPhone")
    }
    static var elipse: UIImage? {
        UIImage(named: "elipse")
    }
    static var logoWithShadow: UIImage? {
        UIImage(named: "logoWithShadows")
    }
    static var logoWithoutBorder: UIImage? {
        UIImage(named: "logoWithoutBorder")
    }
    static var tgLogo: UIImage? {
        UIImage(named: "tg")
    }
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

public extension UIImage.AudioPlayerView {

    static var mic: UIImage? {
        UIImage(named: "mic")
    }
}

public extension UIImage.Profile {
    
    static var dots: UIImage? {
        UIImage(named: "dots")
    }
    
    static var gear: UIImage? {
        UIImage(named: "gear")
    }
}
