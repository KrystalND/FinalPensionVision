//
//  MemberDashboardViewModel.swift
//  PensionVision
//
//  Created by Krystal D on 03/11/2025.
//

import Foundation

class MemberDashboardViewModel {
    func currentValueMD(member: Member) -> Double {
        ForecastEngine.currentValue(member: member)
    }
    
    func totalUnitsMD(member: Member) -> Double {
        var total = 0.0
        
        for held in member.holdings {
            total += held.units
        }
        return total
    }
    func currentPriceMD(member: Member) -> (investment: InvestmentProduct, nav: Double, date: Date)? {
        let storedNAVs = StoredData.sharedSD.navs
        let memFund = ForecastEngine.memberFund(member: member)
        var currentNAV: NAV? = nil
        
        for navRecord in storedNAVs where navRecord.investment == memFund {
            if currentNAV == nil {
                currentNAV = navRecord
            } else if let current = currentNAV, navRecord.date > current.date {
                currentNAV = navRecord
            }
        }
        guard let latest = currentNAV else { return nil }
        return (investment: memFund, nav: latest.nav, date: latest.date)
    }
    func transactionHistoryMD(member: Member) -> [AccountTransactionHistory] {
        let storedNAVs = StoredData.sharedSD.navs
        
        var dailyContribution: [Date: ( ee: Double, er: Double)] = [:]
        
        for contribution in member.contributions {
            let date = contribution.date
            
            if dailyContribution[date] == nil {
                dailyContribution[date] = (ee:0.0, er:0.0)
            }
            if var currentTotals = dailyContribution[date] {
                currentTotals.ee += contribution.employee
                currentTotals.er += contribution.employer
                dailyContribution[date] = currentTotals
            }
        }
        var dailyHoldings: [Date: [Holding]] = [:]
        
        for holding in member.holdings {
            let date = holding.date
            
            if dailyHoldings[date] == nil {
                dailyHoldings[date] = []
            }
            if var existingHoldings = dailyHoldings[date] {
                existingHoldings.append(holding)
                dailyHoldings[date] = existingHoldings
            } else {
                dailyHoldings[date] = [holding]
            }
        }
        var rows: [AccountTransactionHistory] = []
        
        for (currentDate, dailyHoldingsArray) in dailyHoldings {
            let eeAmount = dailyContribution[currentDate]?.ee ?? 0.0
            let erAmount = dailyContribution[currentDate]?.er ?? 0.0
            
            for holding in dailyHoldingsArray {
                let navValue = storedNAVs.first { nav in
                    nav.date == currentDate && nav.investment == holding.investment}?.nav ?? 0.0
                
                let newRow = AccountTransactionHistory(
                    id: UUID(),
                    date: currentDate,
                    employee: eeAmount,
                    employer: erAmount,
                    investment: holding.investment,
                    units: holding.units,
                    nav: navValue
                    )
                rows.append(newRow)
            }
        }
        rows.sort(by: { firstRow, secondRow in
          return firstRow.date > secondRow.date
        })
        return rows
    }
    func totalContributionsMD(member: Member) -> Double {
        ForecastEngine.totalContributions(member: member)
    }
}
