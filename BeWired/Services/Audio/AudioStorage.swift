//
//  AudioStorage.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation

protocol AudioStorageProtocol {
    func saveAudioFile(recordId: String, data: Data, completion: @escaping AudioResult<URL>)
    func deleteAudioFile(recordId: String, completion: @escaping AudioResult<Void>)
    func deleteAudioFile(at url: URL, completion: @escaping AudioResult<Void>)
    func getAllAudioFiles(containing: String, completion: @escaping AudioResult<[URL]>)
    func getAllAudioFiles(completion: @escaping AudioResult<[URL]>)
    func getAudioFileURL(recordId: String) -> URL?
    func getDocumentsDirectory(for recordId: String) -> URL
}

final class AudioStorage: AudioStorageProtocol {
    
    private let fileManager: FileManager
    
    init() {
        self.fileManager = FileManager.default
    }
    
    func saveAudioFile(recordId: String, data: Data, completion: @escaping AudioResult<URL>) {
        let fileURL = getDocumentsDirectory(for: recordId)
        do {
            try data.write(to: fileURL)
            completion(.success(fileURL))
            return
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func deleteAudioFile(recordId: String, completion: @escaping AudioResult<Void>) {
        let fileURL = getDocumentsDirectory(for: recordId)
        do {
            try fileManager.removeItem(at: fileURL)
            completion(.success(()))
            return
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func deleteAudioFile(at url: URL, completion: @escaping AudioResult<Void>) {
        do {
            try fileManager.removeItem(at: url)
            completion(.success(()))
            return
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    func getAudioFileURL(recordId: String) -> URL? {
        let fileURL = getDocumentsDirectory(for: recordId)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            return nil
        }
    }
    
    
    func getDocumentsDirectory(for recordId: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(recordId).ogg", conformingTo: .audio)
    }
    
    private func getDocumentsDirectory() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getAllAudioFiles(containing: String, completion: @escaping AudioResult<[URL]>){
        let documentDirectory = getDocumentsDirectory()
        var audioFiles: [URL] = []
        
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for fileURL in directoryContents {
                let fileName = fileURL.lastPathComponent
                if fileName.contains(containing) {
                    audioFiles.append(fileURL)
                }
            }
        } catch {
            completion(.failure(error))
            return
        }
        completion(.success(audioFiles))
        return
    }
    
    func getAllAudioFiles(completion: @escaping AudioResult<[URL]>){
        let documentDirectory = getDocumentsDirectory()
        var audioFiles: [URL] = []
        do {
            audioFiles = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        } catch {
            completion(.failure(error))
            return
        }
        completion(.success(audioFiles))
        return
    }
}

