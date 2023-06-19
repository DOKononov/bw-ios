
import UIKit

final class DeckVC: UIViewController {
    //
    var delegate: MovingPlayerViewProtocol?

    
    // MARK: - Propertys
    
    private let viewModel: DeckVMProtocol
    
    // MARK: - Labels
    private let nameLabel: UniversalLabel = {
        let label = UniversalLabel(text: "Arlene Mc Coy", textColor: .bwPrimaryGray800, font: .bwInterSemiBold18 ?? UIFont.systemFont(ofSize: Constants.size18), textAlign: .center)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View
    var audioPlayerView: AudioPlayerView
    

    // MARK: - Buttons
    private lazy var customRightButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(customView: followingButton)
        button.width = Constants.width98
        return button
    }()
    
    private let followingButton: PrimaryButton = {
        let button = PrimaryButton(text: "Following", fillColor: .bwPrimaryGray100, tintColor: .bwPrimarySkyBlue600, borderColor: .clear, font: .bwInterSemiBold12 ?? UIFont.systemFont(ofSize: Constants.size12), cornerRadius: Constants.cornerRadius10)
        button.isHidden = true // Always hidden

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
    private lazy var deckTableView: UITableView = {

        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DeckTableViewCell.self, forCellReuseIdentifier: "\(DeckTableViewCell.self)")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = Constants.cornerRadius14
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.addShadow(color: UIColor(red: 0.29, green: 0.33, blue: 0.41, alpha: 0.1), offset: (width: 0.0, height: 4.0), radius: 10.0, opacity: 1.0, alpha: 0.1, true)
        return tableView
    }()
    
    init(viewModel: DeckVMProtocol,
         audioPlayerView: AudioPlayerView) {
        self.viewModel = viewModel
        self.audioPlayerView = audioPlayerView

        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = DeckVM()
        self.audioPlayerView = AudioPlayerView(isAvatarTapAvailability: false)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .bwPrimaryGray600
        view.backgroundColor = .bwPrimaryGray50

        deckTableView.dataSource = self
        deckTableView.delegate = self
        addSubview()
        constraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayerView.isAvatarTapAvailability = true
        delegate?.moving(audioPlayerView: audioPlayerView)
    }

}

// MARK: Add subview
extension DeckVC {
    
    func addSubview() {
        navigationItem.setRightBarButton(customRightButtonItem, animated: true)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(audioPlayerView)

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
            
            audioPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            audioPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            audioPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            audioPlayerView.heightAnchor.constraint(equalToConstant: Constants.height110),
            
            deckTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.offset16),
            deckTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.offset16),
            deckTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.offset16),
            deckTableView.bottomAnchor.constraint(equalTo: audioPlayerView.topAnchor, constant: -Constants.offset7),

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
        // 1
        let section = viewModel.dairysArray[indexPath.section]
        let timestampDescription = section.timestams[indexPath.row].description
      
        audioPlayerView.text = timestampDescription
        audioPlayerView.userPicture = avatarImageView.image ?? UIImage()

    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionObject = viewModel.dairysArray[section]
        let headerView = DeckHeaderView()
        headerView.fillingHeader(model: sectionObject)
        return headerView
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
