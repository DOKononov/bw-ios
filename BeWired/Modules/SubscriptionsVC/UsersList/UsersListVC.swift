import UIKit

final class UsersListVC: UIViewController {
    
    // MARK: - Internal properties
    var userId: Int64?
    
    // MARK: - Private properties
    private var usersListVM: UsersListVmProtocol

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UsersListTableViewCell.self,
                forCellReuseIdentifier: UsersListTableViewCell.reusedId)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Init
    init(usersListVM: UsersListVmProtocol) {
        self.usersListVM = usersListVM
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.usersListVM = UsersListVM(getSubscriptionService: SubscriptionsService())
        super.init(coder: coder)
    }
    
    // MARK: - System methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        view.backgroundColor = .white
        // 2
        addSubview()
        // 3
        constraints()
        // 4
        usersListVM.getSubscriptions(userId: userId ?? 0, screenTitle: title ?? "")
        // 5
        usersListVM.update = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // Stop URL Request
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        usersListVM.cancelUrlDataTask()
    }
}
// MARK: - Custom funcs
private extension UsersListVC {
    
    func addSubview() {
        view.addSubview(tableView)

    }
}

// MARK: - Constraints
private extension UsersListVC {
    func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension UsersListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersListVM.usersListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UsersListTableViewCell.self)", for: indexPath) as? UsersListTableViewCell
        cell?.setUserListCell(model: usersListVM.usersListArray[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        // #1
        guard let userId = userId,
              let title = title,
              title == String.SubscriptionListType.allUsers else {
            return
        }
        // #2
        usersListVM.updateSubscriptions(userId: userId,
                                        indexPath: indexPath.row,
                                        screenTitle: title)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        title == String.SubscriptionListType.allUsers ? false : true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // #1
        guard editingStyle == .delete,
              let userId = userId,
              let title = title else {
            return
        }
            // #2
        usersListVM.updateSubscriptions(userId: userId, indexPath: indexPath.row, screenTitle: title)
            // #3
        tableView.deleteRows(at: [indexPath], with: .top)
    }
}
