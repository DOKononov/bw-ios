
import UIKit

final class ConfirmationVC: UIViewController {
    
    private var viewmodel: ConfirmationViewModelProtocol
    
    private lazy var textFieldArray = [self.firstDigitTextField, self.secondDigitTextField, self.thirdDigitTextField, self.fourDigitTextField, self.fiveDigitTextField]
    
    init(viewmodel: ConfirmationViewModelProtocol) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Labels
    private let enterCode = UniversalLabel(text: "Enter a code", textColor: .bwPrimaryGray900, font: .bwInterSemiBold24 ?? UIFont.systemFont(ofSize: Constants.size24), textAlign: .left)
    
    private let hintLabel = UniversalLabel(text: "We've sent you a 5-digit login code. Please check your Telegram.", textColor: .bwPrimaryGray600, font: .bwInterMedium14 ?? UIFont.systemFont(ofSize: Constants.size14), textAlign: .left)

    
    // MARK: - View
    private let inputCodeField: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.cornerRadius10
        view.backgroundColor = .bwPrimaryGray50

        return view
    }()
    
    // MARK: - TextFields
    private let firstDigitTextField = SingleDigitTextField()
    private let secondDigitTextField = SingleDigitTextField()
    private let thirdDigitTextField = SingleDigitTextField()
    private let fourDigitTextField = SingleDigitTextField()
    private let fiveDigitTextField = SingleDigitTextField()
    
    // MARK: - StackView
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.firstDigitTextField, self.secondDigitTextField, self.thirdDigitTextField, self.fourDigitTextField, self.fiveDigitTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.offset8
        return stackView
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        view.addTapGestureToHideKeyboard()
        
        initialize()
        bind()
        textFieldArray.forEach { $0.delegate = self }
        setupLayout()
    }
    
    private func initialize() {
        addSubviews()
        addTargets()
    }
    
    private func bind() {
        viewmodel.didConfirmPhoneNumber = { [weak self] in
            guard let self else {return}
            
            DispatchQueue.main.async {
                let nextVC = FeedVC(viewmodel: FeedVM(authService: self.viewmodel.auth))
                self.navigationController?.setViewControllers([nextVC], animated: true)
            }
        }
        viewmodel.didReciveError = { [weak self] errorMessage in
            switch errorMessage {
            case "Password invalid":
                DispatchQueue.main.async {
                    self?.showAlertWithSecureTextInput()
                }
            default:
                DispatchQueue.main.async {
                    self?.showErrorAlert(for: errorMessage)
                }
            }
        }
        viewmodel.showTwoStepAuthAlert = { [ weak self ] in
            DispatchQueue.main.async {
                self?.showAlertWithSecureTextInput()

            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(enterCode)
        view.addSubview(hintLabel)
        view.addSubview(inputCodeField)
        inputCodeField.addSubview(textFieldStackView)
    }
    
    private func textfieldCodeAssembler() -> String {
        // 1
        var code = String()
        // 2
        textFieldArray.forEach { digit in
            // 3
            guard let digitText = digit.text else {
                return
            }
            code += digitText
        }
        // 4
        return code
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            enterCode.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            enterCode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            enterCode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset16),
            enterCode.heightAnchor.constraint(equalToConstant: Constants.height50),
            
            hintLabel.topAnchor.constraint(equalTo: enterCode.bottomAnchor, constant: Constants.offset10),
            hintLabel.leadingAnchor.constraint(equalTo: enterCode.leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: enterCode.trailingAnchor),
            hintLabel.heightAnchor.constraint(equalToConstant: Constants.offset40),
            
            inputCodeField.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: Constants.offset22),
            inputCodeField.leadingAnchor.constraint(equalTo: hintLabel.leadingAnchor),
            inputCodeField.trailingAnchor.constraint(equalTo: hintLabel.trailingAnchor),
            inputCodeField.heightAnchor.constraint(equalToConstant: Constants.height48),
            
            textFieldStackView.centerXAnchor.constraint(equalTo: inputCodeField.centerXAnchor),
            textFieldStackView.centerYAnchor.constraint(equalTo: inputCodeField.centerYAnchor)
        ])
    }
}
// MARK: - Actions
extension ConfirmationVC {
    
    private func addTargets() {
        textFieldArray.forEach({$0.addTarget(self, action: #selector(textFieldEditingChanged(sender: )), for: .editingChanged)})
    }
    
    @objc private func textFieldEditingChanged(sender: SingleDigitTextField) {
        // 1
        let currentIndex = textFieldArray.firstIndex(of: sender)
        // 2
        if let currentIndex = currentIndex {
            if sender.text?.isEmpty ?? true {
                sender.bottomHighLight.backgroundColor = .bwPrimaryGray400

                if currentIndex > 0 {
                    let previousTextField = textFieldArray[currentIndex - 1]
                    previousTextField.becomeFirstResponder()
                }
            } else {
                // 3
                sender.bottomHighLight.backgroundColor = .bwPrimarySkyBlue600

                if currentIndex < textFieldArray.count - 1 {
                    let nextTextField = textFieldArray[currentIndex + 1]
                    nextTextField.becomeFirstResponder()
                } else {
                    let code = textfieldCodeAssembler()
                    viewmodel.confirmPhoneNumber(with: code)
                    sender.resignFirstResponder()
                }
            }
        }
    }
}

// MARK: - Alert Controller
extension ConfirmationVC {
    
    func showAlertWithSecureTextInput() {
        // 1
        let alertController = UIAlertController(title: "Enter your 2FA pass", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        // 2
        let submitAction = UIAlertAction(title: "Send", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let text = textField.text {
                self.viewmodel.checkTwoStepAuth(pass: text)
            }
        }
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [ weak self ] _ in
            guard let self else {
                return
            }
            self.navigationController?.popToRootViewController(animated: true)

        }
        // 4
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        // 5
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TextField delegate

extension ConfirmationVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputCodeField.backgroundColor = .clear
        inputCodeField.layer.borderWidth = Constants.width1
        inputCodeField.layer.borderColor = UIColor.bwPrimarySkyBlue600.cgColor

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 1
        var textFieldIsEmpty = true
        // 2
        textFieldArray.forEach { tf in
            if !(tf.text?.isEmpty ?? false) {
                textFieldIsEmpty = false
                return
            }
        }
        // 3
        if textFieldIsEmpty {
            inputCodeField.layer.borderWidth = Constants.width0
            inputCodeField.layer.borderColor = UIColor.bwPrimaryGray50.cgColor

        }
    }
}




