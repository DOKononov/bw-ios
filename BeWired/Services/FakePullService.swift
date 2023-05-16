//
//  FakePullService.swift
//  BeWired
//
//  Created by Dmitry Kononov on 15.05.23.
//

import Foundation


protocol FakePullProtocol {
    func pull(completion: @escaping (Result<[BeWiredTest], Error>) -> Void)
}

final class FakePullService: FakePullProtocol {
    
    private let defaultArray = [BeWiredTest(user: "Dima"),
                BeWiredTest(user: "Siarhei"),
                BeWiredTest(user: "Mikhail"),
                BeWiredTest(user: "Marilyn Manson"),
                BeWiredTest(user: "Kostia"),
                BeWiredTest(user: "Grisha"),
                BeWiredTest(user: "Vasia")]
                
    
    func pull(completion: @escaping (Result<[BeWiredTest], Error>) -> Void) {
        let randomDelay = Double.random(in: 0...4)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) { [weak self] in
            guard let self else {return}
            
            let tempArrayCount = Int.random(in: 0...2)
            
            var tempArray: [BeWiredTest] = []
            
            for _ in 0..<tempArrayCount {
                let randomIndex = Int.random(in: 0..<self.defaultArray.count)
                tempArray.append(self.defaultArray[randomIndex])
            }
            completion(.success(tempArray))
        }
        
    }
    
    
}
