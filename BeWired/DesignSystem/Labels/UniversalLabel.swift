
import UIKit

final class UniversalLabel: UILabel {
    
    convenience init(text: String, textColor: UIColor, font: UIFont, textAlign: NSTextAlignment) {
        self.init()
        configure(text: text, textColor: textColor, font: font, textAlign: textAlign)
    }
}

// MARK: - Private extension
private extension UniversalLabel {
    func configure(text: String, textColor: UIColor, font: UIFont, textAlign: NSTextAlignment) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = 0
        self.textAlignment = textAlign
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
