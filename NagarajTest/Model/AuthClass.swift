

import Foundation
import Auth0

class AuthClass {

    func letMeLogin(finished: @escaping (Bool) -> Void) {
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://dev-ge1y7su3.auth0.com/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentialsObj):

                    print("Credentials: \(credentialsObj.accessToken!)")
                    
                    guard let accessToken = credentialsObj.accessToken else {
                        return
                    }

                    Auth0
                        .authentication()
                        .userInfo(withAccessToken: accessToken)
                        .start { result in
                            switch(result) {
                            case .success(let profile):
                                // You've got the user's profile, good time to store it locally.
                                // e.g. self.profile = profile
                                DispatchQueue.main.async { [unowned self] in
                                    finished(true)
                                }
                                break
                            case .failure(let error):
                                // Handle the error
                                print("Error: \(error)")
                                DispatchQueue.main.async { [unowned self] in
                                    finished(false)
                                }
                            }
                        }
                }
        }
       
    }
}
