
import UIKit

final class DeckTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "\(DeckTableViewCell.self)")
        addSubview(self.timeStampLabel)
        addSubview(self.descriptionLabel)
        addSubview(self.playAudioStatus)
        self.backgroundColor = .white
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   var cl: (() -> Void)?
    // MARK: - Label
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
    
    // MARK: - ImageView
    private let playAudioStatus: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: String.AssetsNames.playAudioStatus)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    func setCell(model: Timestams) {
        timeStampLabel.text = model.time
        descriptionLabel.text = model.description
    }
}

// MARK: Constraints
extension DeckTableViewCell {
    
    private func constraints() {
        NSLayoutConstraint.activate([
            
            timeStampLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.offset13),

            timeStampLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset12),
            timeStampLabel.widthAnchor.constraint(equalToConstant: Constants.width30),
            timeStampLabel.heightAnchor.constraint(equalToConstant: Constants.height12),
            
            descriptionLabel.topAnchor.constraint(equalTo: timeStampLabel.bottomAnchor, constant: Constants.offset6),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset12),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.offset12),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.offset10),
            
            playAudioStatus.topAnchor.constraint(equalTo: timeStampLabel.topAnchor),
            playAudioStatus.leadingAnchor.constraint(equalTo: timeStampLabel.trailingAnchor, constant: Constants.offset6),
            playAudioStatus.widthAnchor.constraint(equalToConstant: Constants.width11),
            playAudioStatus.heightAnchor.constraint(equalToConstant: Constants.height12)
        ])
    }
}
