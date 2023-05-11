//
//  LoginVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 6.05.23.
//

import UIKit

final class LoginVC: UIViewController {
    
    private var viewmodel: LoginViewModelProtocol = LoginViewModel()
    
    private let welcomLabel: UILabel = {
        let label = UILabel()
        label.text = "Please login first"
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelSize, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let phoneNumberTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "telegram number +123456667788"
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let telegramImageView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "tg"), highlightedImage: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send code", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        bind()
        view.backgroundColor = .systemBackground
        phoneNumberTextfield.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    
    private func initialize() {
        addSubviews()
        addTargets()
    }
    
    private func bind() {
        viewmodel.didSetPhoneNumber = { [weak self] in
            DispatchQueue.main.async {
                let nextVC = ConfirmationVC()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }

        }
        viewmodel.didReciveError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.welcomLabel.text = errorMessage
                self?.welcomLabel.font = .systemFont(ofSize: Constants.errorLabelSize)
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(welcomLabel)
        view.addSubview(phoneNumberTextfield)
        view.addSubview(sendButton)
        view.addSubview(telegramImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            welcomLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            welcomLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offsetS),
            welcomLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offsetS),
            welcomLabel.heightAnchor.constraint(equalToConstant: Constants.regularLabelHeight),
            
            telegramImageView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: Constants.offsetM),
            telegramImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offsetS),
            telegramImageView.widthAnchor.constraint(equalToConstant: Constants.regularTextFieldHeight),
            telegramImageView.heightAnchor.constraint(equalToConstant: Constants.regularTextFieldHeight),
            
            phoneNumberTextfield.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: Constants.offsetM),
            phoneNumberTextfield.leadingAnchor.constraint(equalTo: telegramImageView.trailingAnchor, constant: Constants.offsetS),
            phoneNumberTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offsetS),
            phoneNumberTextfield.heightAnchor.constraint(equalToConstant: Constants.regularTextFieldHeight),
            
            sendButton.topAnchor.constraint(equalTo: phoneNumberTextfield.bottomAnchor, constant: Constants.offsetM),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: Constants.regularButtonWidth),
            sendButton.heightAnchor.constraint(equalToConstant: Constants.regularButtonHeight)
            
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumberTextfield.endEditing(true)
    }
}
