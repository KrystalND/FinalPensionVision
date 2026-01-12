//
//  Enums.swift
//  PensionVision
//
//
import Foundation

enum UserRole: String, Codable {
    case admin
    case planMember
}

enum InvestmentProduct: String, Codable, CaseIterable {
    case growth
    case balance
    case steady
    
    var realName: String {
        switch self {
        case .growth: return "Growth Accelerator"
        case .balance: return "Balance Select"
        case .steady: return "Steady Classic"
        }
    }
}

enum CSVError {
    case incorrectTitle(correctTitle: [String], inputTitle: [String])
    case empty
    case errorRow(row: Int, issue: String)
    
    var errorDescription: String {
        switch self {
        case let .incorrectTitle(correct, input):
            return "Incorrect CSV title. Correct title: \(correct.joined(separator: ", ")). Input title: \(input.joined(separator: ", "))."
        case .empty:
            return "CSV is empty."
        case let .errorRow(row, issue):
            return "Row Error Number: \(row) - Issue: \(issue)."
        }
    }
}
