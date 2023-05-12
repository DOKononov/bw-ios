//
//  LoginVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 6.05.23.
//

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
    
    private let welcomLabel: UILabel = {
        let label = UILabel()
        label.text = "Please login first"
        label.font = UIFont.systemFont(ofSize: Constants.size25, weight: .thin)
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
                let nextVC = ConfirmationVC(viewmodel: ConfirmationViewModel())
                self?.navigationController?.pushViewController(nextVC, animated: true)
            }

        }
        viewmodel.didReciveError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.welcomLabel.text = errorMessage
                self?.welcomLabel.font = .systemFont(ofSize: Constants.size12)
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
            welcomLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            welcomLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            welcomLabel.heightAnchor.constraint(equalToConstant: Constants.height50),
            
            telegramImageView.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: Constants.offset16),
            telegramImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            telegramImageView.widthAnchor.constraint(equalToConstant: Constants.height50),
            telegramImageView.heightAnchor.constraint(equalToConstant: Constants.height50),
            
            phoneNumberTextfield.topAnchor.constraint(equalTo: welcomLabel.bottomAnchor, constant: Constants.offset16),
            phoneNumberTextfield.leadingAnchor.constraint(equalTo: telegramImageView.trailingAnchor, constant: Constants.offset8),
            phoneNumberTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            phoneNumberTextfield.heightAnchor.constraint(equalToConstant: Constants.height50),
            
            sendButton.topAnchor.constraint(equalTo: phoneNumberTextfield.bottomAnchor, constant: Constants.offset16),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: Constants.width160),
            sendButton.heightAnchor.constraint(equalToConstant: Constants.height40)
            
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
