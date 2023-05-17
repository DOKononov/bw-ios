import Foundation

final class UsersListVM: UsersListVmProtocol {

    private var subscriptionService: SubscriptionsServiceProtocol
    
    var updateError: (() -> Void)?
    
    var update: (() -> Void)?
    
    init(getSubscriptionService: SubscriptionsServiceProtocol) {
        self.subscriptionService = getSubscriptionService
    }
    
    var usersListArray: [UserDTO] = [] {
        didSet {
            update?()
        }
    }
    
    // Stop URL request
    func cancelUrlDataTask() {
        subscriptionService.task?.cancel()
    }
}
// MARK: Get subscriptions list
extension UsersListVM {
    
    func getSubscriptions(userId: Int64,
                          screenTitle: String) {
        switch screenTitle {
        case String.SubscriptionListType.subscriptions:
            subscriptionService.getSubscriptions(userId: userId) { self.checkNetworkService(result: $0)
            }
        case String.SubscriptionListType.followers:
            subscriptionService.getFollowers(userId: userId) { self.checkNetworkService(result: $0)
            }
            
        case String.SubscriptionListType.allUsers:
            subscriptionService.getAllUsers() {
                self.checkNetworkService(result: $0)
            }
        default:
            break
        }
    }
}

// MARK: Update subscriptions
extension UsersListVM {
    
    func updateSubscriptions(userId: Int64,
                             indexPath: Int,
                             screenTitle: String) {
        // #1
        let userToRemove = Int64(usersListArray[indexPath].id)
        // #2
        switch screenTitle {
            
        case String.SubscriptionListType.subscriptions:
            usersListArray.remove(at: indexPath)
            
            subscriptionService.unsubscribe(userToRemove: userToRemove, currentUser: userId) { self.checkNetworkService(result: $0) }
            
        case String.SubscriptionListType.followers:
            usersListArray.remove(at: indexPath)
            subscriptionService.unsubscribe(userToRemove: userId, currentUser: userToRemove) { self.checkNetworkService(result: $0) }
            
        case String.SubscriptionListType.allUsers:
            guard userId != userToRemove else {
                return 
            }
            subscriptionService.subscribeToUser(userId: userId, followeeId: userToRemove) { self.checkNetworkService(result: $0) }
        default: break
        }
    }
}

// MARK: - Check Network Service result
private extension UsersListVM {
    
    func checkNetworkService(result: NetworkServiceResult) {
        
        switch result {
        case .success(let resultArray):
            if let userList = resultArray as? [UserDTO] {
                self.usersListArray = userList
            } else if let _ = resultArray as? [SubscriptionsModel] {
                // Use message for succes subscribing or unsubscribing
            }
        case .error(error: ):
            self.updateError?()
        }
        
    }
    
}
