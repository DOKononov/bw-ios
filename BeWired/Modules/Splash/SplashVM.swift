//
//  SplashVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 11.06.23.
//

import UIKit

protocol SplashVMProtocol {
    var auth: AuthServiceProtocol {get}
    var didReciveError: ((String) -> Void)? {get set}
    var openFeedVC: (() -> Void)? {get set}
}

final class SplashVM: SplashVMProtocol {
    let auth: AuthServiceProtocol
    var didReciveError: ((String) -> Void)?
    var openFeedVC: (() -> Void)?
    
    init() {
        self.auth = AuthService()
        checkAuthState()
    }
    
    private func checkAuthState() {
        Task.init {
            do {
                let state = try await auth.getAuthorizationState()
                if state == .authorizationStateReady {
                    openFeedVC?()
                }
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
    }

}
