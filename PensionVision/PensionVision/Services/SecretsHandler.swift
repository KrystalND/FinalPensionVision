//
//  SecretsHandler.swift
//  PensionVision
//
//  Created by Krystal D on 10/10/2025.
//
import Foundation
import Security

enum SecretsHandler {
    private static let devID = "com.krystal.PensionVision"
    
    static func save(identifier: String, data: Data) {
        let instructionsSave: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecAttrService as String: devID,
            kSecAttrSynchronizable as String: kCFBooleanFalse as Any
        ]
        let statusSave = SecItemUpdate(instructionsSave as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        if statusSave == errSecItemNotFound {
            var add = instructionsSave
            add[kSecValueData as String] = data
            SecItemAdd(add as CFDictionary, nil)
        }
    }
    static func load(identifier: String) -> Data? {
        let instructionsLoad: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecAttrService as String: devID,
            kSecAttrSynchronizable as String: kCFBooleanFalse as Any,
            kSecReturnData as String: kCFBooleanTrue as Any
            
        ]
        var item: CFTypeRef?
        let statusLoad = SecItemCopyMatching(instructionsLoad as CFDictionary, &item)
        guard statusLoad == errSecSuccess else { return nil }
        return item as? Data
    }

}
