

import UIKit

class ContactListTableViewController: UITableViewController {

    @IBOutlet weak var serachContacts: UISearchBar!
    var contactViewModels: [ContactViewModel] = []
    var filterContactViewModels: [ContactViewModel] = []
     var isFiltering: Bool = false
    
    let interactor = ContactInteractor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getConatcts()
        
    }
    
    func getConatcts() {
        
        interactor.allContacts { [weak self] (contacts, error) in
            guard contacts.count > 0 else {
                print("No Contact found")
                return
            }
            for contact in contacts {
                let fullName = contact.firstName + " " + contact.lastName
                let contactViewModel: ContactViewModel = ContactViewModel(fullName: fullName, phone: String(contact.mobileNumber), email: contact.emailID ?? "", profileUrl: contact.profileUrl ?? "")
                self?.contactViewModels.append(contactViewModel)
            }
            self?.tableView.reloadData()
        }

        
    }
    
    //MARK: - search data
    func filterContentForSearchText(_ searchText: String) {
        filterContactViewModels = contactViewModels.filter { (contactList: ContactViewModel) -> Bool in
            
            if searchText.count == 0 {
                return false
            } else {
                return contactList.fullName!.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filterContactViewModels.count : contactViewModels.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactListTableViewCell {
            
            guard contactViewModels.count > indexPath.row else { return UITableViewCell() }
            
             let mainData = isFiltering ? filterContactViewModels : contactViewModels
            //let cellData = mainData[indexPath.row]
            
            cell.bind(with: mainData[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainData = isFiltering ? filterContactViewModels : contactViewModels
        let  mainDataObj =  mainData[indexPath.row]
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "conactDetailsVC") as! ConatctDetailsViewController
        detailController.contactDetailModel = mainDataObj
        self.navigationController?.pushViewController(detailController, animated: true)
    }


}

// MARK:- SearchBar Delegate

extension ContactListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true
        if searchBar.text?.count ?? 0 == 0 {
            
            isFiltering = false
            self.tableView.reloadData()
        }
        
        if isFiltering {
            filterContentForSearchText(searchText)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    // Hide keyboard when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    // Hide keyboard when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isFiltering = false
        self.tableView.reloadData()
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
}
