import SwiftUI
import Foundation

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var userType: UserType = .seeker
    @State private var accountCreated = false
    @State private var showAlert = false
    @State private var alertMessage = "Account was created"
    @State private var alertColor = Color.green
    @StateObject private var listingStore = ListingStore()
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
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
                registerUser()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text(alertMessage).foregroundColor(alertColor),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage == "Account was created" {
                            accountCreated = true
                        }
                    }
                )
            }
            
            NavigationLink(destination: LoginView(), isActive: $accountCreated) {
                EmptyView()
            }
        }
        .padding()
    }
    
    func registerUser() {
        guard let url = URL(string: "http://localhost:3000/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber,
            "userType": userType.rawValue
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let response = try? JSONDecoder().decode(SignUpResponse.self, from: data) {
                DispatchQueue.main.async {
                    if response.message == "User registered successfully" {
                        showAlert = true
                    } else if response.message == "User already exists" {
                        showAlert = true
                        alertMessage = "User already exists"
                        alertColor = .red
                    }
                }
            }
        }.resume()
    }
}
