
import Foundation

struct TestDairysModel {
    var time: String
    var partsCount: String
    var title: String
    var likeCount: Int
    var timestams: [Timestams]
}

struct Timestams {
    var time: String
    var description: String
    var likeCount: Int
}


final class DeckVM: DeckVMProtocol {
    
    var dairysArray: [TestDairysModel] = [TestDairysModel(time: "4:24", partsCount: "2 parts", title: "7 May diary", likeCount: 12, timestams: [Timestams(time: "00:00", description: "Ranting about my neighbour", likeCount: 0)]), TestDairysModel(time: "19:25", partsCount: "2 parts", title: "9 May diary", likeCount: 12, timestams:
                                                                                                                                                                                                                                                                [Timestams(time: "00:00", description: "Got lost on the way to new office🤦‍♀️", likeCount: 0), Timestams(time: "08:20", description: "My fist fail in crypto trading", likeCount: 0)])]
    
                                                                                                                                                                                                                                                                        
    
}
