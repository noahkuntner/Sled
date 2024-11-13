import SwiftUI
import CoreLocation

struct SearchResultView: View {
    let listings: [Listing]
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var listingStore: ListingStore
    @State private var isBookingActive = false
    @State private var selectedListing: Listing?

    var sortedListings: [Listing] {
        guard let userLocation = locationManager.currentLocation else { return [] }
        return listings.map { listing in
            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let listingCLLocation = CLLocation(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
            let distance = userCLLocation.distance(from: listingCLLocation)
            return (listing, distance)
        }
        .sorted { $0.1 < $1.1 }
        .map { $0.0 }
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(sortedListings, id: \.id) { listing in
                VStack(alignment: .leading) {
                    Text(listing.title)
                        .font(.headline)
                        .padding(.bottom, 2)

                    if let userLocation = locationManager.currentLocation {
                        let distance = calculateDistance(for: listing, from: userLocation)
                        Text(String(format: "%.2f km away", distance))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 2)
                    } else {
                        Text("Calculating distance...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 2)
                    }

                    HStack {
                        Text("\(listing.startTime, style: .time) - \(listing.endTime, style: .time)")
                        Spacer()
                        Text("\(listing.pricePerPerson) \(listing.currency) per person")
                    }
                    .font(.subheadline)
                    .padding(.bottom, 2)

                    HStack {
                        Text("Free Slots: \(listing.maxUsers)")
                        Spacer()
                        Text("Location: \(listing.location)")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)

                    HStack {
                        ActivityIconProvider.activityIcon(for: listing.activity)
                        Text(listing.activity)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                            selectedListing = listing
                            isBookingActive = true
                        }) {
                            Text("Book")
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 5)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.vertical, 5)

                Divider()
            }
        }
        .onAppear {
            locationManager.requestLocationPermission()
            locationManager.startTrackingLocation()
        }
        .background(
            NavigationLink(
                destination: selectedListing != nil ? AnyView(CurrentBookingView(listingStore: listingStore, listing: selectedListing!)) : AnyView(Text("No available listing")),
                isActive: $isBookingActive
            ) {
                EmptyView()
            }
        )
    }

    private func calculateDistance(for listing: Listing, from userLocation: CLLocationCoordinate2D) -> Double {
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let listingCLLocation = CLLocation(latitude: listing.coordinate.latitude, longitude: listing.coordinate.longitude)
        return userCLLocation.distance(from: listingCLLocation) / 1000 // Convert to km
    }
}