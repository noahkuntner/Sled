import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var userType: UserType = .seeker
    @State private var accountCreated = false
    @StateObject private var listingStore = ListingStore()
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Telephone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker("User Type", selection: $userType) {
                Text("Guide").tag(UserType.guide)
                Text("Seeker").tag(UserType.seeker)
                Text("Both").tag(UserType.both)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Create Account") {
                accountCreated = true
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            NavigationLink(destination: SeekerOverview(listingStore: listingStore, locationManager: locationManager), isActive: $accountCreated) {
                EmptyView()
            }
        }
        .padding()
    }
}
