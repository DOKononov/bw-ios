//
//  WelcomeVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.05.23.
//

import UIKit

final class WelcomeVC: UIViewController {
    
    private var viewmodel: WelcomeViewModelProtocol
    
    init(viewmodel: WelcomeViewModelProtocol) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "tg")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.font = UIFont.systemFont(ofSize: Constants.size25, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let userDataLabel: UILabel = {
        let label = UILabel()
        label.text = "???user data???"
        label.contentMode = .top
        label.font = UIFont.systemFont(ofSize: Constants.size18, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        bind()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    
    private func initialize() {
        addSubviews()
        addTargets()
        hideUI()
    }
    
    private func bind() {
        viewmodel.userDidChanged = { [weak self] user in
            DispatchQueue.main.async {
                self?.showUserData(user)
                self?.showUI()
            }
        }
        
        viewmodel.didLogedout = { [weak self] in
            DispatchQueue.main.async {
                let loginVC = LoginVC(viewmodel: LoginViewModel())
                guard let navigationController = self?.navigationController else { return }
                
                UIView.transition(with: navigationController.view,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    navigationController.setViewControllers([loginVC], animated: false)
                }, completion: nil)
            }
        }
        
        viewmodel.didReciveError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.userDataLabel.text = errorMessage
            }
            
        }
    }
    
    private func hideUI() {
        welcomeLabel.isHidden = true
        userImageView.isHidden = true
        userDataLabel.isHidden = true
        logoutButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showUI() {
        welcomeLabel.isHidden = false
        userImageView.isHidden = false
        userDataLabel.isHidden = false
        logoutButton.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showUserData(_ user: User) {
        welcomeLabel.text = "Welcome, \(user.firstName) \(user.lastName)!"
        userDataLabel.text = "user id: \(user.id) \n user phone number: \(user.phoneNumber)"
        
        if let data = user.profilePhotoData, let image = UIImage(data: data) {
            userImageView.image = image
        } else {
            userImageView.image = UIImage(systemName: "photo")
        }
    }
    
    
    private func addSubviews() {
        view.addSubview(welcomeLabel)
        view.addSubview(logoutButton)
        view.addSubview(userImageView)
        view.addSubview(userDataLabel)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.offset8),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: Constants.height150),
            userImageView.heightAnchor.constraint(equalToConstant: Constants.height150),
            
            welcomeLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: Constants.offset16),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            welcomeLabel.heightAnchor.constraint(equalToConstant: Constants.height50),
            
            userDataLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Constants.offset8),
            userDataLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            userDataLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            userDataLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.height50),
            
            logoutButton.topAnchor.constraint(greaterThanOrEqualTo: userDataLabel.bottomAnchor, constant: Constants.offset8),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: Constants.width160),
            logoutButton.heightAnchor.constraint(equalToConstant: Constants.height40),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.offset8),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        logoutButton.makeRounded(.rectangel)
        userImageView.makeRounded(.circle)
    }
    
    private func addTargets() {
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonDidTapped() {
        viewmodel.logout()
    }
}
