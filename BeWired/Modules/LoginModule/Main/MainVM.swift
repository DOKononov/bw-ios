
import Foundation

protocol MainViewModelProtocol {
    func logout()
    func checkAuthState()
    var userDidChanged: ((User) -> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var didLogedout: (() -> Void)? {get set}
    var openAuthScreen: (() -> Void)? { get set }
    var auth: AuthServiceProtocol { get }
}

final class MainViewModel: MainViewModelProtocol {
    
    var auth: AuthServiceProtocol
    
    var didReciveError: ((String) -> Void)?
    var didLogedout: (() -> Void)?
    var userDidChanged: ((User) -> Void)?
    var openAuthScreen: (() -> Void)?
    
    private var user: User? {
        didSet {
            if let user {
                userDidChanged?(user)
            } else {
                didLogedout?()
            }
        }
    }
    
    init(auth: AuthServiceProtocol) {
        self.auth = auth
        showCurrentUser()
    }
 
    func showCurrentUser() {
        auth.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.didReciveError?(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        auth.logout { [weak self] result in
            switch result {
            case .success():
                self?.user = nil
                self?.didLogedout?()
            case .failure(let error):
                self?.didReciveError?(error.localizedDescription)
            }
        }
    }
}
// MARK: - Check auth state
extension MainViewModel {
    
    func checkAuthState() {
        // 1
        auth.getAuthorizationState { [ weak self ] (result) in
            // 2
            switch result {
            case .success(let state):
                if state != .authorizationStateReady {
                    self?.openAuthScreen?()
                }
            case .failure(let error):
                self?.didReciveError?(String(describing: error))
            }
        }
    }
}
