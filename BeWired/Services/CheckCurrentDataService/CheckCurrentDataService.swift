
import Foundation

final class CheckCurrentDataService: CheckCurrentDataProtocol {
    
    let smallestMobileCount = 11
    
    func checkCurrentMobile(number: String) -> Bool {
        if number.first == "+" && number.count >= smallestMobileCount {
            return true
        } else {
            return false
        }
    }
}
