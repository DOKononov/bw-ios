
import Foundation

struct UserDTO: Decodable {
    let id: Int64
    let chatId: String
    let username: String?
    let firstName: String?
    let lastName: String?
    let timezone: Int32?
    let feedbackModeAllowed: Bool
    let feedbackModeEnabled: Bool
    let replyModeFolloweeId: Int64?
    let replyModeMessageId: Int32?
}
