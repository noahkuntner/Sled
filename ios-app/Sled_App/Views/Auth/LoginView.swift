import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @StateObject private var listingStore = ListingStore()
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    // Handle login logic
                    isLoggedIn = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                NavigationLink(destination: SignUpView()) {
                    Text("Create Account")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
                
                // Navigation to SeekerOverview
                NavigationLink(value: isLoggedIn) {
                    EmptyView()
                }
                .navigationDestination(isPresented: $isLoggedIn) {
                    SeekerOverview(listingStore: listingStore, locationManager: locationManager)
                }
            }
            .padding()
        }
    }
}
