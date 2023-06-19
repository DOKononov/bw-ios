
import Foundation

protocol ProfileVMProtocol {
    var dairysArray: [TestDairysModel] {get}
    var user: User? {get set}
    
    var didReciveError: ((String) -> Void)? {get set}
}

final class ProfileVM : ProfileVMProtocol {
    var user: User?
    init(user: User?) {
        self.user = user
    }
    
    var didReciveError: ((String) -> Void)?
    
    var dairysArray = [TestDairysModel(time: "4:24",
                                       partsCount: "2 parts",
                                       title: "7 May diary",
                                       likeCount: 12,
                                       timestams: [Timestams(time: "00:00",
                                                             description: "Ranting about my neighbour",
                                                             likeCount: 0),
                                                   Timestams(time: "08:20",
                                                             description: "My fist fail in crypto trading",
                                                             likeCount: 0),
                                                   Timestams(time: "00:00",
                                                                         description: "Ranting about my neighbour",
                                                                         likeCount: 0)]),
                       TestDairysModel(time: "19:25",
                                       partsCount: "2 parts",
                                       title: "9 May diary",
                                       likeCount: 12,
                                       timestams: [Timestams(time: "00:00",
                                                             description: "Got lost on the way to new office🤦‍♀️",
                                                             likeCount: 0),
                                                   Timestams(time: "08:20",
                                                             description: "My fist fail in crypto trading",
                                                             likeCount: 0)]),
                       TestDairysModel(time: "4:24",
                                                          partsCount: "2 parts",
                                                          title: "7 May diary",
                                                          likeCount: 12,
                                                          timestams: [Timestams(time: "00:00",
                                                                                description: "Ranting about my neighbour",
                                                                                likeCount: 0),
                                                                      Timestams(time: "08:20",
                                                                                description: "My fist fail in crypto trading",
                                                                                likeCount: 0),
                                                                      Timestams(time: "00:00",
                                                                                            description: "Ranting about my neighbour",
                                                                                            likeCount: 0)]),]
}
