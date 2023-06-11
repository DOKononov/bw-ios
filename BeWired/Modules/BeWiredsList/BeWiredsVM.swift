//
//  BeWiredsListVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import Foundation

protocol BeWiredsVMProtocol {
    var beWireds: [URL] {get set}
    var beWiredsDidUpadete: (()-> Void)? {get set}
    var pullStatusDidUpdate: (() -> Void)? {get set}
    var pullStatus: PullStatus? { get set }
    var didReciveError: ((String) -> Void)? {get set}
    func pullDidPressed()
    
    func playDidTapped()
    var selectedRecordUrl: URL? {get set}
    var playDidChangedStatus: ((Bool)-> Void)? {get set}
    func deleteRecord(at url: URL)
    
}

final class BeWiredsVM: BeWiredsVMProtocol {
    var didReciveError: ((String) -> Void)?
    private let storage: AudioStorageProtocol
    private var audioPlayer: AudioPlayerProtocol
    var selectedRecordUrl: URL?
    
    var pullStatusDidUpdate: (() -> Void)?
    private let user: User
    var pullStatus: PullStatus? {
        didSet {
            pullStatusDidUpdate?()
        }
    }
    
    var beWiredsDidUpadete: (() -> Void)?
    var playDidChangedStatus: ((Bool)-> Void)?
    
    var beWireds: [URL] = [] {
        didSet {
            beWiredsDidUpadete?()
        }
    }
    
    private let pullService: PullService
    
    init(user: User) {
        self.pullService = PullService()
        self.storage = AudioStorage()
        self.user = user
        self.audioPlayer = AudioPlayer()
        loadAllBeWireds()
        bind()
    }
    
    
    func pullDidPressed() {
        pullStatus = .inprogress
        pullService.pull(userId: "\(user.id)") { result in
            switch result {
            case .success(let newBeWireds):
                self.beWireds = newBeWireds + self.beWireds
                
                self.beWireds.isEmpty ?
                (self.pullStatus = .empty) :
                (self.pullStatus = .done(newBeWireds.count))
                
            case .failure(let error):
                self.didReciveError?(error.localizedDescription)
                self.pullStatus = .empty
            }
        }
    }
    
    private func loadAllBeWireds() {
        do {
            self.beWireds = try storage.getAllAudioFiles(of: .bewired)
        } catch {
            didReciveError?(error.localizedDescription)
        }
    }
    
    private var playInProgress = false {
        didSet {
            playDidChangedStatus?(playInProgress)
        }
    }
    
    func playDidTapped() {
        guard let selectedRecordUrl else {
            didReciveError?("selectedRecordUrl Error")
            return
        }
        
        if playInProgress {
            audioPlayer.stop()
        } else {
            do {
                try audioPlayer.play(record: selectedRecordUrl)
            } catch {
                didReciveError?(error.localizedDescription)
            }
        }
        playInProgress = !playInProgress
    }
    
    func deleteRecord(at url: URL) {
        do {
            try storage.deleteAudioFile(at: url)
        } catch {
            didReciveError?(error.localizedDescription)
        }
        loadAllBeWireds()
    }
    private func bind() {
        audioPlayer.playDidFinished = { [weak self] in
            self?.playInProgress = false
        }
    }
}
