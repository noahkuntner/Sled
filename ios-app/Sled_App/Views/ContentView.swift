import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var listingStore = ListingStore()
    @StateObject private var locationManager = LocationManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Welcome to the Activity Booking App")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: SignUpView()) {
                    Text("Create Account")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
