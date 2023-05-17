//
//  BeWiredCell.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import UIKit

final class BeWiredCell: UITableViewCell {
    
    func configure(with beWired: BeWiredTest) {
        var content = self.defaultContentConfiguration()
        content.image = UIImage(named: "tg")
        content.imageProperties.cornerRadius = self.bounds.height / 2
        content.text = beWired.user
        backgroundView?.alpha = 0
        let dateText = beWired.date.formatDateToString()
        let durationText = beWired.duration.formatTimeIntervalToString()
        content.secondaryText = "Release Date: \(dateText), duration: \(durationText)"
        self.contentConfiguration = content
    }
}
