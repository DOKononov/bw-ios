//
//  FeedCell.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.06.23.
//

import UIKit

final class FeedCell: UICollectionViewCell {

    private let cellView: UIView = {
       let view = UIView()
        view.backgroundColor = .bwPrimaryBaseWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "testImage")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topStackView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [durationLabel, dotView, userNameLabel])
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let durationLabel: UILabel = {
       let label = UILabel()
        label.textColor = .bwPrimaryGray600
        label.font = .bwInterMedium10
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dotView: UILabel = {
       let label = UILabel()
        label.textColor = .bwPrimaryGray500
        label.text = "•"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = .bwInterMedium10
        label.textColor = .bwPrimaryGray600
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
         label.font = .bwInterBold16
         label.textColor = .bwPrimaryGray800
         label.numberOfLines = 1
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()


    private func addsubviews() {
        addSubview(cellView)
        cellView.addSubview(imageView)
        cellView.addSubview(topStackView)
        cellView.addSubview(dateLabel)

    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([

            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            imageView.heightAnchor.constraint(equalToConstant: 48),
            imageView.widthAnchor.constraint(equalToConstant: 48),
            imageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 14),
            imageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14),
            
            topStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            topStackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(lessThanOrEqualTo: cellView.trailingAnchor, constant: -16),
            topStackView.heightAnchor.constraint(equalToConstant: 12),
            
            dateLabel.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 2),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: cellView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(greaterThanOrEqualTo: cellView.bottomAnchor, constant: -22)
            
        ])
        cellView.makeRounded(20, false)
        imageView.makeRounded(10, false)
    }
    

    func configue(indexpath: IndexPath) {
        addsubviews()
        setupLayouts()
        userNameLabel.text = "Richard Rich"
        durationLabel.text = "1:15:01"
        dateLabel.text = "7-12 May diaries"

    }
}
