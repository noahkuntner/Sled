import SwiftUI

struct CurrentBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var listingStore: ListingStore
    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var showConfirmation = false

    var listing: Listing

    var body: some View {
        VStack {
            Text("Book \(listing.activity)")
                .font(.largeTitle)
                .padding()

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: confirmBooking) {
                Text("Confirm Booking")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if showConfirmation {
                Text("Booking Confirmed!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .transition(.scale)
                    .animation(.easeInOut, value: showConfirmation)
            }

            Spacer()
        }
        .padding()
    }

    private func confirmBooking() {
        let newBooking = Booking(name: name, email: email, phoneNumber: phoneNumber, listing: listing)
        listingStore.bookings.append(newBooking)

        withAnimation {
            showConfirmation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct Booking: Codable {
    var name: String
    var email: String
    var phoneNumber: String
    var listing: Listing
}
