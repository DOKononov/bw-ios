
protocol UsersListVmProtocol: AnyObject {
    
    var usersListArray: [UserDTO] { get set }
    var update: (() -> Void)? { get set }
    var updateError: (() -> Void)? { get set }
    
    func getSubscriptions(userId: Int64,
                          screenTitle: String)
    
    func updateSubscriptions(userId: Int64,
                             indexPath: Int,
                             screenTitle: String)
    
    func cancelUrlDataTask()
}
