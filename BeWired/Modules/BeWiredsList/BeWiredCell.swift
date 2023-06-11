//
//  BeWiredCell.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import UIKit

final class BeWiredCell: UITableViewCell {
    
    func configure(with beWired: URL) {
        var content = self.defaultContentConfiguration()
        content.image = UIImage(named: "tg")
        content.imageProperties.cornerRadius = self.bounds.height / 2
        
        var title = beWired.lastPathComponent
        title = title.dropPrefix(RecordType.bewired.rawValue)
        title = title.dropSuffix(".pcm")
        
        content.text = title
        self.backgroundColor = .secondarySystemBackground
        let dateText = "TODO"
        let durationText = "TODO"
        content.secondaryText = "Release Date: \(dateText), duration: \(durationText)"
        self.contentConfiguration = content
    }
}
