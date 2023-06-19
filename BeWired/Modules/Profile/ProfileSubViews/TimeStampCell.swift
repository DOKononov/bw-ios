
import UIKit

final class TimeStampCell: UITableViewCell {

   private let timeStampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bwInterMedium10
        label.textColor = .bwPrimarySkyBlue600
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bwInterMedium12
        label.textColor = .bwPrimaryGray900
        label.numberOfLines = 0
        return label
    }()
    
    let dotsButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.Profile.dots
        button.setImage(image?.withTintColor(.bwPrimaryGray500, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(image?.withTintColor(.bwPrimaryGray300, renderingMode: .alwaysOriginal), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(timeStampLabel)
        addSubview(descriptionLabel)
        addSubview(dotsButton)
        constraints()
        self.layer.masksToBounds = true
    }

    func setCell(model: Timestams) {
        timeStampLabel.text = model.time
        descriptionLabel.text = model.description
    }
}

extension TimeStampCell {
    
    private func constraints() {
        NSLayoutConstraint.activate([
            dotsButton.heightAnchor.constraint(equalToConstant: 16),
            dotsButton.widthAnchor.constraint(equalToConstant: 16),
            dotsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            dotsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            
            timeStampLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            timeStampLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            timeStampLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            timeStampLabel.heightAnchor.constraint(equalToConstant: 12),
            
            descriptionLabel.topAnchor.constraint(equalTo: timeStampLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: timeStampLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: dotsButton.trailingAnchor, constant: -12),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 16),
            descriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -10),
        ])
    }
}
