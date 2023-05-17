//
//  TimeInterval+String.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import Foundation

extension TimeInterval {
    func formatTimeIntervalToString() -> String {
        let interval = Int(self)
        let hours = interval / 3600
        let minutes = (interval % 3600) / 60
        
        if hours > 0 {
            return String(format: "%dh %02dm", hours, minutes)
        } else {
            return String(format: "%dm", minutes)
        }
    }
}
