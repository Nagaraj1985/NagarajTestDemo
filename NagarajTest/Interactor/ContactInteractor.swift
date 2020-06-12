

import Foundation
import ContactsUI

class ContactInteractor {
    public typealias DataHandler = ([ContactModel], String?) -> Void
    var localContacts: [ContactModel] = []
    var serverContacts: [ContactModel] = []
    
    init() {
        self.localContacts = self.contactModels()
    }
}

extension ContactInteractor {
    
    func fetchLocalContacts() -> [CNContact] {

        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                        CNContactPhoneNumbersKey,
                        CNContactEmailAddressesKey
                ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                    (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        print("\(contact.givenName) \(contact.familyName) tel:\(localizedLabel) -- \(number.stringValue), email: \(contact.emailAddresses)")
                    }
                }
            }
            print(contacts)
            return contacts
        } catch {
            print("unable to fetch contacts")
            return []
        }
    }
    
    func contactModels() -> [ContactModel] {
        var models: [ContactModel] = []
        let localContacts = fetchLocalContacts()
        var params: [Any] = []
        for contact in localContacts {
            var param: [String: Any] = [:]
            param["first_name"] = contact.givenName
            param["last_name"] = contact.familyName
            if contact.phoneNumbers.count > 0 {
                param["mobile_number"] = self.formatPhoneNumber(number: contact.phoneNumbers[0].value.stringValue)
            }
            if contact.emailAddresses.count > 0 {
                param["email_id"] = contact.emailAddresses[0].value as String
            }

            params.append(param)
        }
        do {
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

        models = try JSONDecoder().decode([ContactModel].self, from: jsonData)
        }
        catch {
            print("Error in parsing")
        }
        return models
    }
    
    func fetchSeverContacts(completion: @escaping DataHandler) {
        NetworkManager.fetchContacts(success: {[weak self] (response) in
            do {
                guard let jsonData = response else { return }
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])

                // you can now cast it with the right type
                if let dictFromJSON = decoded as? [String: Any] {
                    // use dictFromJSON
                    let dataArray = dictFromJSON["data"] ?? []
                    let jsonData = try JSONSerialization.data(withJSONObject: dataArray, options: .prettyPrinted)

                    self?.serverContacts = try JSONDecoder().decode([ContactModel].self, from: jsonData)
                    completion(self?.serverContacts ?? [], nil)
                }
                
            } catch {
                print("error in parsing data")
                completion(self?.serverContacts ?? [], nil)
            }
        }) { (response, object, error) in
            print("error in retrieving data")
            completion(self.serverContacts , nil)
            
        }
    }
    
    func formatPhoneNumber(number: String) -> Int64 {
        let normalized = number.replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
        return Int64(normalized)!
            
    }
    
    func allContacts(completion: @escaping DataHandler) {
        self.fetchSeverContacts { [weak self] (_, _) in
            completion((self?.serverContacts ?? []) + (self?.localContacts ?? []), nil)
        }
    }
}
