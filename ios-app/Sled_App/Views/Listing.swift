import SwiftUI
import CoreLocation

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}

struct Listing: Identifiable, Codable {
    let id = UUID()
    var title: String
    var activity: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var location: String
    var coordinate: CLLocationCoordinate2D
    var pricePerPerson: String
    var currency: String
    var maxUsers: Int
}
