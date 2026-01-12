//
//  AccountTransactionHistory.swift
//  PensionVision
//
//  Created by Krystal D on 07/11/2025.
//
import Foundation

struct AccountTransactionHistory: Identifiable {
    let id: UUID
    let date: Date
    let employee: Double
    let employer: Double
    let investment: InvestmentProduct
    let units: Double
    let nav: Double
}
