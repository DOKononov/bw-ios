
import UIKit

final class AudioPlayerView: UIView, AudioPlayerViewProtocol {
    
    var isAvatarTapAvailability: Bool {
        didSet {}
    }
    
    init(isAvatarTapAvailability: Bool) {
         self.isAvatarTapAvailability = isAvatarTapAvailability
         super.init(frame: .zero)
         self.configure()
         self.addSubviews()
         self.addTargets()
         self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var playerAvatarDidTapped: (() -> Void)?
    
    var text = "" {
        didSet {
            descriptionLabel.text = text
        }
    }
    var userPicture = UIImage() {
        didSet {
            avatar.image = userPicture
        }
    }
    
    // MARK: - Labels
    private let listenedTimeLabel = UniversalLabel(text: "11:00", textColor: .bwPrimarySkyBlue600, font: .bwInterMedium10 ?? UIFont.systemFont(ofSize: Constants.size10), textAlign: .center)
    
    private let remainingTimeLabel = UniversalLabel(text: "-08:00", textColor: .bwPrimarySkyBlue600, font: .bwInterMedium10 ?? UIFont.systemFont(ofSize: Constants.size10), textAlign: .center)
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bwInterMedium10
        return label
    }()
    
    // MARK: - View
    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .bwPrimarySkyBlue500
        view.trackTintColor = .bwPrimaryGray100
        view.progress = 0.5
        return view
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.backgroundColor
        return view
    }()
    
    // MARK: - ImageView
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.makeRounded(Constants.cornerRadius10, false)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Buttons
    private let playStopButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pause.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .selected)
        button.setImage(UIImage(systemName: "play.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = .bwPrimaryGray800
        button.makeRounded(Constants.cornerRadius20, false)
        return button
    }()
}

private let forwardButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "forward.end.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    button.backgroundColor = .bwPrimaryGray800
    button.makeRounded(Constants.cornerRadius16, false)
    return button
}()

private let backwardButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "backward.end.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
    button.backgroundColor = .bwPrimaryGray800
    button.makeRounded(Constants.cornerRadius16, false)
    return button
}()

// MARK: - Set view
private extension AudioPlayerView {
    func configure() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = Constants.cornerRadius16
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

// MARK: - Add subview
private extension AudioPlayerView {
    func addSubviews() {
        self.addSubview(avatar)
        self.addSubview(playStopButton)
        self.addSubview(backwardButton)
        self.addSubview(forwardButton)
        self.addSubview(listenedTimeLabel)
        self.addSubview(remainingTimeLabel)
        self.addSubview(progressView)
        self.addSubview(descriptionLabel)
        self.addSubview(spacer)
    }
}

// MARK: - Action/Target
private extension AudioPlayerView {
    
    // Targets
    func addTargets() {
        playStopButton.addTarget(self, action: #selector(playPauseDidTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    // Actions
    @objc func playPauseDidTapped() {
        playStopButton.isSelected = !playStopButton.isSelected
    }
    
    @objc func avatarTapped() {
        if isAvatarTapAvailability {
            self.playerAvatarDidTapped?()
        }
    }
}

// MARK: - Constraints
private extension AudioPlayerView {
    func constraints() {
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.offset8),
            avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset8),
            avatar.widthAnchor.constraint(equalToConstant: Constants.width48),
            avatar.heightAnchor.constraint(equalToConstant: Constants.height48),
            
            playStopButton.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.offset12),
            playStopButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playStopButton.widthAnchor.constraint(equalToConstant: Constants.width40),
            playStopButton.heightAnchor.constraint(equalToConstant: Constants.height40),
            
            backwardButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor),
            backwardButton.trailingAnchor.constraint(equalTo: playStopButton.leadingAnchor, constant: -Constants.offset12),
            backwardButton.widthAnchor.constraint(equalToConstant: Constants.width32),
            backwardButton.heightAnchor.constraint(equalToConstant: Constants.width32),
            
            forwardButton.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor),
            forwardButton.leadingAnchor.constraint(equalTo: playStopButton.trailingAnchor, constant: Constants.offset12),
            forwardButton.widthAnchor.constraint(equalToConstant: Constants.width32),
            forwardButton.heightAnchor.constraint(equalToConstant: Constants.width32),
            
            listenedTimeLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: Constants.offset22),
            listenedTimeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset16),
            listenedTimeLabel.widthAnchor.constraint(equalToConstant: Constants.width30),
            listenedTimeLabel.heightAnchor.constraint(equalToConstant: Constants.height12),
            
            remainingTimeLabel.topAnchor.constraint(equalTo: listenedTimeLabel.topAnchor),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.offset16),
            remainingTimeLabel.widthAnchor.constraint(equalToConstant: Constants.width35),
            remainingTimeLabel.heightAnchor.constraint(equalToConstant: Constants.height12),
            
            progressView.centerYAnchor.constraint(equalTo: listenedTimeLabel.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: listenedTimeLabel.trailingAnchor, constant: Constants.offset6),
            progressView.trailingAnchor.constraint(equalTo: remainingTimeLabel.leadingAnchor, constant: -Constants.offset6),
            progressView.heightAnchor.constraint(equalToConstant: Constants.height4),
            
            descriptionLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: Constants.offset8),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.offset15_5),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.offset15_5),
            descriptionLabel.heightAnchor.constraint(equalToConstant: Constants.height12),
            
            spacer.topAnchor.constraint(equalTo: self.bottomAnchor),
            spacer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: Constants.height50)
            
        ])
    }
}

