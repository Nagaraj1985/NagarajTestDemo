

import Foundation

struct ContactModel: Codable {
    let firstName: String
    let lastName: String
    let mobileNumber: Int64
    let emailID: String?
    let profileUrl: String?
    
    private enum CodingKeys : String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case mobileNumber = "mobile_number"
        case emailID = "email_id"
        case profileUrl = "profile_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.emailID = try container.decodeIfPresent(String.self, forKey: .emailID) ?? ""
        self.mobileNumber = try container.decodeIfPresent(Int64.self, forKey: .mobileNumber) ?? 0
        self.profileUrl = try container.decodeIfPresent(String.self, forKey: .profileUrl) ?? ""
    }

}


extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T
        where T : Decodable {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}
