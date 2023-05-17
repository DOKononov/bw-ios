import Foundation

protocol SubscriptionsServiceProtocol {
    
    var task: URLSessionDataTask? { get set }
    
    func getSubscriptions(userId: Int64, complition: @escaping(NetworkServiceResult) -> Void)
    func getFollowers(userId: Int64, complition: @escaping(NetworkServiceResult) -> Void)
    func getAllUsers(complition: @escaping(NetworkServiceResult) -> Void)
    
    
    func subscribeToUser(userId: Int64, followeeId: Int64, complition: @escaping(NetworkServiceResult) -> Void)
    
    func unsubscribe(userToRemove: Int64, currentUser: Int64, complition: @escaping(NetworkServiceResult) -> Void)
}
