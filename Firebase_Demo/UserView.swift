//
//  UserView.swift
//  Firebase_Demo
//
//  Created by Vladimir Cezar on 2024.11.26.
//

import SwiftUI
import FirebaseAuth

public struct UserView: View {
  var user: User?
  
  public var body: some View {
    VStack {
      Text("Welcome, \(user?.email ?? "User")")
      Button("Logout") {
        try? Auth.auth().signOut()
      }
    }
  }
}

#Preview {
  UserView()
}
