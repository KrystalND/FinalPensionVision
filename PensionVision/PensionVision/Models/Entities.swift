//
//  Entities.swift
//  PensionVision
//
//
import Foundation

struct AppUser: Codable, Hashable {
    let role: UserRole
    let identifier: String
}

struct NAV: Codable, Hashable {
    let date: Date
    let investment: InvestmentProduct
    let nav: Double
}

struct Contribution: Codable, Hashable {
    let date: Date
    let employee: Double
    let employer: Double
}

struct Holding: Codable, Hashable {
    let date: Date
    let investment: InvestmentProduct
    let units: Double
}

struct Member: Codable, Hashable {
    let nisNumber: String
    let firstName: String
    let lastName: String
    let dob: Date
    let email: String
    let employer: String
    var contributions: [Contribution]
    var holdings: [Holding]
}
