
import Foundation

protocol MainViewModelProtocol {
    func logout()

    var userDidChanged: ((User) -> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var didLogedout: (() -> Void)? {get set}
    var openAuthScreen: (() -> Void)? { get set }
    var auth: AuthServiceProtocol { get }
    var user: User? {get}
    func startBot()
}

final class MainViewModel: MainViewModelProtocol {
    
    var auth: AuthServiceProtocol
    
    var didReciveError: ((String) -> Void)?
    var didLogedout: (() -> Void)?
    var userDidChanged: ((User) -> Void)?
    var openAuthScreen: (() -> Void)?
    
    var user: User? {
        didSet {
            if let user {
                userDidChanged?(user)

            }
        }
    }
    
    func startBot() {
        Task.init {
            do {
                try await auth.startBot()
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
    }
    
    init(auth: AuthServiceProtocol) {
        self.auth = auth
        showCurrentUser()
    }
    
    func showCurrentUser() {
        Task.init {
            do {
                self.user = try await auth.getCurrentUser()
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        
        Task {
            do {
                try await auth.logout()
                user = nil
                    self.didLogedout?()

            } catch {
                didReciveError?(error.localizedDescription)
            }
        }

    }
}
