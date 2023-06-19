//
//  ProfileViewButton.swift
//  BeWired
//
//  Created by Dmitry Kononov on 15.06.23.
//

import UIKit

final class ProfileViewButton: UIButton  {
    
    enum Title: String {
        case entries = "entries"
        case following = "following"
        case followers = "followers"
    }
    
    var count = 124 {
        didSet {
            countLabel.text = "\(count)"
        }
    }
    
    var indicatorIsHiden = true {
        didSet {
            indicator.isHidden = indicatorIsHiden
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                countLabel.textColor = .bwPrimaryGray400
                buttonTitleLabel.textColor = .bwPrimaryGray400
            } else {
                countLabel.textColor = .bwPrimaryGray900
                buttonTitleLabel.textColor = .bwPrimaryGray600
            }
        }
    }
    
    var buttonTitle: Title

    private lazy var countLabel: UILabel = {
        let label = UILabel()
         label.text = "\(count)"
         label.textColor = .bwPrimaryGray900
         label.font = .bwInterMedium16
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let buttonTitleLabel: UILabel = {
        let label = UILabel()
         label.textColor = .bwPrimaryGray600
         label.font = .bwInterMedium10
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let indicator: UIView = {
        let view = UIView()
         view.backgroundColor = .bwPrimarySkyBlue600
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
    }()
    
    init(title: Title) {
        buttonTitle = title
        buttonTitleLabel.text = title.rawValue
        indicator.isHidden = true
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        addSubviews()
        setupLayouts()
        indicator.makeRounded(.circle, false)
                
    }
    
    private func addSubviews() {
        addSubview(countLabel)
        addSubview(buttonTitleLabel)
        addSubview(indicator)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
        
            countLabel.topAnchor.constraint(equalTo: self.topAnchor),
            countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 19),
            countLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55),
            
            buttonTitleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor),
            buttonTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 2),
            buttonTitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -2),
            buttonTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            
            indicator.widthAnchor.constraint(equalToConstant: 8),
            indicator.heightAnchor.constraint(equalToConstant: 8),
            indicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            indicator.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 0.5),
            indicator.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -24)

        ])
    }
    
}
