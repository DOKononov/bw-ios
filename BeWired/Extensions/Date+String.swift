//
//  Date+String.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import Foundation

extension Date {
    func formatDateToString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        return dateFormater.string(from: self)
    }
    
    func convertedToIdString() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "_yyyy.MM.dd_HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
}
