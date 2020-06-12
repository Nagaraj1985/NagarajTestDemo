//
//  AuthClass.swift
//  NagarajTest
//
//  Created by Rahul Sagar on 10/06/20.
//  Copyright © 2020 Vikas Kumar. All rights reserved.
//

import Foundation
import Auth0

class AuthClass {
    func letMeLogin(){
        
        
    }
    
    func letMeLogout(finished: @escaping (Bool) -> Void) {
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
                    // Do something with credentials e.g.: save them.
                    // Auth0 will automatically dismiss the login page
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
