
import Foundation

protocol LoginViewModelProtocol {
    var didSetPhoneNumber: (() -> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var auth: AuthServiceProtocol {get}
    func setPhoneNumber(_ number: String)
    func isValidMobile(number: String) -> Bool

}

final class LoginViewModel: LoginViewModelProtocol {
    
    var auth: AuthServiceProtocol
    var didSetPhoneNumber: (() -> Void)?
    var didReciveError: ((String) -> Void)?
    var isValidDataService: IsValidDataProtocol
    
    init(_ auth: AuthServiceProtocol) {

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
    
    func isValidMobile(number: String) -> Bool {
        let smallestMobileCount = Constants.value11
        return number.first == "+" && number.count >= Int(smallestMobileCount)

    }
}
