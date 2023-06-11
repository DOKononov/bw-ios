//
//  MicView.swift
//  BeWired
//
//  Created by Dmitry Kononov on 10.06.23.
//

import UIKit

final class MicView: UIView {
    
    var micButtonDidTapped: (()-> Void)?
    
    private lazy var backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .bwPrimaryBaseWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "What's going on?"
        label.font = .bwInterMedium12
        label.textColor = .bwPrimaryGray900
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let micImageView: UIImageView = {
        let image = UIImage.FeedVC.mic
        let imageView = UIImageView(image: image?.withTintColor(.bwPrimaryBaseWhite, renderingMode: .alwaysOriginal),
                                    highlightedImage: image?.withTintColor(.bwPrimaryGray500, renderingMode: .alwaysOriginal))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var circleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .bwPrimaryGray800
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(backgroundView)
        backgroundView.addSubview(label)
        backgroundView.addSubview(circleButton)
        circleButton.addSubview(micImageView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
        
            circleButton.heightAnchor.constraint(equalToConstant: 64),
            circleButton.widthAnchor.constraint(equalToConstant: 64),
            circleButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            circleButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -16),
            
            label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            label.trailingAnchor.constraint(greaterThanOrEqualTo: circleButton.leadingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 16),
            
            micImageView.leadingAnchor.constraint(equalTo: circleButton.leadingAnchor, constant: 20),
            micImageView.trailingAnchor.constraint(equalTo: circleButton.trailingAnchor, constant: -20),
            micImageView.topAnchor.constraint(equalTo: circleButton.topAnchor, constant: 20),
            micImageView.bottomAnchor.constraint(equalTo: circleButton.bottomAnchor, constant: -20)
            
        ])
        
        
        backgroundView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        backgroundView.layer.cornerRadius = 16

        circleButton.layer.cornerRadius = 32
        circleButton.clipsToBounds = true
        
        
        circleButton.layer.shadowColor = UIColor.bwPrimarySkyBlue500.withAlphaComponent(0.76).cgColor
        circleButton.layer.shadowOpacity = 1
        circleButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        circleButton.layer.shadowRadius = 4
        circleButton.layer.masksToBounds = false
        
    }
    
    @objc private func buttonDidTapped() {
        micImageView.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.micImageView.isHighlighted = false
        }
        micButtonDidTapped?()
    }
}
