//
//  MemberDashboardView.swift
//  PensionVision
//
//  Created by Krystal D on 22/10/2025.
//
import SwiftUI
import Combine

struct MemberDashboardView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var storedData: StoredData
    @Environment(\.dismiss) private var dismiss
    
    private let memDashVM = MemberDashboardViewModel()
    let nis: String
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack (alignment: .leading, spacing: 12) {
                HStack {
                    Spacer()
                    Text("Member Dashboard")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold, design: .default))
                    Spacer()
                }
                if let mem = storedData.members.first( where: { $0.nisNumber == nis}) {
                    let name: String = "\(mem.firstName) \(mem.lastName)".capitalized
                    let employer = mem.employer.capitalized
                    let curVal = memDashVM.currentValueMD(member: mem)
                    let totUnits = memDashVM.totalUnitsMD(member: mem)
                    let curNAVInfo = memDashVM.currentPriceMD(member: mem)
                    let cumContrib = memDashVM.totalContributionsMD(member: mem)
                    
                    SummaryHeader(
                        fullName: name,
                        employerName: employer,
                        currentValue: curVal,
                        totalUnits: totUnits,
                        currentNAV: curNAVInfo?.nav,
                        currentNAVDate: curNAVInfo?.date,
                        currentInvestment: curNAVInfo?.investment,
                        cummulativeContribution: cumContrib
                    )
                }
                Text("Account History")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                
                if let mem = storedData.members.first( where: { $0.nisNumber == nis}) {
                    let rows = memDashVM.transactionHistoryMD(member: mem)
                    VStack{
                        TransHistoryHeader()
                        ScrollView {
                            VStack {
                                Divider()
                                VStack {
                                    ForEach(rows) {r in
                                        TransHistoryRows(row: r)
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                }
                HStack {
                    if let member = storedData.members.first( where: { $0.nisNumber == nis}) {
                        NavigationLink("Scenario Planner") { ScenarioPlannerView(member: member)
                        }
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .overlay( RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                    }
                    NavigationLink("Help") { HelpView()}
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .overlay( RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                    
                    Spacer()

                    Button(action: {
                        authVM.signOut()
                        dismiss()
                        
                    }) {
                        Text("Sign Out")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)
                            .overlay( RoundedRectangle(cornerRadius: 8).stroke(Color.red, lineWidth: 1))
                    }

                }
                .foregroundStyle(.blue)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}
private struct SummaryHeader: View {
    let fullName: String
    let employerName: String
    let currentValue: Double
    let totalUnits: Double
    let currentNAV: Double?
    let currentNAVDate: Date?
    let currentInvestment: InvestmentProduct?
    let cummulativeContribution: Double
    
    var body: some View {
        VStack {
            Text(employerName)
                .bold()
                .underline()
                .foregroundColor(.white)
                .font(.system(size: 20))
            HStack {
                VStack(alignment: .leading) {
                    Text(" Name")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(fullName)
                }
                .foregroundColor(.white)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Current Value")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(currentValue, format: .currency(code:  "USD").presentation(.narrow))
                        .foregroundColor(.white)
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Units")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(totalUnits, format: .number.precision(.fractionLength(4)))
                        .foregroundColor(.white)
                }
                Spacer()
                VStack (alignment: .center) {
                    Text("Cumulative \n Contributions")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(cummulativeContribution, format: .currency(code:  "USD").presentation(.narrow))
                        .foregroundColor(.white)
                    
                }
                Spacer()
                VStack (alignment: . trailing) {
                    Text("Current NAV")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if let currentNAV {
                        Text(currentNAV, format: .number.precision(.fractionLength(4)))
                            .foregroundColor(.white)
                    } else {
                        Text("N/A")
                            .foregroundColor(.white)
                    }
                    if let currentNAVDate {
                        Text(currentNAVDate,format: .dateTime.day().month().year())
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    if let currentInvestment {
                        Text(currentInvestment.realName)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(.white.opacity(0.2)))
    }
}
private struct TransHistoryHeader: View {
    var body: some View {
        HStack {
            Text("Date").frame(width: 64, alignment: .center)
            Text("Amount").frame(width: 73, alignment: .center)
            Text("Units").frame(width: 64, alignment: .center)
            Text("NAV").frame(width: 64, alignment: .center)
            Text("Fund").frame(width: 67, alignment: .center)
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .bold()
        
        Spacer()
    }
}
private struct TransHistoryRows: View {
        let row: AccountTransactionHistory
        var body: some View {
            HStack {
                Text(row.date, format: .dateTime.day().month().year())
                    .frame(width: 64, alignment: .center)
                Text((row.employee + row.employer),format: .currency(code:  "USD").presentation(.narrow))
                    .frame(width: 73, alignment: .center)
                Text(row.units, format: .number.precision(.fractionLength(4)))
                    .frame(width: 64, alignment: .center)
                Text(row.nav, format: .number.precision(.fractionLength(4)))
                    .frame(width: 64, alignment: .center)
                Text(row.investment.realName)
                    .frame(width: 67, alignment: .center)
            }
            .font(.system(size: 10))
            .foregroundColor(.secondary)
        }
    }
#Preview {
    let storedData = StoredData.sharedSD
    _ = storedData.importCSV(rawCSVData: SampleCSV.sample())
    let nis = "10001"
    
   return MemberDashboardView(nis: nis)
        .environmentObject(AuthViewModel())
        .environmentObject(StoredData.sharedSD)
}
