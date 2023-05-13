//
//  LoginVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 6.05.23.
//

import Foundation

protocol LoginViewModelProtocol {
    var didSetPhoneNumber: (() -> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var auth: AuthServiceProtocol {get}
    func setPhoneNumber(_ number: String)
}

final class LoginViewModel: LoginViewModelProtocol {
    var auth: AuthServiceProtocol
    var didSetPhoneNumber: (() -> Void)?
    var didReciveError: ((String) -> Void)?
    
    init(auth: AuthServiceProtocol) {
        self.auth = auth
    }
    
    func setPhoneNumber(_ number: String) {
        auth.setPhoneNumber(phoneNumber: number) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.didReciveError?(error.localizedDescription)
            case .success():
                self?.showConfirmationVC()
            }
        }
    }
    
    func showConfirmationVC() {
        didSetPhoneNumber?()
    }
}
