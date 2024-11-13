import Foundation
import CoreLocation


class ListingStore: ObservableObject {
    @Published var listings: [Listing] = [] {
        didSet {
            saveListings()
        }
    }
    @Published var bookings: [Booking] = [] {
        didSet {
            saveBookings()
        }
    }

    init() {
        loadListings()
        loadBookings()
    }

    // Listings
    private func saveListings() {
        if let encoded = try? JSONEncoder().encode(listings) {
            UserDefaults.standard.set(encoded, forKey: "listings")
        }
    }

    private func loadListings() {
        if let savedListings = UserDefaults.standard.object(forKey: "listings") as? Data {
            if let decodedListings = try? JSONDecoder().decode([Listing].self, from: savedListings) {
                listings = decodedListings
            }
        }
    }
    // Bookings
    private func saveBookings() {
        if let encoded = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(encoded, forKey: "bookings")
        }
    }

    private func loadBookings() {
        if let savedBookings = UserDefaults.standard.object(forKey: "bookings") as? Data {
            if let decodedBookings = try? JSONDecoder().decode([Booking].self, from: savedBookings) {
                bookings = decodedBookings
            }
        }
    }
}
