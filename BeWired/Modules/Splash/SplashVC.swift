
import UIKit

final class SplashVC: UIViewController {
    
    private var viewmodel: SplashVMProtocol
    // MARK: - Labels
    private let beWiredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Be Wired"
        label.textColor = .bwPrimaryGray800
        label.font = .bwInterBold48
        return label
    }()
    
    // MARK: - Image View
    private let telegramLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: String.AssetsNames.telegramLogo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let logoWithoutBorder: UIImageView = {
        let imageView = UIImageView(image: UIImage.SplashVC.logoWithoutBorder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let logoWithShadow: UIImageView = {
        let imageView = UIImageView(image: UIImage.SplashVC.logoWithShadow)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = Constants.offset0
        return imageView
    }()
    
    private let womanWithPhone: UIImageView = {
        let imageView = UIImageView(image: UIImage.SplashVC.womanWithPhone?.withRenderingMode(.alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var clearLayerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.SplashVC.elipse?.withRenderingMode(.alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = Constants.value0
        return imageView
    }()
    
    // MARK: Buttons
    private var telegramLoginButton: UIButton = {
        // Settings
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login via Telegram", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bwInterSemiBold16
        button.backgroundColor = .bwPrimaryGray800
        button.layer.cornerRadius = Constants.offset25
        button.setImage(UIImage.SplashVC.tgLogo?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        // Constraints for buttons subviews
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: Constants.offset20).isActive = true
        button.imageView?.widthAnchor.constraint(equalToConstant: Constants.width24).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: Constants.height24).isActive = true
        button.titleLabel?.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: Constants.offset54).isActive = true
        button.titleLabel?.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -Constants.offset16).isActive = true
        
        // Shadow
        button.addShadow(color: .bwPrimarySkyBlue600, offset: (width: 0.00, height: 4.00), radius: Constants.cornerRadius8, opacity: 1.0, alpha: 1.0, false)
        // Alpha
        button.alpha = Constants.value0
        return button
    }()
    
    init(viewmodel: SplashVMProtocol ) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addView()
        addActions()
        constraints()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    private func bind() {
        viewmodel.openFeedVC = { [weak self] in
            guard let self else {return}
            
            DispatchQueue.main.async {
                let feedVC = FeedVC(viewmodel: FeedVM(authService: self.viewmodel.auth))
                self.navigationController?.pushViewController(feedVC, animated: true)
            }
        }
    }
    
    // Add view
    private func addView() {
        view.addSubview(logoWithoutBorder)
        view.addSubview(logoWithShadow)
        view.addSubview(beWiredLabel)
        view.addSubview(womanWithPhone)
        view.addSubview(telegramLoginButton)
        womanWithPhone.addSubview(clearLayerImageView)
    }
}

// MARK: Actions
private extension SplashVC {
    
    func addActions() {
        telegramLoginButton.addTarget(self, action: #selector(openLoginVC), for: .touchUpInside)
    }
    
    @objc func openLoginVC() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let nextVC = LoginVC(viewmodel: LoginViewModel(self.viewmodel.auth))
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
}

// MARK: Animate
private extension SplashVC {
    
    func animate() {
        // Update constraints before animations
        view.layoutIfNeeded()
        
        // Animate logo, button, human
        UIView.animate(withDuration: 2.00,
                       delay: 1.00,
                       options: .curveEaseInOut,
                       animations: { [ weak self ] in
            // 1
            guard let self else {
                return
            }
            
            // 2 Constraints
            self.telegramLoginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.clearLayerImageView.frame.height * Constants.percentage19).isActive = true
            
            // 3 isVisible
            self.telegramLoginButton.alpha = Constants.value1
            self.clearLayerImageView.alpha = Constants.value1
            
            // 4 Logo constraints and isVisible
            self.logoWithoutBorder.bottomAnchor.constraint(equalTo: self.womanWithPhone.topAnchor, constant: -Constants.offset84).isActive = true
            self.logoWithShadow.bottomAnchor.constraint(equalTo: self.womanWithPhone.topAnchor, constant: -Constants.offset84).isActive = true
            self.logoWithShadow.alpha = Constants.value1
            
            // 5 update layout
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        // Be Wired label animate
        UIView.animate(withDuration: 1.50,
                       delay: 1.50,
                       options: .curveEaseInOut,
                       animations: { [ weak self ] in
            
            // 1
            guard let self else {
                return
            }
            
            // 2 Transform
            self.beWiredLabel.transform = CGAffineTransform(
                scaleX: Constants.width142 / self.beWiredLabel.bounds.width,
                y: Constants.height32 / self.beWiredLabel.bounds.height)
            
            // 3 Constraints
            self.beWiredLabel.bottomAnchor.constraint(equalTo: self.womanWithPhone.topAnchor, constant: -Constants.offset64).isActive = true
            self.beWiredLabel.centerXAnchor.constraint(equalTo: self.logoWithoutBorder.centerXAnchor).isActive = true
            self.logoWithoutBorder.alpha = Constants.value0
            // 3 Update layout
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: Constraints
private extension SplashVC {
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            logoWithoutBorder.bottomAnchor.constraint(equalTo: womanWithPhone.topAnchor),
            logoWithoutBorder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoWithoutBorder.widthAnchor.constraint(equalToConstant: Constants.width129),
            logoWithoutBorder.heightAnchor.constraint(equalToConstant: Constants.height129),
            
            logoWithShadow.bottomAnchor.constraint(equalTo: womanWithPhone.topAnchor),
            logoWithShadow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoWithShadow.widthAnchor.constraint(equalToConstant: Constants.width129),
            logoWithShadow.heightAnchor.constraint(equalToConstant: Constants.height129),
            
            beWiredLabel.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * Constants.percentage51),
            beWiredLabel.heightAnchor.constraint(equalToConstant: Constants.height48),
            
            beWiredLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (-womanWithPhone.frame.height * Constants.percentage15)),
            
            womanWithPhone.topAnchor.constraint(equalTo: view.centerYAnchor),
            womanWithPhone.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            womanWithPhone.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            womanWithPhone.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            clearLayerImageView.topAnchor.constraint(equalTo: womanWithPhone.topAnchor),
            clearLayerImageView.leadingAnchor.constraint(equalTo: womanWithPhone.leadingAnchor),
            clearLayerImageView.trailingAnchor.constraint(equalTo: womanWithPhone.trailingAnchor),
            clearLayerImageView.bottomAnchor.constraint(equalTo: womanWithPhone.bottomAnchor),
            
            telegramLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.offset16),
            telegramLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            telegramLoginButton.widthAnchor.constraint(equalToConstant: Constants.width220),
            telegramLoginButton.heightAnchor.constraint(equalToConstant: Constants.height52)
        ])
    }
}



