//
//  StoredData.swift
//  PensionVision
//
//  Created by Krystal D on 03/10/2025.
//
import Foundation

class StoredData: ObservableObject {
    static let sharedSD = StoredData()
    @Published private(set) var members: [Member] = []
    @Published private(set) var navs: [NAV] = []
    
    private var docPath: URL {
        let fM = FileManager.default
        if let documentDir = fM.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentDir.appendingPathComponent("PensionVision")
        } else {
            return fM.temporaryDirectory.appendingPathComponent("PensionVision")
            }
        }
    struct CurrentData: Codable {
        let members: [Member]
        let navs: [NAV]
    }
    func loadData() {
        guard let data = try? Data(contentsOf: docPath) else { return }
        guard !data.isEmpty else { return }
        if let decryptedStoredData: CurrentData = CryptoStore.sharedCS.decrypt(encryptedData: data, as: CurrentData.self) {
            DispatchQueue.main.async {
                self.members = decryptedStoredData.members
                self.navs = decryptedStoredData.navs
            }
        }
    }
    func emailFor(nis: String) -> String? {
        let key = nis.trimmingCharacters(in: .whitespacesAndNewlines)
        return members.first(where: { $0.nisNumber == key})?.email
    }
    func verifyEmail(nis: String, matches email: String) -> Bool {
        guard let stored = emailFor(nis: nis) else { return false }
        return stored.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    func saveData() -> String? {
        guard !members.isEmpty || !navs.isEmpty else { return "No data to save" }
        let currentAppData = CurrentData(members: members, navs: navs)
        guard let encryptedData: Data = CryptoStore.sharedCS.encrypt(object: currentAppData)
        else {
            return "Unable to encrypt data"
        }
        do {
            try encryptedData.write(to: docPath, options: .atomic)
            return nil
        } catch {
            return "Unable to save data"
        }
    }
    
    
    func importCSVFile(url: URL) -> String? {
        
        guard let csvText = try? String(contentsOf: url, encoding: .utf8) else {
            return "Unable to read file"
        }
        return importCSV(rawCSVData: csvText)
    }
    func importCSV(rawCSVData: String) -> String? {
        let parsedData = CSVParser.parse(csv: rawCSVData)
        if let error = parsedData.error {
            return error.errorDescription
        }

            self.members = parsedData.members
            self.navs = parsedData.navs
        
        return nil
        }
    }
