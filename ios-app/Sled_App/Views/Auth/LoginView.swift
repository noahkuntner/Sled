import SwiftUI
import Foundation

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
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    loginUser()
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
                
                NavigationLink(destination: SeekerOverview(listingStore: listingStore, locationManager: locationManager), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Email and password cannot be empty")
            return
        }
        
        print("loginUser called")
        guard let url = URL(string: "http://localhost:3000/login") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    showAlert(message: "Network error")
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            
            if let response = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {
                    if let token = response.token {
                        print("Login successful")
                        isLoggedIn = true
                    } else {
                        showAlert(message: "Invalid credentials")
                    }
                }
            } else if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                      let message = errorResponse["message"] {
                DispatchQueue.main.async {
                    showAlert(message: message)
                }
            }
        }.resume()
    }
    
    func showAlert(message: String) {
        // Implement your alert logic here
        print("Alert: \(message)")
    }
}
