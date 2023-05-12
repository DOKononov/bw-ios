//
//  ConfirmationVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.05.23.
//

import Foundation

protocol ConfirmationViewModelProtocol{
    var didConfirmPhoneNumber: (() -> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    func confirmPhoneNumber(with code: String)
}

final class ConfirmationViewModel: ConfirmationViewModelProtocol {
    private let auth: AuthServiceProtocol = AuthService.shared

    var didConfirmPhoneNumber: (() -> Void)?
    var didReciveError: ((String) -> Void)?
    
    
    func confirmPhoneNumber(with code: String) {
        
        auth.confirmPhoneNumber(code: code) { [weak self] result in
            switch result {
            case .success():
                self?.didConfirmPhoneNumber?()
            case .failure(let error):
                self?.didReciveError?(error.localizedDescription)
            }
        }
    }
    
}
