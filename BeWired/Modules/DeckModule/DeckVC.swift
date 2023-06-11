
import UIKit

final class DeckVC: UIViewController {
    
    // MARK: - Propertys
    
    private let viewModel: DeckVMProtocol
    
    // MARK: - Labels
    private let nameLabel: UniversalLabel = {
        let label = UniversalLabel(text: "Arlene Mc Coy", textColor: .primaryGray800, font: .interSemiBold18() ?? UIFont.systemFont(ofSize: Constants.size18), textAlign: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Buttons
    private lazy var customRightButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(customView: followingButton)
        button.width = Constants.width98
        return button
    }()
    
    private let followingButton: PrimaryButton = {
        let button = PrimaryButton(text: "Following", fillColor: .primaryGray100, tintColor: .primarySkyBlue600, borderColor: .clear, font: .interSemiBold12() ?? UIFont.systemFont(ofSize: Constants.size12), cornerRadius: Constants.cornerRadius10)
        return button
    }()
    
    // MARK: - ImageView
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "TestUserProfile")
        imageView.layer.cornerRadius = Constants.cornerRadius10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - TableView
    private let deckTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DeckTableViewCell.self, forCellReuseIdentifier: "\(DeckTableViewCell.self)")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = Constants.cornerRadius14
        tableView.backgroundColor = .primaryGray225
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    init(viewModel: DeckVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = DeckVM()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryGray225
        deckTableView.dataSource = self
        deckTableView.delegate = self
        addSubview()
        constraints()
    }
}

// MARK: Add subview
extension DeckVC {
    
    func addSubview() {
        navigationItem.setRightBarButton(customRightButtonItem, animated: true)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(deckTableView)
    }
}

// MARK: Constraints
extension DeckVC {
    
    func constraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: Constants.offset12),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.width240),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.height240),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.offset16),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            
            deckTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.offset16),
            deckTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            deckTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset16),
            deckTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TableView delegate
extension DeckVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.dairysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionObject = viewModel.dairysArray[section]
        return sectionObject.timestams.count
    }
    
    // Set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1
        let section = viewModel.dairysArray[indexPath.section]
        let cellIndex = section.timestams[indexPath.row]
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DeckTableViewCell.self)", for: indexPath) as? DeckTableViewCell
        cell?.setCell(model: cellIndex)
       // 3
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionObject = viewModel.dairysArray[section]
        let headerView = DeckHeaderView()
        headerView.fillingHeader(model: sectionObject)
        return headerView
    }
    
    // Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
   
    // Cell corner radius
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 1
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        // 2
        if indexPath.row == lastRowIndex {
            let cornerRadius: CGFloat = Constants.cornerRadius10
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            cell.layer.mask = maskLayer
            // 3
        } else {
            cell.layer.mask = nil
        }
    }
}
