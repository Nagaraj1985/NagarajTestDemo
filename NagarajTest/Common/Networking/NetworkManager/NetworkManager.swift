

import UIKit

enum NetworkResponse:String {
    case success
    case badRequest = "Bad request."
    case authenticationError = "Authentication is required."
    case failed = "Network request failed."
    case noData = "No data to decode."
}

enum Result<String>{
    case success
    case failure(String)
}

public typealias SuccessHandler = (Data?) -> Void
public typealias FailureHandler = (URLResponse?, AnyObject?, String?) -> Void

struct NetworkManager {
    static let router = Router<API>()

    static func fetchContacts(success: @escaping SuccessHandler, failure: @escaping FailureHandler) {
        router.request(.retrieveContacts) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    failure(response, data as AnyObject?, error)
                }

                guard let responseData = data else {
                    failure(response, data as AnyObject?, NetworkResponse.noData.rawValue)
                    return
                }

                success(responseData)
            }
        }
    }
    
}
