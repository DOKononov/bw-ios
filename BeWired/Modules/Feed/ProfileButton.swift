//
//  Feed+ProfileButton.swift
//  BeWired
//
//  Created by Dmitry Kononov on 9.06.23.
//

import UIKit

class ProfileButton: UIButton {
    
    var badgeText: String? { didSet { updateBadge() } }
    
    private lazy var badgeLabel : UILabel = {
        let label = UILabel()
        label.text = badgeText
        label.textColor = .bwPrimaryBaseWhite
        label.backgroundColor = .bwPrimarySkyBlue600
        label.font = .bwInterMedium10
        label.sizeToFit()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        profileImageView.image = image
    }
    

    init(image: UIImage) {
        super.init(frame: .zero)
        updateBadge()
        profileImageView.image = image
        addSubview(profileImageView)
        addSubview(badgeLabel)
        setupLayout()
    }
    
    private func updateBadge() {
        badgeLabel.text = badgeText
        badgeLabel.isHidden = (badgeText != nil && badgeText != "0") ? false : true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 24),
            profileImageView.widthAnchor.constraint(equalToConstant: 24),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            badgeLabel.widthAnchor.constraint(equalToConstant: 16),
            badgeLabel.heightAnchor.constraint(equalToConstant: 16),
            badgeLabel.centerXAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: profileImageView.topAnchor)
        ])
        
        profileImageView.makeRounded(.circle, false)
        badgeLabel.makeRounded(.circle, false)
    }
    
    
    
    
}
