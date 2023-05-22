//
//  RecordsVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 20.05.23.
//

import UIKit

final class RecordsVC: UIViewController {
    
    private var viewmodel: RecordsVMProtocol
    
    init(viewmodel: RecordsVMProtocol) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let recordsTableView: UITableView = {
       let table = UITableView()
        table.register(RecordCell.self, forCellReuseIdentifier: "\(RecordCell.self)")
        table.backgroundColor = .secondarySystemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        table.makeRounded(10)
        return table
    }()

    private let recButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "record.circle"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        view.backgroundColor = .systemBackground
        bind()
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
    }
    
    private func bind() {
        viewmodel.didReciveError = {[weak self] errorMessage in
            guard let self else {return}
            self.showErrorAlert(for: errorMessage)
        }
        
        viewmodel.recordsPathDidUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.recordsTableView.reloadData()
            }
        }
        
        viewmodel.recDidChangedStatus = { [weak self] inProgress in
            DispatchQueue.main.async {
                inProgress ?
                self?.recButton.setImage(UIImage(systemName: "stop.fill"), for: .normal) :
                self?.recButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
            }
        }
        viewmodel.playDidChangedStatus = { [weak self] inProgress in
            DispatchQueue.main.async {
                inProgress ?
                self?.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal) :
                self?.playButton.setImage(UIImage(systemName: "play"), for: .normal)
            }
        }
    }

    private func initialize() {
        addSubviews()
        addTargets()
        setupLayout()
    }

    private func addSubviews() {
        view.addSubview(recButton)
        view.addSubview(playButton)
        view.addSubview(recordsTableView)

    }

    private func setupLayout() {

        NSLayoutConstraint.activate([
            recordsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.offset8),
            recordsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            recordsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            recordsTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: view.safeAreaLayoutGuide.layoutFrame.height*0.5),
            
            recButton.topAnchor.constraint(greaterThanOrEqualTo: recordsTableView.bottomAnchor, constant: Constants.offset8),
            recButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset8),
            recButton.heightAnchor.constraint(equalToConstant: Constants.height55),
            recButton.widthAnchor.constraint(equalToConstant: Constants.height55),
            recButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.offset16),
            
            playButton.topAnchor.constraint(greaterThanOrEqualTo: recordsTableView.bottomAnchor, constant: Constants.offset8),
            playButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset8),
            playButton.heightAnchor.constraint(equalToConstant: Constants.height55),
            playButton.widthAnchor.constraint(equalToConstant: Constants.height55),
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.offset16),

        ])
        recButton.makeRounded(.circle)
        playButton.makeRounded(.circle)
    }

    private func addTargets() {
        recButton.addTarget(self, action: #selector(recDidTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playDidTapped), for: .touchUpInside)
    }

    @objc private func recDidTapped() {
        viewmodel.recDidTapped()
    }

    @objc private func playDidTapped() {
        viewmodel.playDidTapped()
    }

}


extension RecordsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.recordsPath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(RecordCell.self)", for: indexPath) as? RecordCell
        cell?.configure(with: viewmodel.recordsPath[indexPath.row])
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewmodel.selectedRecordUrl = viewmodel.recordsPath[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recordToDeleteUrl = viewmodel.recordsPath[indexPath.row]
            viewmodel.deleteRecord(at: recordToDeleteUrl)
        }
    }
}
