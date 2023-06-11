//
//  PullService.swift
//  BeWired
//
//  Created by Dmitry Kononov on 24.05.23.
//

import Foundation

enum PullError: Error {
    case invalidURL
    case invalidData
}

protocol PullProtocol {
    func pull(userId: String, completion: @escaping (Result<[URL], Error>) -> Void)
}

final class PullService: PullProtocol {
    let testUrl = "http://158.160.10.81:8186/api/v1/audio/284039117"
    let port = "8186"
    let tempUserId = "284039117"
    let storage = AudioStorage()
    private let prefix = RecordType.bewired.rawValue
    
    func pull(userId: String, completion: @escaping (Result<[URL], Error>) -> Void) {
        let urlStr = "http://158.160.10.81:\(port)/api/v1/audio/\(tempUserId)"
        let recordId = self.prefix+userId+Date().convertedToIdString()
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(PullError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(PullError.invalidData))
                return
            }
            self.storage.saveAudioFile(recordId: recordId, data: data) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let url):
                    completion(.success([url]))
                }
            }
        }.resume()

    }
}
