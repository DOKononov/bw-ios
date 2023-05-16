//
//  BeWiredsListVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import UIKit

final class BeWiredsListVC: UIViewController {
    
    private var viewModel: BeWiredsListProtocol
    
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
    
    init(viewModel: BeWiredsListProtocol) {
        self.viewModel = viewModel
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
        scrollLabel.text = viewModel.beWireds.first?.description
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayouts()

    }
    
    
    private func initialize() {
        addSubviews()
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
        viewModel.beWiredsDidUpadete = { [weak self] in
            DispatchQueue.main.async {
                self?.beWiredsTableView.reloadData()
                self?.beWiredsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        viewModel.pullStatusDidUpdate = { [weak self] in
            self?.updateStatusLabel()
        }
    }
    
    private func addTargets() {
        pullButton.addTarget(self, action: #selector(pullButtonDidPressed), for: .touchUpInside)
    }
    
    @objc private func pullButtonDidPressed() {
        viewModel.pullDidPressed()
    }
    
    private func updateStatusLabel() {
        switch viewModel.pullStatus {
        case .done(let count):
            pullButton.isEnabled = true
            showStatusLabel()
            statusLabel.text = "\(count) new BeWired for you"
            hideStatusLabel()
        case .empty:
            pullButton.isEnabled = true
            statusLabel.text = "No updates 🥺"
            hideStatusLabel()
        case .inprogress:
            pullButton.isEnabled = false
            showStatusLabel()
            statusLabel.text = "Preparing audios for you 🤗..."
        case .none:
            break
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
extension BeWiredsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.beWireds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(BeWiredCell.self)", for: indexPath) as? BeWiredCell
        let beWired = viewModel.beWireds[indexPath.row]
        cell?.configure(with: beWired)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.height55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        scrollLabel.text = viewModel.beWireds[indexPath.row].description
        descriptionScrollView.contentOffset = .zero
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.beWireds.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

//MARK: -SetupLayouts
extension BeWiredsListVC {
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
        descriptionScrollView.makeRounded(10)
        beWiredsTableView.makeRounded(10)

        
    }
}
