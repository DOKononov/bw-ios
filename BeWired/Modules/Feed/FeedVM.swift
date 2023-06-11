//
//  FeedVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 7.06.23.
//

import Foundation

protocol FeedVMProtocol {
    var beWireds: [URL] {get set}
    var beWiredsDidUpadete: (()-> Void)? {get set}
    var didReciveError: ((String) -> Void)? {get set}
//    var pullStatusDidUpdate: (() -> Void)? {get set}
    var playDidChangedStatus: ((Bool)-> Void)? {get set}
    func wipe()


//    var pullStatus: PullStatus? { get set }
    func pullDidPressed()

    func deleteRecord(at url: URL)

}

final class FeedVM: FeedVMProtocol {
    var didReciveError: ((String) -> Void)?
    var beWiredsDidUpadete: (() -> Void)?
//    var pullStatusDidUpdate: (() -> Void)?
    var playDidChangedStatus: ((Bool)-> Void)?


    private let storage: AudioStorageProtocol
    private var audioPlayer: AudioPlayerProtocol
    private let pullService: PullService
    private let user: User


    var beWireds: [URL] = [] {
        didSet {
            beWiredsDidUpadete?()
        }
    }

//    var pullStatus: PullStatus? {
//        didSet {
//            pullStatusDidUpdate?()
//        }
//    }

    private var playInProgress = false {
        didSet {
            playDidChangedStatus?(playInProgress)
        }
    }

    init(user: User) {
        self.pullService = PullService()
        self.storage = AudioStorage()

        self.user = user
        self.audioPlayer = AudioPlayer()
       
        wipe()
        loadAllBeWireds()
        bind()
    }

    func wipe() {
        beWireds.removeAll()
    }
//    func wipe() {
//        let files = try! storage.getAllAudioFiles(of: .bewired)
//        files.forEach { url in
//            try! storage.deleteAudioFile(at: url)
//        }
//    }
    
    func pullDidPressed() {
        let url = URL(string: "https://fontstorage.com/ru/font/rasmus-andersson/inter")!
        beWireds = [url] + beWireds
//        pullStatus = .inprogress
//        pullService.pull(userId: "\(user.id)") { result in
//            switch result {
//            case .success(let newBeWireds):
//                self.beWireds = newBeWireds + self.beWireds
//
//                self.beWireds.isEmpty ?
//                (self.pullStatus = .empty) :
//                (self.pullStatus = .done(newBeWireds.count))
//
//            case .failure(let error):
//                self.didReciveError?(error.localizedDescription)
//                self.pullStatus = .empty
//            }
//        }
    }

    private func loadAllBeWireds() {
        do {
            self.beWireds = try storage.getAllAudioFiles(of: .bewired)
        } catch {
            didReciveError?(error.localizedDescription)
        }
    }

    private func bind() {
        audioPlayer.playDidFinished = { [weak self] in
            self?.playInProgress = false
        }
    }

    func deleteRecord(at url: URL) {
        do {
            try storage.deleteAudioFile(at: url)
        } catch {
            didReciveError?(error.localizedDescription)
        }
        loadAllBeWireds()
    }
}
