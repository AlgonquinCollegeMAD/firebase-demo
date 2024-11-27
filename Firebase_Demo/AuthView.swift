//
//  AuthView.swift
//  Firebase_Demo
//
//  Created by Vladimir Cezar on 2024.11.26.
//

import SwiftUI
import Firebase

public struct AuthView: View {
  @EnvironmentObject private var authService: AuthService
  @State private var email = ""
  @State private var password = ""
  @State private var registrationError: Error?
  @State private var showRegistrationErrorMessage = false
    @State private var isLoading = false
  
  public var body: some View {
      VStack {
          if isLoading {
              ProgressView()
          } else {
              TextField("Email", text: $email)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
              SecureField("Password", text: $password)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
              
              Button("Login") {
                  isLoading = true
                  Task {
                      let success = await authService.login(email: email, password: password)
                      if !success {
                          print(authService.authError ?? "Unknown error")
                      }
                  }
              }
              .disabled(isLoading)
              
              Button("Register") {
                  isLoading = true
                  Task {
                      do {
                          try await authService.register(email: email, password: password)
                      }
                      catch {
                          registrationError = error
                      }
                      isLoading = false
                  }
              }
              .disabled(isLoading)
          }
      }
    .onChange(of: registrationError?.localizedDescription) { old, new in
      showRegistrationErrorMessage = new != nil
    }
    .alert("Failed registration", isPresented: $showRegistrationErrorMessage, actions: {
      Button("OK") {}
    }, message: {
      Text(registrationError?.localizedDescription ?? "Unknown error")
    })
    .padding()
  }
}
