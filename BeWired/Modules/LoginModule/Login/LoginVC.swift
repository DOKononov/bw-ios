
import UIKit

final class LoginVC: UIViewController {
    
    private var viewmodel: LoginViewModelProtocol
    
    init(viewmodel: LoginViewModelProtocol) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let pleaseLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Please login"
        label.font = .interSemiBold24()
        label.textColor = .primaryGray900
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter mobile number registered with Telegram"
        label.font = .interMedium12()
        label.textColor = .primaryGray400
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneNumberTextfield: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = Constants.cornerRadius10
        tf.backgroundColor = .primaryGray50
        tf.font = .interMedium16()
        tf.textColor = .primaryGray900
        tf.indent(size: Constants.offset10)
        tf.attributedPlaceholder =  NSAttributedString(string: "+123456667788",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryGray400, .font: UIFont.interMedium16() ?? .systemFont(ofSize: Constants.size12)])
        return tf
    }()
    
    private let sendButton: UIButton = {
        let button = PrimaryButton(text: "Send me a code", fillColor: .primaryGray900, tintColor: .white, borderColor: .clear, font: .interSemiBold16() ?? UIFont(), cornerRadius: Constants.cornerRadius14)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        initialize()
        bind()
        view.backgroundColor = .white
        phoneNumberTextfield.delegate = self
        setupLayout()
        view.addTapGestureToHideKeyboard()
    }
    
    private func initialize() {
        addSubviews()
        addTargets()
    }
    
    private func bind() {
        viewmodel.didSetPhoneNumber = { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async {
                let nextVC = ConfirmationVC(viewmodel: ConfirmationViewModel(auth: self.viewmodel.auth))
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
        }
        viewmodel.didReciveError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.pleaseLoginLabel.text = errorMessage
                self?.pleaseLoginLabel.font = .systemFont(ofSize: Constants.size12)
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(pleaseLoginLabel)
        view.addSubview(phoneNumberTextfield)
        view.addSubview(sendButton)
        view.addSubview(hintLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            pleaseLoginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.offset168),
            pleaseLoginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset16),
            pleaseLoginLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset16),
            pleaseLoginLabel.heightAnchor.constraint(equalToConstant: Constants.height50),
            
            phoneNumberTextfield.topAnchor.constraint(equalTo: pleaseLoginLabel.bottomAnchor, constant: Constants.offset16),
            phoneNumberTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            phoneNumberTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset16),
            phoneNumberTextfield.heightAnchor.constraint(equalToConstant: Constants.height48),
            
            hintLabel.topAnchor.constraint(equalTo: phoneNumberTextfield.bottomAnchor, constant: Constants.offset2),
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset26),
            hintLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset26),
            hintLabel.heightAnchor.constraint(equalToConstant: Constants.height16),
            
            sendButton.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: Constants.offset40),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset16),
            sendButton.heightAnchor.constraint(equalToConstant: Constants.height52)
            
        ])
        sendButton.makeRounded(.rectangel)
    }
    
    private func addTargets() {
        sendButton.addTarget(self, action: #selector(sendButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func sendButtonDidTapped() {
        //TODO: phone number validation
        if let text = phoneNumberTextfield.text, !text.isEmpty {
            viewmodel.setPhoneNumber(text)
        }
    }
}

// MARK: TextField delegate methods
extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .clear
        textField.layer.borderWidth = Constants.width1
        textField.layer.borderColor = UIColor.primarySkyBlue600.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 1
        guard
            let phoneNumber = textField.text,
            !phoneNumber.isEmpty else {
            textField.backgroundColor = .primaryGray50
            textField.layer.borderWidth = Constants.width0
            textField.layer.borderColor = UIColor.clear.cgColor
            return
        }
        // 2
        textField.layer.borderWidth = Constants.width1
        textField.layer.borderColor = UIColor.primarySkyBlue400.cgColor
        // 3
        if viewmodel.isValidPhone(number: phoneNumber) {
            sendButton.isHidden = false
            sendButton.isEnabled = true
        }
    }
}
