//
//  CryptoStore.swift
//  PensionVision
//
//  Created by Krystal D on 11/10/2025.
//
import Foundation
import CryptoKit

class CryptoStore {
    static let sharedCS = CryptoStore()
    private let globalEncryptionKey = "global.encryption.key"
    private var symKey: SymmetricKey
    
    private init() {
        if let data = SecretsHandler.load(identifier: globalEncryptionKey) {
            self.symKey = SymmetricKey(data: data)
        } else {
            let newSymKey = SymmetricKey(size: .bits256)
            self.symKey = newSymKey
            SecretsHandler.save(identifier: globalEncryptionKey, data: newSymKey.withUnsafeBytes { Data($0) })
            }
            
        }
    func encrypt<ObjectType: Codable>(object: ObjectType) -> Data? {
        guard
            let encodedObject = try? JSONEncoder().encode(object),
            let encryptedData = try? AES.GCM.seal(encodedObject, using: symKey).combined
        else { return nil }
        return encryptedData
            
        }
    func decrypt<ObjectType: Codable>(encryptedData: Data, as: ObjectType.Type) -> ObjectType? {
        guard
            let sealedBox = try? AES.GCM.SealedBox(combined: encryptedData),
            let decryptedData = try? AES.GCM.open(sealedBox, using: symKey),
            let decryptedDataObject = try? JSONDecoder().decode(ObjectType.self, from: decryptedData)
        else {
            return nil
        }
        return decryptedDataObject
        }
    }
