

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fullNameLabel.font = .normalTextFont
        mobileNumberLabel.font = .listBoldTextFont
        emailLabel.font = .smallTextFont
    }

    func bind(with contactViewModel: ContactViewModel) {
        fullNameLabel.text = contactViewModel.fullName
        mobileNumberLabel.text = contactViewModel.phone
        emailLabel.text = contactViewModel.email
        if let profileURL = contactViewModel.profileUrl {
            profileImageView.downloadImage(profileURL)
            profileImageView.layer.borderWidth = 1.0
            profileImageView.layer.masksToBounds = false
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            profileImageView.clipsToBounds = true
        }

    }
}


