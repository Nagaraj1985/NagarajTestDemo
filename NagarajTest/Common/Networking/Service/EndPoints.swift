

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}

enum API {
    case retrieveContacts
}

extension API: EndPointType {
    var httpMethod: HTTPMethod {
        switch self {
        case .retrieveContacts:
            return .get
        
        }
    }

    var baseURLString : String {
         return "https://7yd7u01nw9.execute-api.ap-south-1.amazonaws.com/prod/"
        }

    var baseURL: URL {
        guard let url = URL(string: baseURLString) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    var path: String {
        switch self {
        case .retrieveContacts:
            return "contact-list"
        }
    }

    var task: HTTPTask {
        switch self {
        case .retrieveContacts:
            return .request
        }
    }


}

