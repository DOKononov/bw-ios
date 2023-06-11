
import UIKit

final class SingleDigitTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        setTextFieldStyle()
        constraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let bottomHighLight: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryGray400
        return view
    }()
    
}
    // MARK: - Set tf
    private extension SingleDigitTextField {
      
         func setTextFieldStyle() {
             translatesAutoresizingMaskIntoConstraints = false
             backgroundColor = UIColor.primaryGray400
             layer.borderWidth = Constants.width0
             font = .interSemiBold16()
             backgroundColor = .clear
             textAlignment = .center
             keyboardType = .numberPad
             addSubview(bottomHighLight)
        }
    }

// MARK: Constraints
extension SingleDigitTextField {
    
    func constraints() {
        
        self.widthAnchor.constraint(equalToConstant: Constants.width32).isActive = true
        self.heightAnchor.constraint(equalToConstant: Constants.height32).isActive = true
    
        bottomHighLight.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomHighLight.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomHighLight.heightAnchor.constraint(equalToConstant: Constants.height1).isActive = true
        bottomHighLight.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

