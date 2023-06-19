import UIKit

final class PrimaryButton: UIButton {
    
    convenience init(text: String = "", fillColor: UIColor, tintColor: UIColor, borderColor: UIColor, font: UIFont, cornerRadius: CGFloat) {
        self.init(type: .system)
        configure(with: text, and: fillColor, and: tintColor, and: borderColor, and: font, and: cornerRadius)
    }
}

// MARK: - Private extension
private extension PrimaryButton {
    func configure(with text: String, and fillColor: UIColor, and tintColor: UIColor, and borderColor: UIColor, and font: UIFont, and cornerRadius: CGFloat) {
        self.backgroundColor = fillColor
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(tintColor, for: .normal)
        self.setTitleColor(.bwPrimaryGray400, for: .disabled)
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
