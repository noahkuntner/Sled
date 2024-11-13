// HomeScreen.swift
import SwiftUI

struct SeekerOverview: View {
    @ObservedObject var listingStore: ListingStore
    @ObservedObject var locationManager: LocationManager
    @State private var searchQuery = ""
    @State private var selectedDate = Date()
    @State private var selectedActivity = "All"
    @State private var selectedTab: Tab = .home
    @State private var selectedListing: Listing?


    enum Tab {
        case home, bookings, payment, messages, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                VStack {
                    Text("Search for Activities")
                        .font(.headline)
                        .padding()

                    HStack {
                        TextField("Search", text: $searchQuery)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Picker("Select Activity", selection: $selectedActivity) {
                            ForEach(activities, id: \.self) { activity in
                                Text(activity)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: 100)
                    }
                    .padding()

                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .padding()

                    List {
                        SearchResultView(listings: filteredResults, locationManager: locationManager, listingStore: listingStore)
                    }

                    NavigationLink(destination: CreateListing(listingStore: listingStore)) {
                        Text("Create Listing")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
                .padding()
                .navigationTitle("Search for Activities")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(Tab.home)

            NavigationStack {
                BookingsView(listingStore: listingStore)
            }
            .tabItem {
                Label("Bookings", systemImage: "calendar")
            }
            .tag(Tab.bookings)

            NavigationStack {
                Text("Payment View")
                // Add your payment content here
            }
            .tabItem {
                Label("Payment", systemImage: "creditcard")
            }
            .tag(Tab.payment)

            NavigationStack {
                Text("Messages View")
                // Add your messages content here
            }
            .tabItem {
                Label("Messages", systemImage: "message")
            }
            .tag(Tab.messages)

            NavigationStack {
                Text("Settings View")
                // Add your settings content here
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(Tab.settings)
        }
    }

    var filteredResults: [Listing] {
        listingStore.listings.filter { listing in
            (searchQuery.isEmpty || listing.activity.contains(searchQuery)) &&
            (selectedActivity == "All" || listing.activity == selectedActivity) &&
            Calendar.current.isDate(listing.date, inSameDayAs: selectedDate)
        }
    }
}