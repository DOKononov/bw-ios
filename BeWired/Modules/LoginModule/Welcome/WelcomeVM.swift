//
//  WelcomeVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.05.23.
//

import Foundation

protocol WelcomeViewModelProtocol {
    func logout()
    var userDidChanged: ((User) -> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var didLogedout: (() -> Void)? {get set}
}

final class WelcomeViewModel: WelcomeViewModelProtocol {
    
    private let auth: AuthServiceProtocol
    
    var didReciveError: ((String) -> Void)?
    var didLogedout: (() -> Void)?
    var userDidChanged: ((User) -> Void)?
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


