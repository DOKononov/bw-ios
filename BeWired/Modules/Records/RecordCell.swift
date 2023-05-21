//
//  RecordCell.swift
//  BeWired
//
//  Created by Dmitry Kononov on 20.05.23.
//

import UIKit

final class RecordCell: UITableViewCell {
    
    func configure(with record: URL) {
        var content = self.defaultContentConfiguration()
        content.text = record.lastPathComponent
        self.backgroundColor = .secondarySystemBackground
        self.contentConfiguration = content
    }
}
