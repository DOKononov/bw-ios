
import Foundation
import TDLibKit

protocol ConfirmationViewModelProtocol{
    
    var didConfirmPhoneNumber: (() -> Void)? {get set}
    var didConfirmTwoStepAuth: (() -> Void)? { get set }
    var showTwoStepAuthAlert:(() -> Void)? { get set }
    var didReciveError: ((String) -> Void)? {get set}
    var auth: AuthServiceProtocol {get}
    
    func confirmPhoneNumber(with code: String)
    func checkForTwoStepAuth()
    func checkTwoStepAuth(pass: String)
}

final class ConfirmationViewModel: ConfirmationViewModelProtocol {
    
    
    var auth: AuthServiceProtocol
    
    var didConfirmPhoneNumber: (() -> Void)?
    var didConfirmTwoStepAuth: (() -> Void)?
    var showTwoStepAuthAlert:(() -> Void)?
    var didReciveError: ((String) -> Void)?
    
    init(auth: AuthServiceProtocol) {
        self.auth = auth
    }
    
    func confirmPhoneNumber(with code: String) {
        Task.init {
            do {
                try await auth.confirmPhoneNumber(code: code)
                checkForTwoStepAuth()
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
    }
}

extension ConfirmationViewModel {
    
    func checkForTwoStepAuth() {
        
        Task.init {
            do {
                let state = try await auth.getAuthorizationState()
                if state != .authorizationStateReady {
                    showTwoStepAuthAlert?()
                } else {
                    didConfirmPhoneNumber?()
                }
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
        
    }
    // Check 2FA pass
    func checkTwoStepAuth(pass: String) {
        Task.init {
            do {
                try await auth.checkTwoStepAuth(pass: pass)
                didConfirmPhoneNumber?()
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
    }
}

