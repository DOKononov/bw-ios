//
//  FeedVC.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.06.23.
//

import UIKit

final class FeedVC: UIViewController {
    
    private  var viewmodel: FeedVMProtocol
    
    private let collectionView: UICollectionView = {
        let lay = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: lay)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "\(FeedCell.self)")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString("Refreshing")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        return refreshControl
    }()
    
    let placeholderTopLabel: UILabel = {
        let label = UILabel()
        label.text = "No action here...yet"
        label.font = .bwInterMedium20
        label.textColor = .bwPrimaryGray900
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeholderBottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Time to find someone or pull to update feed"
        label.font = .bwInterMedium14
        label.textAlignment = .center
        label.textColor = .bwPrimaryGray600
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileButton: ProfileButton = {
        let button = ProfileButton(image: UIImage(named: "testImage")!)

        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(profileDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let micView: MicView = {
        let view = MicView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewmodel: FeedVMProtocol) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        setPlaceholder(viewmodel.beWireds.isEmpty)
    }
    
    private func initialize() {
        view.backgroundColor = .bwBackground
        addSubviews()
        setupLayouts()
        bind()
    }
    
    private func bind() {
        viewmodel.beWiredsDidUpadete = { [weak self]  in
            guard let self else {return}

            DispatchQueue.main.async {
                self.setPlaceholder(self.viewmodel.beWireds.isEmpty)
                self.profileButton.badgeText = "\(self.viewmodel.beWireds.count)"
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
        viewmodel.didReciveError = { [weak self] errorMessage in
            guard let self else {return}
            DispatchQueue.main.async {
                self.showErrorAlert(for: errorMessage)
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                }
            }
        }
        
        micView.micButtonDidTapped = { [weak self] in
            //TODO: 
            self?.refresh()
        }
        
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        view.addSubview(placeholderTopLabel)
        view.addSubview(placeholderBottomLabel)
        view.addSubview(micView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.offset16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholderTopLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 178),
            placeholderTopLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderTopLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            placeholderTopLabel.heightAnchor.constraint(equalToConstant: 28),
            
            placeholderBottomLabel.topAnchor.constraint(equalTo: placeholderTopLabel.bottomAnchor, constant: 8),
            placeholderBottomLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderBottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderBottomLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            placeholderBottomLabel.heightAnchor.constraint(equalToConstant: 20),
            
            micView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            micView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            micView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            micView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
        ])
    }
    
    private func setPlaceholder(_ isEmpty: Bool) {
        placeholderTopLabel.isHidden = !isEmpty
        placeholderBottomLabel.isHidden = !isEmpty
    }
    
    @objc private func refresh() {
        viewmodel.pullDidPressed()
    }
    
    @objc private func heartDidTapped() {
        viewmodel.pullDidPressed()
    }
    @objc private func magnifierDidTapped() {
        viewmodel.wipe()
    }
    
    @objc private func profileDidTapped() {
        DispatchQueue.main.async {
            
            
            let mainVC = MainVC(viewmodel: MainViewModel(auth: AuthService()))
            let navi = UINavigationController(rootViewController: mainVC)
            navi.modalPresentationStyle = .fullScreen
            navi.modalTransitionStyle = .crossDissolve
            self.present(navi, animated: true) 
        }
    }
    
}

//MARK: -CollectionVie
extension FeedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.beWireds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FeedCell.self)", for: indexPath) as? FeedCell
        cell?.configue(indexpath: indexPath)
        
        return cell ?? UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    
}

//MARK: -NavigationItem
extension FeedVC {
    
    private func setupNavigationBar() {
        navigationItemTitleView()
        setupRightBurButtons()
        setupLeftBurButtons()
    }
    
    private func navigationItemTitleView() {
        
        let logoView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage.FeedVC.bwLogo
            view.contentMode = .scaleAspectFit
            view.heightAnchor.constraint(equalToConstant: 32).isActive = true
            view.widthAnchor.constraint(equalToConstant: 32).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Be Wired"
            label.font = .bwInterMedium18
            label.textColor = .bwPrimaryGray900
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        let stackView = UIStackView(arrangedSubviews: [logoView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationItem.titleView = stackView
    }
    
   private func setupRightBurButtons() {
        
        let heartButton: UIBarButtonItem = {
            let button = UIButton(type: .custom)
            let image = UIImage.FeedVC.heart

            button.setImage(image?.withTintColor(.bwPrimaryGray600,renderingMode: .alwaysOriginal), for: .normal)
            button.setImage(image?.withTintColor(.bwPrimaryGray300,renderingMode: .alwaysOriginal), for: .highlighted)

            button.addTarget(self, action: #selector(heartDidTapped), for: .touchUpInside)
            
            button.heightAnchor.constraint(equalToConstant: 16.5).isActive = true
            button.widthAnchor.constraint(equalToConstant: 18.75).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let barButton = UIBarButtonItem(customView: button)
            return barButton
        }()
        
        let spacer: UIBarButtonItem = {
            let view = UIView()
            view.backgroundColor = .clear
            view.widthAnchor.constraint(equalToConstant: 29.25).isActive = true
            view.heightAnchor.constraint(equalToConstant: 18).isActive = true
            let spacer = UIBarButtonItem(customView: view)
            return spacer
        }()
        
        let magnifierButton: UIBarButtonItem = {
            let button = UIButton(type: .custom)
            let image = UIImage.FeedVC.magnifier

            button.setImage(image?.withTintColor(.bwPrimaryGray600,renderingMode: .alwaysOriginal), for: .normal)
            button.setImage(image?.withTintColor(.bwPrimaryGray300,renderingMode: .alwaysOriginal), for: .highlighted)

            button.addTarget(self, action: #selector(magnifierDidTapped), for: .touchUpInside)
            
            button.heightAnchor.constraint(equalToConstant: 18).isActive = true
            button.widthAnchor.constraint(equalToConstant: 18).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let barButton = UIBarButtonItem(customView: button)
            return barButton
        }()
        
        navigationItem.rightBarButtonItems = [magnifierButton, spacer, heartButton]
    }
    
    private func setupLeftBurButtons() {
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: profileButton)]
    }
    
}

