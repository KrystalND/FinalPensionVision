//
//  ScenarioPlannerViewModel.swift
//  PensionVision
//
//  Created by Krystal D on 09/11/2025.
//
import Foundation

class ScenarioPlannerViewModel: ObservableObject {
    
    @Published var retirementYear: Int
    @Published var annualIncreasePercentage: Double
    @Published var changeInvestment: InvestmentProduct
    
    @Published var forecast: [ProjectionDataPoint] = []
    @Published var estimatedFutureValue: Double = 0
    @Published var totalContributedAtRetirement: Double? = nil
    @Published var currentNAV: Double? = nil
    @Published var currentNAVDate: Date? = nil
    @Published var annualReturnRate: Double = 0
    
    private let member: Member
    
    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    var currentValueNow: Double {
        ForecastEngine.currentValue(
            member: member)
    }
    
    var currentNAVYear: Int {
        let storedNAVs = StoredData.sharedSD.navs
        let latestNAVDAte = storedNAVs.map { $0.date }.max()
        
        if let currentNAVDate = latestNAVDAte {
            return Calendar.current.component(.year, from: currentNAVDate)
        } else {
            return currentYear
        }
    }
    init(member: Member) {
        self.member = member
        self.retirementYear = Calendar.current.component(.year, from: Date()) + 1
        self.annualIncreasePercentage = 0
        self.changeInvestment = ForecastEngine.memberFund(member: member)
    }
    
    func updatedAnnualRate() {
        annualReturnRate = ForecastEngine.averageAnnualRate(investment: changeInvestment) * 100
    }
    
    func updatedCurrentPrice() {
        let storedNAVs = StoredData.sharedSD.navs
        
        let navsForSelectedFund = storedNAVs.filter {
            nav in nav.investment == changeInvestment
        }
        
        let currentNAVRecord = navsForSelectedFund.max { first, second in first.date < second.date
        }
        currentNAV = currentNAVRecord?.nav
        currentNAVDate = currentNAVRecord?.date
    }
    
    func recompute() {
        guard retirementYear > currentYear else {
            forecast = []
            estimatedFutureValue = 0
            totalContributedAtRetirement = nil
            return
        }
        let dataPoints = ForecastEngine.simulateScenario(
            member: member,
            retirementYear: retirementYear,
            annualIncreasePercentage: annualIncreasePercentage,
            investment: changeInvestment
        )
        forecast = dataPoints
        estimatedFutureValue = dataPoints.last?.value ?? 0
        
        let historicalContributions = ForecastEngine.totalContributions(member: member)
        let projectedContributions = dataPoints.last?.contributed ?? 0
        totalContributedAtRetirement = historicalContributions + projectedContributions
    }
    
}
