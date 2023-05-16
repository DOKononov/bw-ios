
import UIKit

class SubscriptionsVC: UIViewController  {
 
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
    // TextFields
    private let userFirstLastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "FirstName and LastName"
        textField.isEnabled = true
        textField.backgroundColor = .lightGray
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let userNameTextField: UITextField = {
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
        let stackView = UIStackView(arrangedSubviews: [userFirstLastNameTextField, userNameTextField, userIdTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // #1
        view.backgroundColor = .white
        // #2
        addSubview()
        // #3
        addTargets()
        // #4
        view.addTapGestureToHideKeyboard()
        // #5
        constraints()
    }
}

private extension SubscriptionsVC {
    
    func addSubview() {
        view.addSubview(stackViewTextFields)
        view.addSubview(stackViewButtons)
    }
    
    func addTargets() {
        subscriptionsButton.addTarget(self, action: #selector(openUsersListVC(sender: )), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(openUsersListVC(sender: )), for: .touchUpInside)
        allUsersButton.addTarget(self, action: #selector(openUsersListVC(sender: )), for: .touchUpInside)
    }
}
           
private extension SubscriptionsVC {
    func constraints() {
        NSLayoutConstraint.activate([
            //
            stackViewButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.offset16),
            stackViewButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //
            stackViewTextFields.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackViewTextFields.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            stackViewTextFields.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset16),
        ])
    }
}


   


