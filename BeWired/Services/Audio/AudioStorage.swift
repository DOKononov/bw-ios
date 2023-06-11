//
//  AudioStorage.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation
import SwiftOGG

protocol AudioStorageProtocol {
    func saveAudioFile(recordId: String, data: Data, completion: @escaping AudioResult<URL>)
    func deleteAudioFile(at url: URL) throws
    func getDocumentsDirectory(for recordId: String) -> URL
    func getAllAudioFiles(of type: RecordType) throws -> [URL]
}

final class AudioStorage: AudioStorageProtocol {
    
    private let fileManager: FileManager
    
    init() {
        self.fileManager = FileManager.default
    }
    
    func saveAudioFile(recordId: String, data: Data, completion: @escaping AudioResult<URL>) {
        let fileURLopus = getDocumentsDirectory(for: recordId).appendingPathExtension("opus")
        let fileURLpcm = getDocumentsDirectory(for: recordId).appendingPathExtension("pcm")
        do {
            try data.write(to: fileURLopus)
            try OGGConverter.convertOpusOGGToM4aFile(src: fileURLopus, dest: fileURLpcm)
            try fileManager.removeItem(at: fileURLopus)
            completion(.success(fileURLpcm))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteAudioFile(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }
    
    func getDocumentsDirectory(for recordId: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(recordId)", conformingTo: .audio)
    }
    
    private func getDocumentsDirectory() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getAllAudioFiles(of type: RecordType) throws -> [URL] {
        let documentDirectory = getDocumentsDirectory()
        var audioFiles: [URL] = []
        
        let directoryContents = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for fileURL in directoryContents {
            let fileName = fileURL.lastPathComponent
            if fileName.contains(type.rawValue) {
                audioFiles.append(fileURL)
            }
        }
        return audioFiles
    }
    
    //    func getAllAudioFiles() throws -> [URL] {
    //        let documentDirectory = getDocumentsDirectory()
    //        return try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
    //    }
    
    //    func getAudioFileURL(recordId: String) -> URL? {
    //        let fileURL = getDocumentsDirectory(for: recordId)
    //
    //        if fileManager.fileExists(atPath: fileURL.path) {
    //            return fileURL
    //        } else {
    //            return nil
    //        }
    //    }
    
    //    func deleteAudioFile(recordId: String) throws {
    //        let fileURL = getDocumentsDirectory(for: recordId)
    //        try fileManager.removeItem(at: fileURL)
    //    }
    
}

