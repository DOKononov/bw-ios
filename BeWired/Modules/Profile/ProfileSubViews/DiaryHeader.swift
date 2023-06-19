import UIKit

final class DiaryHeader: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bwInterSemiBold14
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .bwInterMedium10
        label.textColor = .bwPrimaryGray600
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview()
        setupLayouts()
        self.backgroundColor = .bwPrimaryBaseWhite
        self.layer.cornerRadius = Constants.cornerRadius10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
    }

    
    func config(with model: TestDairysModel) {
        titleLabel.text = model.title
        timeLabel.text = model.time + " • " + model.partsCount
    }
}

// MARK: - Constraints
extension DiaryHeader {
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 60),

            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            timeLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -12),
            timeLabel.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -8)
            ])
    }
}
