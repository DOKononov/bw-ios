//
//  BeWiredTest.swift
//  BeWired
//
//  Created by Dmitry Kononov on 14.05.23.
//

import Foundation
final class BeWiredTest {
    let user: String
    var date: Date = Randomiser.randomDate()
    var duration: TimeInterval = Randomiser.randomTimeInterval()
    
    var description: String {
        generateDescription()
    }
    
    init(user: String) {
        self.user = user
    }

    private func generateDescription() -> String {
        return "Пользователь \(user) \nЗаписал свой новый биваред \(date.formatDateToString()) \nПродолжительность \(duration.formatTimeIntervalToString())\n•\(fakeNews.randomElement()!) \n•\(fakeNews.randomElement()!) \n•\(fakeNews.randomElement()!) \n•\(fakeNews.randomElement()!) \n•\(fakeNews.randomElement()!) \nПриятного прослушивания"
    }
    
    private let fakeNews = ["👌джакузи после качалки",
                            "😜 на 3/4 на работе мечты",
                            "🧔‍♀ поболтал с одним из топ-менеджеров",
                            "👮‍♀провел исследование проекта тинькофф инвестиции джакузи после качалки",
                            "🏁финалы в тинькоф",
                            "🎁придумал себе награду ща трудоустройство",
                            "🤑занятие в школе по криптовалютам"]
}

class Randomiser {
    static func randomDate() -> Date {
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date()
        let timeInterval = endDate.timeIntervalSince(startDate)
        let randomTimeInterval = TimeInterval(arc4random_uniform(UInt32(timeInterval)))
        return startDate.addingTimeInterval(randomTimeInterval)
    }
    
    static func randomTimeInterval() -> TimeInterval {
        let minDuration: TimeInterval = 300
        let maxDuration: TimeInterval = 5600
        let randomDuration = TimeInterval(arc4random_uniform(UInt32(maxDuration - minDuration))) + minDuration
        return randomDuration
    }
    
}
