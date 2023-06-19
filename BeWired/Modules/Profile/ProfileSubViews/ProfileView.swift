
import UIKit

final class ProfileView: UIView {
    
    var userName = "" {
        didSet {
            nameLabel.text = userName
        }
    }
    
    var nickName = "" {
        didSet {
            nicknameLabel.text = nickName
        }
    }
    
    var userImage: UIImage? {
        didSet {
            profileImageView.image = userImage
        }
    }
    
    let entriesButton = ProfileViewButton(title: .entries)
    let followingButton = ProfileViewButton(title: .following)
    let followersButton = ProfileViewButton(title: .followers)
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "TestUserProfile")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .bwInterMedium18
        label.textColor = .bwPrimaryGray900
        label.text = "Kathryn Murphy"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameLabel: UILabel = {
       let label = UILabel()
        label.font = .bwInterMedium12
        label.textColor = .bwPrimarySkyBlue600
        label.text = "@kathymurr"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator: UIView = {
       let view = UIView()
        view.backgroundColor = .bwPrimaryGray200
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileBottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [entriesButton, followingButton, followersButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setupLayouts()
        self.backgroundColor = .bwPrimaryBaseWhite
        self.makeRounded(12, false)
        profileImageView.makeRounded(.circle, false)
        self.addShadow(color: UIColor(red: 0.671, green: 0.69, blue: 0.737, alpha: 0.2),
                        offset: (width: 0, height: 4),
                        radius: 15,
                        opacity: 1,
                        alpha: 0.2, false)
    }

    
    private func addSubviews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(nicknameLabel)
        addSubview(separator)
        addSubview(profileBottomStack)
    }
    
    private func setupLayouts() {
   
        NSLayoutConstraint.activate([
            
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            profileImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.34), //64
            profileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.34), //64
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15), //28
            
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nicknameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.086), //16
            
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            
            profileBottomStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            profileBottomStack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8),
            profileBottomStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            profileBottomStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),

        ])

    }
}
