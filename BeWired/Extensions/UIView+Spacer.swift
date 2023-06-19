//
//  UIView+Spacer.swift
//  BeWired
//
//  Created by Dmitry Kononov on 8.06.23.
//

import UIKit

extension UIView {
    
    static var spacer: UIView {
        let spacer = UIView()
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow
        return spacer
    }
}
