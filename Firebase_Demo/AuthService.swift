//
//  AuthService.swift
//  Firebase_Demo
//
//  Created by Vladimir Cezar on 2024.11.26.
//
import Foundation
import FirebaseAuth

@MainActor
class AuthService: ObservableObject {
  @Published var user: User?
  @Published var isSignedIn: Bool = false
  @Published var authError: String?
  
  static let shared = AuthService()
  
  private init() {
    self.user = Auth.auth().currentUser
    self.isSignedIn = self.user != nil
    _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
      self?.user = user
      self?.isSignedIn = user != nil
    }
  }
  
  func register(email: String, password: String) async throws {
    let result = try await Auth.auth().createUser(withEmail: email, password: password)
    self.user = result.user
    self.isSignedIn = true
  }
  
  func login(email: String, password: String) async -> Bool {
    do {
      let result = try await Auth.auth().signIn(withEmail: email, password: password)
      self.user = result.user
      self.isSignedIn = true
      return true
    } catch {
      self.authError = error.localizedDescription
      return false
    }
  }
  
  func logout() throws {
    try Auth.auth().signOut()
    self.user = nil
    self.isSignedIn = false
  }
}
