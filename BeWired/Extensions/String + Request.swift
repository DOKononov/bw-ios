extension String {
    enum RequestLinks {}
}

extension String.RequestLinks {
    static let allUsersLink = "http://158.160.10.81:8186/api/v1/users"
    static let updateSubscriptionsLink = "http://158.160.10.81:8186/api/v1/subscription"
}

extension String {
    enum RequestMethod {}
}

extension String.RequestMethod {
    static let GET = "GET"
    static let POST = "POST"
    static let DELETE = "DELETE"
}


