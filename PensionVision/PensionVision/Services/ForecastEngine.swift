//
//  ForecastEngine.swift
//  PensionVision
//
//  Created by Krystal D on 28/10/2025.
//
import Foundation

enum ForecastEngine {
    static func currentValue(member: Member) -> Double{
        let storedNAVS = StoredData.sharedSD.navs
        
        func currentNAV(product: InvestmentProduct) -> Double {
            var currentDate: Date? = nil
            var currentNAV: Double = 0.0
            for navRec in storedNAVS {
                if navRec.investment != product {continue}
                
                if let savedDate = currentDate {
                    if navRec.date > savedDate {
                        currentDate = navRec.date
                        currentNAV = navRec.nav
                    }
                } else {
                    currentDate = navRec.date
                    currentNAV = navRec.nav
                }
            }
            return currentNAV
        }
        var totalValue: Double = 0.0
        
        for holding in member.holdings {
            let product = holding.investment
            let units = holding.units
            let price = currentNAV(product: product)
            
            totalValue += units * price
        }
        return totalValue
    }
    static func memberFund(member: Member) -> InvestmentProduct {
        var productTotalUnits: [InvestmentProduct: Double] = [:]
        
        for holding in member.holdings {
            let product = holding.investment
            
            productTotalUnits[product, default: 0.0] += holding.units
        }
            var memberInvestment: InvestmentProduct? = nil
            var totalUnits: Double? = nil
            
            for (product, units) in productTotalUnits {
                if let currentInvestment = totalUnits {
                    if currentInvestment < units {
                        memberInvestment = product
                        totalUnits = units
                    }
                } else {
                    totalUnits = units
                    memberInvestment = product
                }
            }
            return memberInvestment ?? .balance
        }
    
    private static func mostRecentContribution(member: Member) -> Double {
        let lastContribution = member.contributions.last
        return (lastContribution?.employee ?? 0) + (lastContribution?.employer ?? 0)
    }
    static func averageAnnualRate(investment: InvestmentProduct ) -> Double {
        let storedNAVS = StoredData.sharedSD.navs
        let filteredNAVs = storedNAVS.filter { (navRec: NAV) -> Bool in
            return navRec.investment == investment
        }
        let sortedNAVs = filteredNAVs.sorted { (firstNAV: NAV, secondNAV: NAV) -> Bool in
            return firstNAV.date < secondNAV.date
        }
        guard let first = sortedNAVs.first, let last = sortedNAVs.last, first.nav > 0, last.nav > 0
        else {
            return 0
        }
        let yearDifference = Calendar.current.dateComponents([.year], from: first.date, to: last.date).year ?? 1
        let years = max(1, yearDifference)
        let growthRatio = last.nav / first.nav
        let inceptionReturn = pow(growthRatio, 1.0 / Double(years)) - 1.0
        return inceptionReturn
    }
    static func simulateScenario(
        member: Member,
        retirementYear: Int,
        annualIncreasePercentage: Double,
        investment: InvestmentProduct
    ) -> [ProjectionDataPoint] {
        
        let annualCompoundedRate = averageAnnualRate(investment: investment)
        let monthlyCompoundedRate = pow( 1.0 + annualCompoundedRate, 1.0 / 12.0) - 1.0
        let currentYear = Calendar.current.component(.year, from: Date())
        let monthsToRetirement = (retirementYear - currentYear) * 12
        var results: [ProjectionDataPoint] = []
        var currentBalance = ForecastEngine.currentValue(member: member)
        var futureContributions = 0.0
        var monthlyContribution = max(0.0, mostRecentContribution(member: member))
        var monthInYear = 0
        var yearsInSimulation = currentYear + 1
        
        for _ in 0..<monthsToRetirement {
            
            futureContributions += monthlyContribution
            
            currentBalance += monthlyContribution
            
            currentBalance *= (1.0 + monthlyCompoundedRate)
            
            monthInYear += 1
            
            if monthInYear == 12 {
                if let date = Calendar.current.date(from: DateComponents(year: yearsInSimulation, month: 12, day: 31)) {
                    results.append(
                        ProjectionDataPoint(date: date, value: currentBalance, contributed: futureContributions))
                }
                yearsInSimulation += 1
                monthInYear = 0
                monthlyContribution *= (1.0 + annualIncreasePercentage)
            }
        }
        return results
    }
    
    static func totalContributions(member: Member) -> Double {
        var total = 0.0
        for contribution in member.contributions {
            total += contribution.employee + contribution.employer
        }
        return total
    }
    }
