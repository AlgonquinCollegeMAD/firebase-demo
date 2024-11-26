//
//  AuthView.swift
//  Firebase_Demo
//
//  Created by Vladimir Cezar on 2024.11.26.
//

import SwiftUI
import Firebase

struct RootView: View {
  @EnvironmentObject var authService: AuthService
  
  var body: some View {
    if authService.isSignedIn {
      UserView(user: authService.user)
    } else {
      AuthView()
    }
  }
}

#Preview {
  RootView()
}
