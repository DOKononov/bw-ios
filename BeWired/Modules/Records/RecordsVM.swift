//
//  RecordsVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 20.05.23.
//

import Foundation

protocol RecordsVMProtocol {
    func recDidTapped()
    func playDidTapped()
    var recordsPath: [URL] {get set}
    var selectedRecordUrl: URL? {get set}
    var didReciveError: ((String) -> Void)? {get set}
    var recordsPathDidUpdate: (()-> Void)? {get set}
    var recDidChangedStatus: ((Bool)-> Void)? {get set}
    var playDidChangedStatus: ((Bool)-> Void)? {get set}
    func deleteRecord(at url: URL)
}

final class RecordsVM: RecordsVMProtocol {
    var recDidChangedStatus: ((Bool) -> Void)?
    var playDidChangedStatus: ((Bool) -> Void)?
    var recordsPathDidUpdate: (() -> Void)?
    private let user: User
    
    private let audioRecorder: AudioRecorder
    private let audioPlayer: AudioPlayer
    private let audioStorage: AudioStorageProtocol
    private var dateStamp = ""
    private var recInProgress = false {
        didSet {
            recDidChangedStatus?(recInProgress)
        }
    }
    private var playInProgress = false {
        didSet {
            playDidChangedStatus?(playInProgress)
        }
    }
    var selectedRecordUrl: URL?
    var recordsPath: [URL] = [] {
        didSet {
            recordsPathDidUpdate?()
        }
    }
    var didReciveError: ((String) -> Void)?
    
    init(user: User) {
        self.user = user
        self.audioStorage = AudioStorage()
        self.audioPlayer = AudioPlayer(audioStorage)
        self.audioRecorder = AudioRecorder(audioStorage)
        getAllRecords()
        bind()
    }
    
    func deleteRecord(at url: URL) {
        audioStorage.deleteAudioFile(at: url) { [weak self] in self?.handleResult(result: $0)}
        getAllRecords()
    }
    
    func recDidTapped() {
        if recInProgress {
            audioRecorder.stopRecording()
        } else {
            dateStamp = Date().convertedToIdString()
            audioRecorder.startRecording(recordId: "\(user.id)\(dateStamp)") { [weak self] result in
                switch result {
                case .success():
                    self?.getAllRecords()
                case .failure(let error):
                    print(#function, error)
                }
            }
        }
        recInProgress = !recInProgress
    }
    
    func playDidTapped() {
        if playInProgress {
            audioPlayer.stop()
        } else {
            guard let selectedRecordUrl else {
                didReciveError?("selectedRecordUrl Error")
                return
            }
            audioPlayer.play(record: selectedRecordUrl) { [weak self] in self?.handleResult(result: $0)}
        }
        playInProgress = !playInProgress
    }
    
    func getAllRecords() {
        audioStorage.getAllAudioFiles { [weak self] in self?.handleResult(result: $0)}
    }
    
    private func handleResult(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            self.recordsPath = urls.sorted { $0.lastPathComponent > $1.lastPathComponent}
        case .failure(let error):
            self.didReciveError?(error.localizedDescription)
        }
    }
    
    private func handleResult(result: Result<Void, Error>) {
        switch result {
        case .success():
            break
        case .failure(let error):
            didReciveError?(error.localizedDescription)
        }
    }
    
    private func bind() {
        audioPlayer.playDidFinished = { [weak self] in
            self?.playInProgress = false
        }
    }
}
