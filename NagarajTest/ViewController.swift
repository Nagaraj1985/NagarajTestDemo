

import UIKit
import Auth0

//clientSecret:// dNqrHTGPXw0miJrvwToypPIckpZQJGbD9dLc-QGt6F6IH7naiAc4IEaqZImJFkCi
class ViewController: UIViewController {

    private var isAuthenticated = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // HomeViewController.swift


    }
    
    //https://dev-ge1y7su3.auth0.com/api/v2/

    @IBAction func loginSubmit(_ sender: Any) {
        let  authClassObj = AuthClass()
        authClassObj.letMeLogin(finished: { (resValue)  in
            self.performSegue(withIdentifier: "showContact", sender: self)
        })
        
    }
    
     @IBAction func logOut(_ sender: Any) {
        Auth0
        .webAuth()
        .clearSession(federated:false) {
            switch $0 {
                case true:
                   print("Succesfull Logout")
                case false:
                    print("Failed to logout")
            }
        }
    }

    
}


