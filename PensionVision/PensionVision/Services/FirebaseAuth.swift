//
//  FirebaseAuth.swift
//  PensionVision
//
//  Created by Krystal D on 13/10/2025.
//

import Foundation
import Combine
import FirebaseAuth


class FirebaseAuth {
    private let currentUser = CurrentValueSubject<AppUser?, Never>(nil)
    var userPublisher: AnyPublisher<AppUser?, Never> {
        currentUser.eraseToAnyPublisher()
    }
    private func sendVerification(user: User) async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            user.sendEmailVerification { error in
                continuation.resume(returning: ())
            }
            
        }
    }
    func signOut() {
        try? Auth.auth().signOut()
        currentUser.send(nil)
    }
    func signInMember(nis: String, password: String) async -> String? {
        guard let email = StoredData.sharedSD.emailFor(nis: nis) else {
            return "NIS not found."
        }
        do {
            let firebaseResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = firebaseResult.user
            if !user.isEmailVerified {
                await sendVerification(user: user)
                try? Auth.auth().signOut()
                return "Please verify your account via the email link we sent."
            }
            currentUser.send(.init(role: .planMember, identifier: nis))
            return nil
        }
        catch {
            return "Unable to sign in. Please try again or contact your pension administrator."
        }
    }
    func signInAdmin(email: String, password: String) async -> String? {
        guard email.lowercased().hasSuffix(AppConfig.adminEmailDomain.lowercased()) else {
            return "Please use an admin email."
        }
        do {
            let firebaseResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = firebaseResult.user
            if !user.isEmailVerified {
                await sendVerification(user: user)
                try? Auth.auth().signOut()
                return "Please verify your account via the email link we sent."
            }
            currentUser.send(.init(role: .admin, identifier: firebaseResult.user.email ?? email))
            return nil
        }
                                           catch {
            return "Unable to sign in. Check your password, confirm your admin email is verified, ensure your account exists, and check your network, then try again."
        }
                                           
    }
    func signUpMember(email: String, password: String) async -> String? {
        do {
            let firebaseResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = firebaseResult.user
                await sendVerification(user: user)
                try? Auth.auth().signOut()
                return nil
        } catch {
            return "Unable to sign up. Check your email format, ensure your email is not already in use, and check your network, then try again."
        }
    }
    func signUpAdmin(email: String, password: String) async -> String? {
        guard email.lowercased().hasSuffix(AppConfig.adminEmailDomain.lowercased()) else {
            return "Please use an admin email."
        }
        do {
            let firebaseResult = try await Auth.auth().createUser(withEmail: email, password: password)
            await sendVerification(user: firebaseResult.user)
            try? Auth.auth().signOut()
            return nil
        }
        catch {
            return "Unable to sign up. Check your email format, ensure your email is not already in use, and check your network, then try again."
        }
    }
    private func sendPasswordReset(email: String) async -> String? {
        await withCheckedContinuation { continuation in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                let errorMessage = "Unable to send resent link. Check your credentials and try again."
                guard error == nil else {
                    continuation.resume(returning: errorMessage)
                    return
                }
                continuation.resume(returning: nil)
            }
        }
    }
    func resetMemberPassword(nis: String) async -> String? {
        guard let email = StoredData.sharedSD.emailFor(nis: nis) else {
            return "NIS not found."
        }
        return await sendPasswordReset(email: email)
    }
    
    func resetAdminPassword(email: String) async -> String? {
        return await sendPasswordReset(email: email)
    }
}
