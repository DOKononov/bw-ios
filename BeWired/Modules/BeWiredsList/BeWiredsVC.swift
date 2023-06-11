//
//  BeWiredsListVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import UIKit

final class BeWiredsVC: UIViewController {
    
    private var viewmodel: BeWiredsVMProtocol
    
    private let beWiredsTitle: UILabel = {
        let label = UILabel()
        label.text = "BeWireds:"
        label.font = UIFont.systemFont(ofSize: Constants.size25, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let beWiredsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .secondarySystemBackground
        table.register(BeWiredCell.self, forCellReuseIdentifier: "\(BeWiredCell.self)")
        table.makeRounded(10)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Descriprion:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Constants.size15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionScrollView: UIScrollView = {
       let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .secondarySystemBackground
        view.makeRounded(10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.textColor = .red
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Constants.size15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pullButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pull", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: BeWiredsVMProtocol) {
        self.viewmodel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        beWiredsTableView.delegate = self
        beWiredsTableView.dataSource = self
        scrollLabel.text = viewmodel.beWireds.first?.lastPathComponent
        view.backgroundColor = .systemBackground
    }
    
    private func initialize() {
        addSubviews()
        setupLayouts()
        addTargets()
        bind()
    }
    
    private func addSubviews() {
        view.addSubview(beWiredsTitle)
        view.addSubview(beWiredsTableView)
        view.addSubview(descriptionTitle)
        view.addSubview(descriptionScrollView)
        descriptionScrollView.addSubview(scrollLabel)
        view.addSubview(statusLabel)
        view.addSubview(pullButton)
        view.addSubview(playButton)
    }
    
    private func bind() { 
        viewmodel.beWiredsDidUpadete = { [weak self] in
            DispatchQueue.main.async {
                self?.beWiredsTableView.reloadData()
                if let beWiredsIsEmpty = self?.viewmodel.beWireds.isEmpty, !beWiredsIsEmpty {
                    self?.beWiredsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
        
        viewmodel.didReciveError = { [weak self] errorMessage in
            guard let self else {return}
            DispatchQueue.main.async {
                self.showErrorAlert(for: errorMessage)
            }
        }
        
        viewmodel.pullStatusDidUpdate = { [weak self] in
            self?.updateStatusLabel()
        }
        
        viewmodel.playDidChangedStatus = { [weak self] inProgress in
            DispatchQueue.main.async {
                inProgress ?
                self?.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal) :
                self?.playButton.setImage(UIImage(systemName: "play"), for: .normal)
            }
        }
    }
    
    private func addTargets() {
        pullButton.addTarget(self, action: #selector(pullButtonDidPressed), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func pullButtonDidPressed() {
        viewmodel.pullDidPressed()
    }
    
    @objc private func playButtonDidTapped() {
        viewmodel.playDidTapped()
    }
    
    private func updateStatusLabel() {
        DispatchQueue.main.async { [weak self] in
            switch self?.viewmodel.pullStatus {
            case .done(let count):
                self?.pullButton.isEnabled = true
                self?.showStatusLabel()
                self?.statusLabel.text = "\(count) new BeWired for you"
                self?.hideStatusLabel()
            case .empty:
                self?.pullButton.isEnabled = true
                self?.statusLabel.text = "No updates 🥺"
                self?.hideStatusLabel()
            case .inprogress:
                self?.pullButton.isEnabled = false
                self?.showStatusLabel()
                self?.statusLabel.text = "Preparing audios for you 🤗..."
            case .none:
                break
            }
        }
    }
    
    private func showStatusLabel() {
        UIView.animate(withDuration: 0.3) {
            self.statusLabel.alpha = 1
        }
    }
    
    private func hideStatusLabel() {
        UIView.animate(withDuration: 1, delay: 3) {
            self.statusLabel.alpha = 0
        }
    }
    
    
    
}

//MARK: -TableView
extension BeWiredsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.beWireds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(BeWiredCell.self)", for: indexPath) as? BeWiredCell
        let beWired = viewmodel.beWireds[indexPath.row]
        cell?.configure(with: beWired)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.height55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scrollLabel.text = viewmodel.beWireds[indexPath.row].lastPathComponent
        descriptionScrollView.contentOffset = .zero
        viewmodel.selectedRecordUrl = viewmodel.beWireds[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recordToDeleteUrl = viewmodel.beWireds[indexPath.row]
            viewmodel.deleteRecord(at: recordToDeleteUrl)
        }
    }
    
}

//MARK: -SetupLayouts
extension BeWiredsVC {
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            
            beWiredsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.offset8),
            beWiredsTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            beWiredsTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            beWiredsTitle.heightAnchor.constraint(equalToConstant: Constants.height30),
            
            beWiredsTableView.topAnchor.constraint(equalTo: beWiredsTitle.bottomAnchor),
            beWiredsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            beWiredsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            beWiredsTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: view.safeAreaLayoutGuide.layoutFrame.height*0.5),
            
            descriptionTitle.topAnchor.constraint(equalTo: beWiredsTableView.bottomAnchor, constant: Constants.offset8),
            descriptionTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            descriptionTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            descriptionTitle.heightAnchor.constraint(equalToConstant: Constants.height30),
            
            descriptionScrollView.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor),
            descriptionScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            descriptionScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            descriptionScrollView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height*0.2),
            
            scrollLabel.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor, constant: Constants.offset8),
            scrollLabel.leadingAnchor.constraint(equalTo: descriptionScrollView.leadingAnchor, constant: Constants.offset8),
            scrollLabel.trailingAnchor.constraint(equalTo: descriptionScrollView.trailingAnchor, constant: -Constants.offset8),
            scrollLabel.widthAnchor.constraint(equalTo: descriptionScrollView.widthAnchor, constant: -Constants.offset16),
            scrollLabel.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor, constant: -Constants.offset8),
            
            statusLabel.topAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor, constant: Constants.offset8),
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            statusLabel.heightAnchor.constraint(equalToConstant: Constants.height20),
            
            pullButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: Constants.offset8),
            pullButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            pullButton.heightAnchor.constraint(equalToConstant: Constants.height40),
            pullButton.widthAnchor.constraint(equalToConstant: Constants.width160),
            pullButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.offset16),
            
            playButton.centerYAnchor.constraint(equalTo: pullButton.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            playButton.heightAnchor.constraint(equalToConstant: Constants.height50),
            playButton.widthAnchor.constraint(equalToConstant: Constants.height50)
            
        ])
        pullButton.makeRounded(.rectangel)
        playButton.makeRounded(.circle)
    }
}
