//
//  AdminImportViewModel.swift
//  PensionVision
//
//  Created by Krystal D on 13/10/2025.
//

import Foundation
class AdminImportViewModel: ObservableObject {
    @Published var importSuccess: String? = nil
    @Published var importFail: String? = nil
    
    private let store = StoredData.sharedSD
    private var importedData = false
    
    
    var memberCount: Int {
        store.members.count
    }
    var processedRows: Int {
        store.navs.count
    }
    
    private func resetMessage() {
        importSuccess = nil
        importFail = nil
    }
    func processCSVImport(url:URL) {
        resetMessage()
        let csvMessageResult = store.importCSVFile(url: url)
        if let errorMessage = csvMessageResult{
            importFail = errorMessage
            importedData = false
        } else {
            importSuccess = "CSV Import Successful"
            importedData = true
        }
    }
    func saveCSVImport() {
        resetMessage()
        if !importedData {
            importFail = "No Import Data"
            return
        }
        if let errorMessage = store.saveData(){
            importFail = errorMessage
        } else {
            importSuccess = "Save Successful"
            importedData = false
        }
    }
}
