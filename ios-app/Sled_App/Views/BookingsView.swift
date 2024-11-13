import SwiftUI

struct BookingsView: View {
    @ObservedObject var listingStore: ListingStore
    @State private var selectedSegment = 0

    var upcomingBookings: [Booking] {
        listingStore.bookings
            .filter { 
                let combinedDateTime = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: $0.listing.startTime),
                                                             minute: Calendar.current.component(.minute, from: $0.listing.startTime),
                                                             second: 0,
                                                             of: $0.listing.date) ?? $0.listing.startTime
                return combinedDateTime >= Date()
            }
            .sorted { 
                let date1 = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: $0.listing.startTime),
                                                  minute: Calendar.current.component(.minute, from: $0.listing.startTime),
                                                  second: 0,
                                                  of: $0.listing.date) ?? $0.listing.startTime
                let date2 = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: $1.listing.startTime),
                                                  minute: Calendar.current.component(.minute, from: $1.listing.startTime),
                                                  second: 0,
                                                  of: $1.listing.date) ?? $1.listing.startTime
                return date1 < date2
            }
    }

    var pastBookings: [Booking] {
        listingStore.bookings
            .filter { 
                let combinedDateTime = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: $0.listing.startTime),
                                                             minute: Calendar.current.component(.minute, from: $0.listing.startTime),
                                                             second: 0,
                                                             of: $0.listing.date) ?? $0.listing.startTime
                return combinedDateTime < Date()
            }
            .sorted { 
                let date1 = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: $0.listing.startTime),
                                                  minute: Calendar.current.component(.minute, from: $0.listing.startTime),
                                                  second: 0,
                                                  of: $0.listing.date) ?? $0.listing.startTime
                let date2 = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: $1.listing.startTime),
                                                  minute: Calendar.current.component(.minute, from: $1.listing.startTime),
                                                  second: 0,
                                                  of: $1.listing.date) ?? $1.listing.startTime
                return date1 > date2
            }
    }

    var body: some View {
        VStack { 
            Picker("Bookings", selection: $selectedSegment) {
                Text("Upcoming Bookings").tag(0)
                Text("Past Bookings").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(selectedSegment == 0 ? upcomingBookings : pastBookings, id: \.listing.id) { booking in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(booking.listing.title)
                                    .font(.headline)
                                Spacer()
                                Text(booking.listing.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 2)

                            HStack {
                                Text("\(booking.listing.startTime, style: .time) - \(booking.listing.endTime, style: .time)")
                                Spacer()
                                Text("\(booking.listing.pricePerPerson) \(booking.listing.currency) per person")
                            }
                            .font(.subheadline)
                            .padding(.bottom, 2)

                            HStack {
                                Text("Free Slots: \(booking.listing.maxUsers)")
                                Spacer()
                                Text("Location: \(booking.listing.location)")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)

                            HStack {
                                ActivityIconProvider.activityIcon(for: booking.listing.activity)
                                Text(booking.listing.activity)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.top, 5)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 40)
                    }
                }
            }
        }
        .navigationTitle("Your Bookings")
        .onAppear {
            // Trigger sorting logic
            _ = upcomingBookings
            _ = pastBookings
        }
    }
}
