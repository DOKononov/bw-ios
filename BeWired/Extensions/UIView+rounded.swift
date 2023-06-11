//
//  UIView+rounded.swift
//  BeWired
//
//  Created by Dmitry Kononov on 6.05.23.
//

import UIKit

extension UIView {
    
    func makeRounded(_ mult: Shape) {
        self.layoutIfNeeded()
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = self.frame.height / mult.value
        clipsToBounds = true
    }
    
    func makeRounded(_ radius: CGFloat) {
        self.layoutIfNeeded()
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func makeRounded(_ radius: CGFloat,_ border: Bool) {
        self.layoutIfNeeded()
        border ? (layer.borderWidth = 1) : (layer.borderWidth = 0)
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func makeRounded(_ mult: Shape,_ border: Bool) {
        self.layoutIfNeeded()
        border ? (layer.borderWidth = 1) : (layer.borderWidth = 0)
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = self.frame.height / mult.value
        clipsToBounds = true
    }

    
    enum Shape: CGFloat {
        case circle
        case rectangel
        
        var value: CGFloat {
            switch self {
            case .circle: return 2
            case .rectangel: return 3
            }
        }
    }

}
