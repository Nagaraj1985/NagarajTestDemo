

import UIKit

class ConatctDetailsViewController: UIViewController {

    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var conactName: UILabel!
    @IBOutlet weak var conatctPhoneNumber: UILabel!
    @IBOutlet weak var conatctDetailImage: UIImageView!
    var contactDetailModel : ContactViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setData()
    }
    
    func setData() {
        contactEmail.text = contactDetailModel.email
        conactName.text = contactDetailModel.fullName
        conatctPhoneNumber.text = contactDetailModel.phone
        print("contactDetailModel.profileUrl>>>", contactDetailModel.profileUrl!)
        DispatchQueue.main.async {
            
            if(self.contactDetailModel.profileUrl! != ""){
            let url = URL(string: self.contactDetailModel.profileUrl!)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            self.conatctDetailImage.image = UIImage(data: data!)
//            self.conatctDetailImage.layer.cornerRadius = self.conatctDetailImage.frame.height/2
//            self.conatctDetailImage.layer.masksToBounds = false
//            self.conatctDetailImage.clipsToBounds = true
                
                self.conatctDetailImage.image = UIImage(data: data!)
                self.conatctDetailImage.layer.borderWidth = 1.0
                self.conatctDetailImage.layer.masksToBounds = false
                self.conatctDetailImage.layer.borderColor = UIColor.white.cgColor
                self.conatctDetailImage.layer.cornerRadius = self.conatctDetailImage.frame.size.width / 2
                self.conatctDetailImage.clipsToBounds = true
               
            } else {
                            self.conatctDetailImage.image = UIImage(named: "Avatar")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
