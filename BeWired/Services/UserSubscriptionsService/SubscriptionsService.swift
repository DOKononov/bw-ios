
import Foundation

enum NetworkServiceResult {
    case success([Decodable])
    case error(error: Error)
}

enum NetworkServiceErrors: Error {
    case getDataError
    case urlStringInvalid
}

final class SubscriptionsService: SubscriptionsServiceProtocol {
    
    var task: URLSessionDataTask?
    
    // Get subscriptions list
    func getSubscriptions(userId: Int64, complition: @escaping(NetworkServiceResult) -> Void) {
        // 1
        guard
            let url = URL(string: "http://158.160.10.81:8186/api/v1/user/\(userId)/subscriptions") else {
            complition(.error(error: NetworkServiceErrors.urlStringInvalid))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = String.RequestMethod.GET
        // 2
        self.task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 3
            if let error {
                complition(NetworkServiceResult.error(error: error))
                // 4
            } else if let data {
                // 5
                do {
                    let subscriptionsList = try JSONDecoder().decode([UserDTO].self, from: data)
                    DispatchQueue.main.async {
                        complition(NetworkServiceResult.success(subscriptionsList))
                    }
                } catch {
                    complition(NetworkServiceResult.error(error: error))
                }
            }
            // 6
        }
        task?.resume()
    }
    
    // Get followers list
    func getFollowers(userId: Int64, complition: @escaping(NetworkServiceResult) -> Void) {
        // 1
        guard
            let url = URL(string: "http://158.160.10.81:8186/api/v1/user/\(userId)/followers") else {
            complition(.error(error: NetworkServiceErrors.urlStringInvalid))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = String.RequestMethod.GET
        // 2
        self.task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 3
            if let error {
                complition(NetworkServiceResult.error(error: error))
                // 4
            } else if let data {
                // 5
                do {
                    let subscriptionsList = try JSONDecoder().decode([UserDTO].self, from: data)
                    DispatchQueue.main.async {
                        complition(NetworkServiceResult.success(subscriptionsList))
                    }
                } catch {
                    complition(NetworkServiceResult.error(error: error))
                }
            }
            // 6
        }
        task?.resume()
    }
    
    // Get all users list
    func getAllUsers(complition: @escaping(NetworkServiceResult) -> Void) {
        // 1
        guard
            let url = URL(string: String.RequestLinks.allUsersLink) else {
            complition(.error(error: NetworkServiceErrors.urlStringInvalid))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = String.RequestMethod.GET
        // 2
        self.task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 3
            if let error {
                complition(NetworkServiceResult.error(error: error))
                // 4
            } else if let data {
                // 5
                do {
                    let subscriptionsList = try JSONDecoder().decode([UserDTO].self, from: data)
                    DispatchQueue.main.async {
                        complition(NetworkServiceResult.success(subscriptionsList))
                    }
                } catch {
                    complition(NetworkServiceResult.error(error: error))
                }
            }
            // 6
        }
        task?.resume()
    }
    
    // Subscribe to user
    func subscribeToUser(userId: Int64, followeeId: Int64, complition: @escaping(NetworkServiceResult) -> Void) {
        // #1
        guard let url = URL(string: String.RequestLinks.updateSubscriptionsLink) else {
            return
        }
        // #2
        let parameters = ["userId": userId,
                          "followeeId": followeeId]
        var request = URLRequest(url: url)
        request.httpMethod = String.RequestMethod.POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // #3
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        // #4
        self.task =
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                complition(.error(error: error))
            }
            // #5
            guard let data = data else {
                complition(.error(error: NetworkServiceErrors.getDataError))
                return
            }
            // #6
            do {
                let object = try JSONDecoder().decode(SubscriptionsModel.self, from: data)
                let objectArray = [object]
                complition(.success(objectArray))
            } catch {
                print(String(describing: error))
                complition(.error(error: error))
            }
        }
        task?.resume()
    }
    
    // Unsubscribe followers from self
    func unsubscribe(userToRemove: Int64, currentUser: Int64, complition: @escaping(NetworkServiceResult) -> Void) {
        // #1
        guard let url = URL(string: String.RequestLinks.updateSubscriptionsLink) else {
            return
        }
        // #2
        let parameters = ["userId": currentUser,
                          "followeeId": userToRemove]
        var request = URLRequest(url: url)
        request.httpMethod = String.RequestMethod.DELETE
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // #3
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        // #4
        self.task =
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                complition(.error(error: error))
            }
            // #5
            guard let data = data else {
                complition(.error(error: NetworkServiceErrors.getDataError))
                return
            }
            // #6
            do {
                let object = try JSONDecoder().decode(SubscriptionsModel.self, from: data)
                let objectArray = [object]
                complition(.success(objectArray))
            } catch {
                print(String(describing: error))
                complition(.error(error: error))
            }
        }
        task?.resume()
    }
}
