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
        titleLabel.font = .bwInterSemiBold14
        timeLabel.text = model.time + " " + "•" + " " + model.partsCount
        
    }
    
    // MARK: - Label
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bwInterMedium10
        label.textColor = .bwPrimaryGray600
        return label
    }()
    
    private func addSubview() {
        self.addSubview(titleLabel)
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
 
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.offset13),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset12),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.offset12),
            timeLabel.heightAnchor.constraint(equalToConstant: Constants.height16),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.offset12),
            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Constants.offset6)
            ])
    }
}
