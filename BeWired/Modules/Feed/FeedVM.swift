//
//  FeedVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.06.23.
//

import Foundation

protocol FeedVMProtocol {
    var auth: AuthServiceProtocol {get}
    var user: User? { get set } 
    var beWireds: [URL] {get set}
    func wipe()
    func pullDidPressed()
    var beWiredsDidUpadete: (()-> Void)? {get set}

    var userDidChanged: ((User) -> Void)? {get set}
    
    var didReciveError: ((String) -> Void)? {get set}

}

final class FeedVM: FeedVMProtocol {
    var didReciveError: ((String) -> Void)?
    var beWiredsDidUpadete: (() -> Void)?
    var playDidChangedStatus: ((Bool)-> Void)?
    var userDidChanged: ((User) -> Void)?
    let auth: AuthServiceProtocol


    var user: User? {
        didSet {
            if let user {
                userDidChanged?(user)
            } 
        }
    }

    var beWireds: [URL] = [] {
        didSet {
            beWiredsDidUpadete?()
        }
    }


    private var playInProgress = false {
        didSet {
            playDidChangedStatus?(playInProgress)
        }
    }

    init(authService: AuthServiceProtocol) {
        self.auth = authService
       getCurrentUser()
    }

    
    private func getCurrentUser() {
        Task.init {
            do {
                self.user = try await auth.getCurrentUser()
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
    }

    func pullDidPressed() {
        let url = URL(string: "https://fontstorage.com/ru/font/rasmus-andersson/inter")!
        beWireds = [url] + beWireds
    }

    func wipe() {
        beWireds = []

    }
}
