
import UIKit

final class ProfileVC: UIViewController {
    private var viewmodel: ProfileVMProtocol
    private let navigationTitle = "Profile"
    
    private let profileView: ProfileView = {
        let view = ProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TimeStampCell.self, forCellReuseIdentifier: "\(TimeStampCell.self)")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = Constants.cornerRadius14
        tableView.addShadow(color: UIColor(red: 0.29, green: 0.333, blue: 0.408, alpha: 0.1),
                            offset: (width: 0, height: 4),
                            radius: 14,
                            opacity: 1,
                            alpha: 0.1, true)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bwBackground
        setupNavigationBar()
        addSubviews()
        setupLayouts()
        
        bind()
        addTargets()
        tableView.delegate = self
        tableView.dataSource = self
        setupUser()
        
    }
    
    @objc private func ping(sender: ProfileViewButton) {
        sender.count += 1
        sender.indicatorIsHiden = !sender.indicatorIsHiden
        //        switch sender.buttonTitle {
        //        case .followers:
        //        case .following:
        //        case .entries:
        //        }
    }
    
    init(viewmodel: ProfileVMProtocol) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
    }
    
    private func setupUser() {
        if let user = viewmodel.user {
            profileView.userName = user.firstName + " " + user.lastName
            profileView.nickName = "@\(user.id)"
            if let data = user.profilePhotoData {
                profileView.userImage = UIImage(data: data)
            }
        }
    }
    
    
    private func addSubviews() {
        view.addSubview(profileView)
        view.addSubview(tableView)
        
    }
    
    private func setupLayouts() {
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileView.heightAnchor.constraint(equalTo: profileView.widthAnchor, multiplier: 0.5452), //187
            
            tableView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    private func addTargets() {
        profileView.followersButton.addTarget(self, action: #selector(ping(sender:)), for: .touchUpInside)
        profileView.followingButton.addTarget(self, action: #selector(ping(sender:)), for: .touchUpInside)
        profileView.entriesButton.addTarget(self, action: #selector(ping(sender:)), for: .touchUpInside)
    }
    
}

//MARK: -tableView
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewmodel.dairysArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diary = viewmodel.dairysArray[section]
        return diary.timestams.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diary = viewmodel.dairysArray[indexPath.section]
        let timeStamp = diary.timestams[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TimeStampCell.self)", for: indexPath) as? TimeStampCell
        cell?.setCell(model: timeStamp)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let diary = viewmodel.dairysArray[section]
        let headerView = DiaryHeader()
        headerView.config(with: diary)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRowIndex {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.layer.cornerRadius = 10
        }
        
    }
    
    
}

//MARK: - SetupNavigation
extension ProfileVC {
    private func setupNavigationBar() {
        navigationItemTitleView()
        setupRightBurButtons()
        setupLeftBurButtons()
    }
    
    private func navigationItemTitleView() {
        let titleLabel = UILabel()
        titleLabel.textColor = .bwPrimaryGray900
        titleLabel.font = .bwInterMedium16
        titleLabel.text = "Profile"
        navigationItem.titleView = titleLabel
    }
    
    private func setupRightBurButtons() {
        let gearButton = UIButton()
        gearButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        gearButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        let image = UIImage.Profile.gear
        gearButton.setImage(image?.withTintColor(.bwPrimaryGray600, renderingMode: .alwaysOriginal), for: .normal)
        gearButton.setImage(image?.withTintColor(.bwPrimaryGray400, renderingMode: .alwaysOriginal), for: .highlighted)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: gearButton)
    }
    
    private func setupLeftBurButtons() {
        let button = UIButton()
        button.setTitle(" Feed", for: .normal)
        button.setTitleColor(.bwPrimaryGray600, for: .normal)
        button.setTitleColor(.bwPrimaryGray400, for: .highlighted)
        button.addTarget(self, action: #selector(backDidTapped), for: .touchUpInside)
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image?.withTintColor(.bwPrimaryGray600, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(image?.withTintColor(.bwPrimaryGray400, renderingMode: .alwaysOriginal), for: .highlighted)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func backDidTapped() {
        navigationController?.popViewController(animated: true)
    }
}
