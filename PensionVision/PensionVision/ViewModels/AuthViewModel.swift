//
//  AuthViewModel.swift
//  PensionVision
//
//  Created by Krystal D on 20/10/2025.
//
import Foundation
import Combine
@MainActor

class AuthViewModel: ObservableObject {
    @Published private(set) var user: AppUser? = nil
    @Published var errorMessage: String? = nil
    private var cancellable: AnyCancellable?
    private let firebase = FirebaseAuth()
    
    init() {
        cancellable = firebase.userPublisher
            .receive(on: RunLoop.main)
            .sink { user in self.user = user}
    }
    
    func signInMemberVM(nis: String, password: String) async {
        errorMessage = nil
        guard !nis.isEmpty else {
            errorMessage = "Enter NIS"
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Enter password"
            return
        }
        let signInStatusMem = await firebase.signInMember(nis: nis, password: password)
        if let signInStatusMem { errorMessage = signInStatusMem }
    }
    func signInAdminVM(email: String, password: String, systemKey: String) async {
        errorMessage = nil
        guard !email.isEmpty else {
            errorMessage = "Enter email"
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Enter password"
            return
        }
        guard AppConfig.isValidAdminKey(input: systemKey) else {
            errorMessage = "Invalid System Key"
            return
        }
        let signInStatusAdmin = await firebase.signInAdmin(email: email, password: password)
        if let signInStatusAdmin { errorMessage = signInStatusAdmin }
    }
    
    func signOut() { firebase.signOut()}
    
    func signUpMemberVM(nis: String, email: String, password: String, confirmPassword: String) async -> String? {
        errorMessage = nil
        
        if nis.isEmpty  {
            let message = "NIS is required."
            errorMessage = message
            return message
        }
        if !StoredData.sharedSD.verifyEmail(nis: nis, matches: email) {
            let message = "Email does not match our records for this NIS."
            errorMessage = message
            return message
        }
        if password.count < 8 {
            let message = "Password must be at least 8 characters long."
            errorMessage = message
            return message
        }
        if password != confirmPassword {
            let message = "Passwords do not match."
            errorMessage = message
            return message
        }
        let signUpResult = await firebase.signUpMember(email: email, password: password)
        if let signUpError = signUpResult {
            errorMessage = signUpError
            return signUpError
        }
        errorMessage = "Check your email for a verification link."
        return nil
    }
    func signUpAdminVM(email: String, password: String, confirmPassword: String, adminSystemKey: String) async -> String? {
        errorMessage = nil
        
        if email.isEmpty  {
            let message = "Email is required."
            errorMessage = message
            return message
        }
        if adminSystemKey.isEmpty  {
            let message = "System Key is required."
            errorMessage = message
            return message
        }
        if !AppConfig.isValidAdminKey(input: adminSystemKey) {
            let message = "Invalid System Key"
            errorMessage = message
            return message
        }
        if password.count < 8 {
            let message = "Password must be at least 8 characters long."
            errorMessage = message
            return message
        }
        if password != confirmPassword {
            let message = "Passwords do not match."
            errorMessage = message
            return message
        }
        let serviceResult = await firebase.signUpAdmin(email: email, password: password)
        if let serviceError = serviceResult {
            errorMessage = serviceError
            return serviceError
        }
        errorMessage = "Check your email for a verification link."
        return nil
    }
    
    func resetMemberPasswordVM(nis: String) async {
        errorMessage = nil
        
        let result = await firebase.resetMemberPassword(nis: nis)
        
        if let result {
            errorMessage = result
        } else {
            errorMessage = "Check your email for a reset link."
        }
    }
    func resetAdminPasswordVM(email: String, systemKey: String) async {
        errorMessage = nil
        
        guard email.lowercased().hasSuffix(AppConfig.adminEmailDomain.lowercased()) else {
            errorMessage = "Please enter a valid admin email."
            return
        }
        guard AppConfig.isValidAdminKey(input: systemKey) else {
            errorMessage = "Invalid system key."
            return
        }
        let result = await firebase.resetAdminPassword(email: email)
        
        if let result {
            errorMessage = result
        } else {
            errorMessage = "A reset link has been sent if this email exists."
        }
    }
}
