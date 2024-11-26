//
//  AuthView.swift
//  Firebase_Demo
//
//  Created by Vladimir Cezar on 2024.11.26.
//

import SwiftUI
import Firebase

struct AuthView: View {
  @StateObject private var authService = AuthService.shared
  @State private var email = ""
  @State private var password = ""
  
  var body: some View {
    VStack {
      if authService.isSignedIn {
        Text("Welcome, \(authService.user?.email ?? "User")")
        Button("Logout") {
          Task {
            await authService.logout()
          }
        }
      } else {
        TextField("Email", text: $email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        SecureField("Password", text: $password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button("Login") {
          Task {
            let success = await authService.login(email: email, password: password)
            if !success {
              print(authService.authError ?? "Unknown error")
            }
          }
        }
        Button("Register") {
          Task {
            let success = await authService.register(email: email, password: password)
            if !success {
              print(authService.authError ?? "Unknown error")
            }
          }
        }
      }
    }
    .padding()
  }
}

#Preview {
  AuthView()
}
