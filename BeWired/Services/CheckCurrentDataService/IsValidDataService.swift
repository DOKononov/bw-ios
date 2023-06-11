
import Foundation

final class IsValidDataService: IsValidDataProtocol {
    
    let smallestMobileCount = Constants.value11
    
    func isValidMobile(number: String) -> Bool {
        if number.first == "+" && number.count >= Int(smallestMobileCount) {
            return true
        } else {
            return false
        }
    }
}
