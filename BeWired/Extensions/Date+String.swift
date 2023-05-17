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
}
