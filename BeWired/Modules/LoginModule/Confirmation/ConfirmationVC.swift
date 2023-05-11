//
//  ConfirmationVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.05.23.
//

import UIKit

final class ConfirmationVC: UIViewController {
    
    private var viewmodel: ConfirmationViewModelProtocol = ConfirmationViewModel()
    
    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter telegram Login code"
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelSize, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let loginCodeTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Logine code: 12345"
        tf.keyboardType = .numberPad
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
        button.setTitle("Enter code", for: .normal)
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
        loginCodeTextfield.becomeFirstResponder()
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
        viewmodel.didConfirmPhoneNumber = { [weak self] in
            DispatchQueue.main.async {
                let nextVC = WelcomeVC()
                self?.navigationController?.setViewControllers([nextVC], animated: true)
            }
        }
        viewmodel.didReciveError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.confirmLabel.text = errorMessage
                self?.confirmLabel.font = .systemFont(ofSize: Constants.errorLabelSize)
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(confirmLabel)
        view.addSubview(loginCodeTextfield)
        view.addSubview(sendButton)
        view.addSubview(telegramImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            confirmLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            confirmLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offsetS),
            confirmLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offsetS),
            confirmLabel.heightAnchor.constraint(equalToConstant: Constants.regularLabelHeight),
            
            telegramImageView.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: Constants.offsetM),
            telegramImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offsetS),
            telegramImageView.widthAnchor.constraint(equalToConstant: Constants.regularTextFieldHeight),
            telegramImageView.heightAnchor.constraint(equalToConstant: Constants.regularTextFieldHeight),
            
            loginCodeTextfield.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: Constants.offsetM),
            loginCodeTextfield.leadingAnchor.constraint(equalTo: telegramImageView.trailingAnchor, constant: Constants.offsetS),
            loginCodeTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offsetS),
            loginCodeTextfield.heightAnchor.constraint(equalToConstant: Constants.regularTextFieldHeight),
            
            sendButton.topAnchor.constraint(equalTo: loginCodeTextfield.bottomAnchor, constant: Constants.offsetM),
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
        if let code = loginCodeTextfield.text, !code.isEmpty {
            viewmodel.confirmPhoneNumber(with: code)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginCodeTextfield.endEditing(true)
    }
}
