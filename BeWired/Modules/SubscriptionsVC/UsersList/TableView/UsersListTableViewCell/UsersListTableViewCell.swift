
import UIKit

final class UsersListTableViewCell: UITableViewCell {
    
    static let reusedId = "UsersListTableViewCell"
    
    func setUserListCell(model: UserDTO) {
        var content = self.defaultContentConfiguration()
        content.text = "\(model.firstName ?? "")" + " " + "\(model.lastName ?? "")"
        self.contentConfiguration = content
        
    }
}

