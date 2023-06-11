
import Foundation

protocol LoginViewModelProtocol {
    var didSetPhoneNumber: (() -> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var auth: AuthServiceProtocol {get}
    func setPhoneNumber(_ number: String)
    func isValidPhone(number: String) -> Bool
}

final class LoginViewModel: LoginViewModelProtocol {
    
    var auth: AuthServiceProtocol
    var didSetPhoneNumber: (() -> Void)?
    var didReciveError: ((String) -> Void)?
    var isValidDataService: IsValidDataProtocol
    
    init(auth: AuthServiceProtocol,
         isValidDataService: IsValidDataProtocol) {
        self.auth = auth
        self.isValidDataService = isValidDataService
    }
    
    func setPhoneNumber(_ number: String) {
        Task.init {
            do {
                try await auth.setPhoneNumber(phoneNumber: number)
                showConfirmationVC()
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
    }
    
    func showConfirmationVC() {
        didSetPhoneNumber?()
    }
}

extension LoginViewModel {
    
    func isValidPhone(number: String) -> Bool {
        if isValidDataService.isValidMobile(number: number) {
            return true
        }
        return false
    }
}
