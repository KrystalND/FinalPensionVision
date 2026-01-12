//
//  AdminImportView.swift
//  PensionVision
//
//  Created by Krystal D on 14/10/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct AdminImportView: View {
    @StateObject private var adminVM = AdminImportViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var importer = false

    
    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Text("PensionVision")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundColor(.white)
                    }
                List {
                    DataStatusSectionView(
                        memberCount: adminVM.memberCount,
                        processedRows: adminVM.processedRows
                    )
                    ActionSectionView(
                        onImport: { importer = true },
                        onSave: { adminVM.saveCSVImport() },
                        
                        onSignOut: {
                            authVM.signOut()
                            dismiss()
                        }
                    )
                    CSVFormatSectionView()
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationBarBackButtonHidden(true)
        
        .fileImporter(isPresented: $importer, allowedContentTypes: [.commaSeparatedText]) { result in
            switch result {
            case .success(let url):
                adminVM.processCSVImport(url: url)
            case .failure:
                adminVM.importFail = "Could not open the file"
                adminVM.importSuccess = nil
            }
            
        }
        .alert("Import Error", isPresented: Binding(
            get: { adminVM.importFail != nil },
            set: { if !$0 { adminVM.importFail = nil } }
        )
        ){
            Button("OK") {adminVM.importFail=nil}
        } message: {
            Text(adminVM.importFail ?? "")
        }
        .alert("Finished", isPresented: Binding(
            get: { adminVM.importSuccess != nil },
            set: { if !$0 { adminVM.importSuccess = nil } }
        )
        ){
            Button("OK") {adminVM.importSuccess=nil}
        } message: {
            Text(adminVM.importSuccess ?? "")
        }
               
    }
                private struct DataStatusSectionView: View {
                    let memberCount: Int
                    let processedRows: Int
                    
                    var body: some View {
                        Section {
                            HStack {
                                ZStack{
                                    Image(systemName: "person.3.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                }
                                VStack(alignment: .leading){
                                    Text("Members")
                                        .font(.title3.weight(.bold))
                                        .foregroundColor(.black.opacity(0.5))
                                    
                                    Text("\(memberCount)")
                                        .foregroundColor(.black.opacity(0.5))
                                        .font(.system(size: 20, weight:.bold))
                                }
                            }
                            .foregroundStyle(.black.opacity(1))
                            .listRowBackground(Color.white.opacity(0.7))
                            
                            HStack {
                                ZStack{
                                    Image(systemName: "tablecells.fill")
                                        .foregroundColor(.purple)
                                        .font(.system(size: 33))
                                }
                                VStack(alignment: .leading) {
                                    Text("Processed Rows")
                                        .font(.title3.weight(.bold))
                                        .foregroundColor(.black.opacity(0.5))
                                    Text("\(processedRows)")
                                        .foregroundColor(.black.opacity(0.5))
                                        .font(.system(size: 20, weight:.bold))
                                }
                            }
                            .foregroundStyle(.black.opacity(1))
                            .listRowBackground(Color.white.opacity(0.7))
                        }
                        header: {
                            Text("Data Status")
                                .foregroundStyle(.white)
                                .font(.system(size: 22, weight: .bold))
                        }
                    }
                    
                }
    private struct ActionSectionView: View {
        let onImport: () -> Void
        let onSave: () -> Void
        let onSignOut: () -> Void
        
        var body: some View {
            Section {
                Button(action: onImport) {
                    Label("Import CSV", systemImage: "folder")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                }
                Button(action: onSave) {
                    Label("Save Data", systemImage: "square.and.arrow.down")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
                Button(action: onSignOut) {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                }
            }
            header: {
                Text("Actions")
                    .foregroundStyle(.white)
                    .font(.system(size: 22, weight: .bold))
            } footer: {
                Text("Tip: Tap **Save Data** after successfully importing.")
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.5))
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundStyle(.black.opacity(1))
            .listRowBackground(Color.white.opacity(0.7))
        }
    }
                        private struct CSVFormatSectionView: View {
                            var body: some View {
                                Section {
                                    HStack {
                                        ZStack{
                                            Image(systemName: "list.bullet")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 33))
                                        }
                                        VStack(alignment: .leading){
                                            Text("nis, first_name, last_name, dob, email, employer, date, eeamt, eramt, investment, units, nav")
                                                .foregroundColor(.black.opacity(0.5))
                                                .font(.system(size: 18))
                                        }
                                    }
                                    .foregroundStyle(.black.opacity(1))
                                    .listRowBackground(Color.white.opacity(0.7))
                                }
                                header: {
                                    Text("CSV Format")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 22, weight: .bold))
                                }
                                footer: {
                                    Text("Date must be formatted as YYYY-MM-DD")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black.opacity(0.5))
                                        .font(.system(size: 13, weight: .bold))
                                }
                    }
                        }
}
                    
#Preview {
    AdminImportView()
}
