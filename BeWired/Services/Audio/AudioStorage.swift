//
//  AudioStorage.swift
//  BeWired
//
//  Created by Dmitry Kononov on 26.04.23.
//

import Foundation

protocol AudioStorageProtocol {
    func getDocumentsDirectory() -> URL
}

final class AudioStorage: AudioStorageProtocol {
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryPath = path[0]
        return documentDirectoryPath.appending(path: "recording.wav")
    }  
}
