// CreateListing.swift
import SwiftUI
import CoreLocation
import MapKit

struct CreateListing: View {
    @ObservedObject var listingStore: ListingStore
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var selectedActivity = "Tennis"
    @State private var tempSelectedActivity = "Tennis" // Temporary state variable
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
    @State private var location = ""
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var pricePerPerson = 0
    @State private var selectedCurrency = "USD"
    @State private var selectedSlots = 1
    @State private var showConfirmation = false
    @State private var errorMessage = ""
    @State private var searchQuery = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198), // Singapore
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var showSearchResults = false

    let currencies = ["USD", "SGD", "EUR", "GBP", "JPY", "AUD", "CAD", "CHF", "CNY", "SEK", "NZD",]
    let slots = Array(1...50)

    let standardFontSize: CGFloat = 16

    var body: some View {
        ScrollView {
            VStack {
                Text("Create a Listing")
                    .font(.headline)
                    .padding()

                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                HStack {
                    Text("Activity:")
                    Picker("Select Activity", selection: $tempSelectedActivity) {
                        ForEach(activities, id: \.self) { activity in
                            Text(activity)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: tempSelectedActivity) { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            if newValue == tempSelectedActivity {
                                selectedActivity = newValue
                            }
                        }
                    }
                }
                .padding()

                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .padding()

                HStack {
                    DatePicker("From", selection: $startTime, displayedComponents: .hourAndMinute)
                        .onChange(of: startTime) { newValue in
                            endTime = Calendar.current.date(byAdding: .minute, value: 30, to: newValue) ?? newValue
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                    DatePicker("To", selection: $endTime, displayedComponents: .hourAndMinute)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.leading, 10)
                }
                .padding()

                TextField("Search Location", text: $searchQuery, onCommit: performSearch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if showSearchResults {
                    List(searchResults, id: \.self) { item in
                        Button(action: {
                            location = item.placemark.name ?? ""
                            coordinate = item.placemark.coordinate
                            searchQuery = location
                            searchResults = []
                            showSearchResults = false
                        }) {
                            VStack(alignment: .leading) {
                                Text(item.placemark.name ?? "")
                                    .font(.headline)
                                Text(item.placemark.title ?? "")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .frame(height: 200)
                }

                VStack(alignment: .leading) {
                    HStack {
                        Text("Price:")
                            .font(.system(size: standardFontSize))
                            .frame(width: 50, alignment: .leading)
                        Picker("Select Price", selection: $pricePerPerson) {
                            ForEach(0...1000, id: \.self) { price in
                                Text("\(price)")
                                    .font(.system(size: standardFontSize))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 200, height: 80)

                        Picker("Currency", selection: $selectedCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency)
                                    .font(.system(size: standardFontSize))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.leading, 16)

                    HStack {
                        Text("Slots:")
                            .font(.system(size: standardFontSize))
                            .frame(width: 50, alignment: .leading)
                        Picker("Select Slots", selection: $selectedSlots) {
                            ForEach(slots, id: \.self) { slot in
                                Text("\(slot)")
                                    .font(.system(size: standardFontSize))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 200, height: 80)
                    }
                    .padding(.leading, 16)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: createListing) {
                    Text("Create Listing")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                if showConfirmation {
                    Text("Activity Created!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .transition(.scale)
                }
            }
        }
        .padding()
    }

    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                searchResults = response.mapItems
                showSearchResults = true
            }
        }
    }

    private func createListing() {
        if title.isEmpty {
            errorMessage = "Please give a title to your listing."
        } else if location.isEmpty || coordinate == nil {
            errorMessage = "Please select a location for your listing."
        } else {
            let newListing = Listing(
                title: title,
                activity: selectedActivity,
                date: date,
                startTime: startTime,
                endTime: endTime,
                location: location,
                coordinate: coordinate!,
                pricePerPerson: String(pricePerPerson),
                currency: selectedCurrency,
                maxUsers: selectedSlots
            )
            listingStore.listings.append(newListing)
            clearFields()
            withAnimation {
                showConfirmation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showConfirmation = false
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    private func clearFields() {
        title = ""
        location = ""
        pricePerPerson = 0
        selectedSlots = 1
        errorMessage = ""
    }
}
