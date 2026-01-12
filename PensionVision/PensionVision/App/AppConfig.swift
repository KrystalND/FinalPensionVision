//
//  AppConfig.swift
//  PensionVision
//
//
import Foundation
import CryptoKit

enum AppConfig {
    static let useFirebaseAuth = true
    
    static let adminEmailDomain = "@gmail.com"
    
    static let adminSystemKeyHashHex = "a369b1e0b8cb21b9392c1601ec7fb086d48c382f3a96b82796d568c18da5feb8"
    static let aiAPIKey: String = ""
    static let aiEndpoint: String = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"
    
    static func isValidAdminKey(input: String) -> Bool {
        let keyData = Data(input.utf8)
        let hashKeyData = SHA256.hash(data: keyData)
        let hex = hashKeyData.map { String(format: "%02x", $0) }.joined()
        
        return sameTime(entry: hex, adminKey: adminSystemKeyHashHex)
    }

    private static func sameTime(entry: String, adminKey: String) -> Bool {
        let ent = Array(entry.utf8)
        let key = Array(adminKey.utf8)
        
        var diff = (0 as UInt8)
        
        for i in 0..<ent.count { diff |= ent[i] ^ key[i]}
        
        return diff == 0
        }
    }

