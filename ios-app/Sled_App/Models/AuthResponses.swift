import Foundation

struct LoginResponse: Codable {
    let token: String?
    let userId: String?
}

struct SignUpResponse: Codable {
    let message: String
}
