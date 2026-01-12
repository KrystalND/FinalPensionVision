//
//  PensionVisionApp.swift
//  PensionVision
//
//

import SwiftUI
import FirebaseCore

@main
struct PensionVisionApp: App {
    
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var storedData = StoredData.sharedSD
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(authVM)
                .environmentObject(storedData)
                .onAppear {
                    storedData.loadData()
                }
            }
        }
    }
