

import Foundation
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: String?)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, body: Parameters?, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?

    func request(_ route: EndPoint, body: Parameters? = nil, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route, body: body)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completion(nil, nil, "Please check your network connection.")
                }
                self.handleResponse(data: data, response: response, completion: completion)
            })
        } catch {
            completion(nil, nil, error.localizedDescription)
        }
        self.task?.resume()
    }

    private func handleResponse(data: Data?, response: URLResponse?,
                                completion: @escaping NetworkRouterCompletion) {
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    completion(nil, nil, NetworkResponse.noData.rawValue)
                    return
                }
                completion(responseData, nil, nil)
            case .failure(let networkFailureError):
                completion(nil, nil, networkFailureError)
            }
        }
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }

    func cancel() {
        self.task?.cancel()
    }

    fileprivate func buildRequest(from route: EndPoint, body: Parameters? = nil) throws -> URLRequest {

        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 180.0)
        request.httpMethod = route.httpMethod.rawValue
        if let body = body {
            let data = try! JSONSerialization.data(withJSONObject: body as Any, options: .prettyPrinted)
            request.httpBody = data
        }

        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
            }
            return request
        } catch {
            throw error
        }
    }



}
