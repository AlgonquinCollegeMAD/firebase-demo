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
    @State private var loginError = false

    public var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Login") {
                Task {
                    let success = await authService.login(email: email, password: password)
                    if !success {
                        loginError = true
                        email = ""
                        password = ""
                        print(authService.authError ?? "Unknown error")
                    }
                }
            }
            Button("Register") {
                Task {
                    do {
                        try await authService.register(email: email, password: password)
                    }
                    catch {
                        registrationError = error
                    }
                }
            }
        }
        .onChange(of: registrationError?.localizedDescription) { _, new in
            showRegistrationErrorMessage = new != nil
        }
        .alert("\(authService.authError ?? "Unknown error")", isPresented: $loginError, actions: {
            Button("Try Again") {}

        })
        .alert("Failed registration", isPresented: $showRegistrationErrorMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(registrationError?.localizedDescription ?? "Unknown error")
        })
        .padding()
    }
}
