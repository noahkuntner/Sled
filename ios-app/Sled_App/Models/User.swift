import Foundation

struct User: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    var userType: UserType
}

enum UserType: String, Codable {
    case guide
    case seeker
    case both
}
