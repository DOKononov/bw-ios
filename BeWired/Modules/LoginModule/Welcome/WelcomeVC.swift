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
    
    // MARK: Sergey code
       // Buttons
       private let subscriptionsButton: UIButton = {
           let configuartion = UIButton.Configuration.filled()
           let button = UIButton(configuration: configuartion)
           button.setTitle("My subscriptions", for: .normal)
           return button
       }()
       private let followersButton: UIButton = {
           let configuartion = UIButton.Configuration.filled()
           let button = UIButton(configuration: configuartion)
           button.setTitle("My followers", for: .normal)
           return button
       }()
       private let allUsersButton: UIButton = {
           let configuartion = UIButton.Configuration.filled()
           let button = UIButton(configuration: configuartion)
           button.setTitle("All users", for: .normal)
           return button
       }()
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
       // TextFields
       private let userNameTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "FirstName and LastName"
           textField.isEnabled = true
           textField.backgroundColor = .lightGray
           textField.borderStyle = .roundedRect
           return textField
       }()
       private let mobileNumberTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "UserName"
           textField.isEnabled = true
           textField.backgroundColor = .lightGray
           textField.borderStyle = .roundedRect
           return textField
       }()
       
       private let userIdTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "UserId"
           textField.isEnabled = true
           textField.backgroundColor = .lightGray
           textField.borderStyle = .roundedRect
           textField.keyboardType = .decimalPad
           return textField
       }()
       
       // MARK: - StackViews
       private lazy var stackViewTextFields: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [userNameTextField, mobileNumberTextField, userIdTextField])
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .vertical
           stackView.spacing = 16
           stackView.distribution = .fillProportionally
           return stackView
       }()
       
       private lazy var stackViewButtons: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [ subscriptionsButton, followersButton, allUsersButton ])
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .horizontal
           stackView.distribution = .fillEqually
           stackView.spacing = 4
           return stackView
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
        view.addTapGestureToHideKeyboard()
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
                let loginVC = LoginVC(viewmodel: LoginViewModel(auth: AuthService()))
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
                self?.userNameTextField.text = errorMessage
                self?.mobileNumberTextField.text = errorMessage
                self?.userIdTextField.text = errorMessage
            }
        }
    }
    
    private func hideUI() {
        welcomeLabel.isHidden = true
        userImageView.isHidden = true
        stackViewTextFields.isHidden = true
        stackViewButtons.isHidden = true
        logoutButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showUI() {
        welcomeLabel.isHidden = false
        userImageView.isHidden = false
        stackViewTextFields.isHidden = false
        stackViewButtons.isHidden = false
        logoutButton.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showUserData(_ user: User) {

        welcomeLabel.text = "Welcome"
        userNameTextField.text = "\(user.firstName) \(user.lastName)"
            userIdTextField.text = "\(user.id)"
            mobileNumberTextField.text = "+\(user.phoneNumber)"
        
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
        view.addSubview(stackViewTextFields)
        view.addSubview(stackViewButtons)
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
            
            stackViewTextFields.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Constants.offset8),
            stackViewTextFields.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            stackViewTextFields.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset16),
            //
            stackViewButtons.topAnchor.constraint(equalTo: stackViewTextFields.bottomAnchor, constant: Constants.offset8),
            stackViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            stackViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset16),
            
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
        subscriptionsButton.addTarget(self, action: #selector(openUsersListVC(sender: )), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(openUsersListVC(sender: )), for: .touchUpInside)
        allUsersButton.addTarget(self, action: #selector(openUsersListVC(sender: )), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonDidTapped() {
        viewmodel.logout()
    }
}

// MARK: Migration views from SubscriptionsVc
extension WelcomeVC {
    // Open Users List action
    @objc func openUsersListVC(sender: UIButton) {
        
        // #1 Create next vc
        let nextVc = UsersListVC(usersListVM: UsersListVM(getSubscriptionService: SubscriptionsService()))
        
        // #2 Guard userID field
        guard let userId = userIdTextField.text,
              userIdTextField.text != "" else {
            return
        }
        nextVc.userId = Int64(userId)
        
        // #3 Switch sender for understanding URLRequest
        switch sender {
        case subscriptionsButton:
            nextVc.title = String.SubscriptionListType.subscriptions
        case followersButton:
            nextVc.title = String.SubscriptionListType.followers
        case allUsersButton:
            nextVc.title = String.SubscriptionListType.allUsers
        default: break
        }
        // Push VC
        navigationController?.pushViewController(nextVc, animated: true)
    }
}


