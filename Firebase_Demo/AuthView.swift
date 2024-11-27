//
//  AuthView.swift
//  Firebase_Demo
//
//  Created by Vladimir Cezar on 2024.11.26.
//

import Firebase
import SwiftUI

//
//  AuthView.swift
//  Firebase_Demo
//
//  Created by Vladimir Cezar on 2024.11.26.
//

import Firebase
import SwiftUI

public struct AuthView: View {
    @EnvironmentObject private var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var registrationError: Error?
    @State private var showRegistrationErrorMessage = false
    @State private var isLoading = false
    
    public var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .accessibilityLabel("Email Address")
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Password")
            
            if isLoading {
                ProgressView()
            } else {
                HStack {
                    Button("Login") {
                        login()
                    }
                    .disabled(email.isEmpty || password.isEmpty || isLoading)
                    
                    Button("Register") {
                        register()
                    }
                    .disabled(email.isEmpty || password.isEmpty || isLoading)
                }
            }
        }
        .onChange(of: registrationError?.localizedDescription) { new in
            showRegistrationErrorMessage = new != nil
        }
        .alert("Failed Registration", isPresented: $showRegistrationErrorMessage) {
            Button("OK") {}
        } message: {
            Text(registrationError?.localizedDescription ?? "Unknown error")
        }
        .padding()
    }
    
    private func login() {
        isLoading = true
        Task {
            let success = await authService.login(email: email, password: password)
            isLoading = false
            if !success {
                print(authService.authError ?? "Unknown error")
            }
        }
    }
    
    private func register() {
        isLoading = true
        Task {
            do {
                try await authService.register(email: email, password: password)
            } catch {
                registrationError = error
            }
            isLoading = false
        }
    }
}
