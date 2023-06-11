import UIKit

final class DeckHeaderView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.setupView()
        addSubview()
        constraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addSubview()
        constraints()
    }
    
    func fillingHeader(model: TestDairysModel) {
        titleLabel.text = model.title
        titleLabel.font = .interSemiBold14()
        model.likeCount > 0 ? heartButton.setImage(UIImage(named: String.AssetsNames.fillSkyHeart), for: .normal) : heartButton.setImage(UIImage(named: String.AssetsNames.unFillGrayHeart), for: .normal)
        likeCountLabel.text = "\(model.likeCount)"
        timeLabel.text = model.time + " " + "•" + " " + model.partsCount
        
    }
    
    // MARK: - Label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .interMedium10()
        label.textColor = .primarySkyBlue700
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .interMedium10()
        label.textColor = .primaryGray600
        return label
    }()
    
    // MARK: - Button
    let heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func addSubview() {
        self.addSubview(titleLabel)
        self.addSubview(likeCountLabel)
        self.addSubview(heartButton)
        self.addSubview(timeLabel)
    }
  
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true
    }
}

// MARK: - Constraints
extension DeckHeaderView {
    
    func constraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Constants.height60),
            
            likeCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.offset13),
            likeCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.offset12),
            likeCountLabel.widthAnchor.constraint(equalToConstant: Constants.width11),
            likeCountLabel.heightAnchor.constraint(equalToConstant: Constants.height12),
            
            heartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.offset13),
            heartButton.trailingAnchor.constraint(equalTo: likeCountLabel.leadingAnchor, constant: -Constants.offset6),
            heartButton.widthAnchor.constraint(equalToConstant: Constants.width13),
            heartButton.heightAnchor.constraint(equalToConstant: Constants.height11),
            
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.offset13),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset12),
            timeLabel.trailingAnchor.constraint(equalTo: self.heartButton.leadingAnchor, constant: -Constants.offset8),
            timeLabel.heightAnchor.constraint(equalToConstant: Constants.height16),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.offset12),
            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Constants.offset6)
            ])
    }
}
