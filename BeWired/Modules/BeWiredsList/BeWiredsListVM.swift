//
//  BeWiredsListVM.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import Foundation

internal enum PullStatus {
    case inprogress
    case done(_ count: Int)
    case empty
}

protocol BeWiredsListProtocol {
    var beWireds: [BeWiredTest] {get set}
    var beWiredsDidUpadete: (()-> Void)? {get set}
    var pullStatusDidUpdate: (() -> Void)? {get set}
    var pullStatus: PullStatus? { get set }
    func pullDidPressed()
}

final class BeWiredsListViewModel: BeWiredsListProtocol {
    var pullStatusDidUpdate: (() -> Void)?
    
    var pullStatus: PullStatus? {
        didSet {
            pullStatusDidUpdate?()
        }
    }
    
    var beWiredsDidUpadete: (() -> Void)?
    
    var beWireds: [BeWiredTest] = [
        BeWiredTest(user: "Ilon Mask"),
        BeWiredTest(user: "Arkadi Ukupnik")
    ] {
        didSet {
            beWiredsDidUpadete?()
        }
    }
    
    private let pullService: FakePullProtocol
    
    init(pullService: FakePullProtocol) {
        self.pullService = pullService
    }
    
    
    func pullDidPressed() {
        pullStatus = .inprogress
        pullService.pull { [weak self] result in
            guard let self else {return}
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let beWireds):
                self.beWireds = beWireds + self.beWireds
                beWireds.isEmpty ? (self.pullStatus = .empty) : (self.pullStatus = .done(beWireds.count))
            }
        }
    }
    
}
