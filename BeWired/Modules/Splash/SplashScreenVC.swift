
import UIKit

final class SplashScreenVC: UIViewController {
    
    private let authService: AuthServiceProtocol
    
    // MARK: - Labels
    private var beWiredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Be Wired"
        label.textColor = .primaryGray800
        label.font = .interBold48()
        return label
    }()
    
    // MARK: - Image View
    private let telegramLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: String.AssetsNames.telegramLogo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var beWiredLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: String.AssetsNames.beWiredLogo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = Constants.value0
        return imageView
    }()
    
    private var humanSilhouetteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: String.AssetsNames.womanTalkingMobile)?.withTintColor(.primaryGray100, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var humanSilhouetteImageViewBlue: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: String.AssetsNames.womanTalkingMobile)?.withTintColor(.primarySkyBlue600, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.addGradientLayer(color: .primarySkyBlue400, framePoints: CGPoint(x: Constants.offset0, y: imageView.frame.midY), frameSize: CGSize(width: UIScreen.main.bounds.width, height: imageView.frame.height), originalAlpha: 0.8, layerLocations: [0.0, 1.0], gradientStartPoint: CGPoint(x: 0.5, y: 1), gradientEndPoint: CGPoint(x: 0.5, y: 0), layerLevel: 0)
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
        button.titleLabel?.font = .interSemiBold16()
        button.backgroundColor = .primaryGray800
        button.layer.cornerRadius = Constants.offset25
        button.setImage(UIImage(named: String.AssetsNames.telegramLogo)?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        // Constraints for buttons subviews
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: Constants.offset20).isActive = true
        button.imageView?.widthAnchor.constraint(equalToConstant: Constants.width24).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: Constants.height24).isActive = true
        button.titleLabel?.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: Constants.offset54).isActive = true
        button.titleLabel?.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -Constants.offset16).isActive = true
        
        // Shadow
        button.shadowPath(shadowColor: .primarySkyBlue600,
                          shadowOffset: (width: 0.00, height: 4.00),
                          shadowRadius: 8.0,
                          shadowOpacity: 1.0,
                          alpha: 0.5)
        // Alpha
        button.alpha = 0.0
        return button
    }()
    
    init(authService: AuthServiceProtocol ) {
        self.authService = authService
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    // Add view
    private func addView() {
        view.addSubview(beWiredLogo)
        view.addSubview(beWiredLabel)
        view.addSubview(humanSilhouetteImageView)
        humanSilhouetteImageView.addSubview(humanSilhouetteImageViewBlue)
        view.addSubview(telegramLoginButton)
    }
}

// MARK: Actions
private extension SplashScreenVC {
    
    func addActions() {
        telegramLoginButton.addTarget(self, action: #selector(openLoginVC), for: .touchUpInside)
    }
    
    @objc func openLoginVC() {
        
        DispatchQueue.main.async { [ weak self ] in
            guard let self else {
                return
            }
            let nextVC = LoginVC(viewmodel: LoginViewModel(auth: self.authService, isValidDataService: IsValidDataService()))
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
}

// MARK: Animate
private extension SplashScreenVC {
    
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
            self.telegramLoginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.humanSilhouetteImageViewBlue.frame.height * Constants.percentage19).isActive = true
            
            // 3 isVisible
            self.telegramLoginButton.alpha = 1.0
            self.humanSilhouetteImageViewBlue.alpha = 1.0
            
            // 4 Logo constraints and isVisible
            self.beWiredLogo.bottomAnchor.constraint(equalTo: self.humanSilhouetteImageView.topAnchor, constant: -Constants.offset84).isActive = true
            self.beWiredLogo.alpha = 1.0
            
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
            self.beWiredLabel.bottomAnchor.constraint(equalTo: self.humanSilhouetteImageView.topAnchor, constant: -Constants.offset64).isActive = true
            self.beWiredLabel.centerXAnchor.constraint(equalTo: self.beWiredLogo.centerXAnchor).isActive = true
            
            // 3 Update layout
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: Constraints
private extension SplashScreenVC {
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            beWiredLogo.bottomAnchor.constraint(equalTo: humanSilhouetteImageView.topAnchor),
            beWiredLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            beWiredLabel.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width * Constants.percentage51),
            beWiredLabel.heightAnchor.constraint(equalToConstant: Constants.height48),
            
            beWiredLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (-humanSilhouetteImageView.frame.height * Constants.percentage15)),
            
            humanSilhouetteImageView.topAnchor.constraint(equalTo: view.centerYAnchor),
            humanSilhouetteImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            humanSilhouetteImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            humanSilhouetteImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            humanSilhouetteImageViewBlue.topAnchor.constraint(equalTo: humanSilhouetteImageView.topAnchor),
            humanSilhouetteImageViewBlue.leadingAnchor.constraint(equalTo: humanSilhouetteImageView.leadingAnchor),
            humanSilhouetteImageViewBlue.trailingAnchor.constraint(equalTo: humanSilhouetteImageView.trailingAnchor),
            humanSilhouetteImageViewBlue.bottomAnchor.constraint(equalTo: humanSilhouetteImageView.bottomAnchor),
            
            telegramLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.offset16),
            telegramLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            telegramLoginButton.widthAnchor.constraint(equalToConstant: Constants.width220),
            telegramLoginButton.heightAnchor.constraint(equalToConstant: Constants.height52),
            
        ])
    }
}



