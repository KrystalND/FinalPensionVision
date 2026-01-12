//
//  ScenarioPlannerView.swift
//  PensionVision
//
//  Created by Krystal D on 09/11/2025.
//
import SwiftUI
import Charts

struct ScenarioPlannerView: View {
    @StateObject private var sceneVM: ScenarioPlannerViewModel
    @State private var retirementYearTxt: String
    @State private var annualIncreaseTxt: String
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) private var back
    
    init(member: Member) {
        let sVm = ScenarioPlannerViewModel(member: member)
        _sceneVM = StateObject(wrappedValue: sVm)
        _retirementYearTxt = State(initialValue: String(sVm.retirementYear))
        _annualIncreaseTxt = State(initialValue: String(sVm.annualIncreasePercentage))
        
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    HStack {
                        Button(action: {back()}) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                                
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .default))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    HStack {
                        
                        Text("Scenario Planner")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }
                    userFields
                        .padding()
                    if let error = errorMessage, !error.isEmpty {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    sumBar
                    chart
                        .padding()
                        .frame(height: 280)
                    footer
                }
            }
        }
        .onAppear {
            sceneVM.updatedCurrentPrice()
            sceneVM.updatedAnnualRate()
        }
        .onChange(of: sceneVM.changeInvestment){
            sceneVM.updatedCurrentPrice()
            sceneVM.updatedAnnualRate()
        }
        .navigationBarBackButtonHidden(true)
    }
    private func runScenario() {
        errorMessage = nil
        let currentYear = Calendar.current.component(.year, from: Date())
        let parsedYear = Int(retirementYearTxt)
        let parsedPer = Double(annualIncreaseTxt)
        
        guard let year = parsedYear, year > currentYear else {
            errorMessage = "Please enter a valid retirement year"
            sceneVM.forecast = []
            sceneVM.estimatedFutureValue = 0
            sceneVM.totalContributedAtRetirement = nil
            return
        }
        sceneVM.retirementYear = year
        sceneVM.annualIncreasePercentage = max(0, parsedPer ?? 0)
        
        sceneVM.recompute()
    }
    
    private var userFields: some View {
        VStack {
            HStack{
                VStack {
                    Text("Retirement Year")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    TextField("Year",text: $retirementYearTxt)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 185)
                        .foregroundColor(.secondary)
                }
                VStack {
                    Text("Annual Increase %")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    TextField("%",text: $annualIncreaseTxt)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 185)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 6)
            }
            HStack {
                Button(action: runScenario) {
                    Text("Run Scenario")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .background(LinearGradient(colors:[.blue, .green.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            
            VStack {
                HStack {
                    Text("Investment Type")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .underline()
                    Spacer()
                }
                HStack{
                    Picker("", selection: $sceneVM.changeInvestment) {
                        ForEach(InvestmentProduct.allCases, id: \.self) {inv in Text(inv.realName).tag(inv)}
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
    private var sumBar: some View {
        HStack {
            Spacer()
            if let contTotal = sceneVM.totalContributedAtRetirement {
                VStack (alignment: .leading) {
                    Text("Total Contribution \n by Retirement")
                        .foregroundStyle(.white)
                    Text(contTotal, format: .currency(code:  "USD").presentation(.narrow))
                        .foregroundStyle(.secondary)
                }
                .font(.system(size: 15))
            } else {
                VStack(alignment: .leading) {
                    Text("Total Contribution \n by Retirement")
                        .foregroundStyle(.white)
                    Text("-")
                        .foregroundStyle(.secondary)
                }
                .font(.system(size: 15))
            }
            Spacer()
            if let nav = sceneVM.currentNAV, let date = sceneVM.currentNAVDate {
                VStack (alignment:.center) {
                    Text("As at \(date.formatted(.dateTime.day().month().year()))")
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                    Text("Current NAV")
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                    Text(nav, format: .number.precision(.fractionLength(4)))
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Historical")
                        .foregroundStyle(.white)
                    Text(" Return")
                        .foregroundStyle(.white)
                    Text("\(sceneVM.annualReturnRate, specifier: "%.2f%%")")
                        .foregroundStyle(.secondary)
                }
                .font(.system(size: 15))
            }
            Spacer()
        }
    }
    private var chart: some View {
        let forecast = sceneVM.forecast
        let cV = sceneVM.currentValueNow
        var dataPoints: [ProjectionDataPoint] = []
        
        if !forecast.isEmpty {
            let dataStartDate = sceneVM.currentNAVDate ?? Date()
            
            let startPoint = ProjectionDataPoint(
                date: dataStartDate,
                value: cV,
                contributed: 0
            )
            dataPoints = [startPoint] + forecast
        }
        let minDate = dataPoints.map(\.date).min() ?? Date()
        let maxDate = dataPoints.map(\.date).max() ?? Date()
        let maxValue = dataPoints.map(\.value).max() ?? 1.0
        let yAxisMax = maxValue * 1.05
        let totalTimeInterval = maxDate.timeIntervalSince(minDate)
        
        let quartDate = minDate.addingTimeInterval(totalTimeInterval * 0.25)
        let halfDate = minDate.addingTimeInterval(totalTimeInterval * 0.5)
        let threeQuartDate = minDate.addingTimeInterval(totalTimeInterval * 0.75)
        let xLines: [Date] = [minDate, quartDate, halfDate, threeQuartDate]
        
       return Group {
            if forecast.isEmpty {
                VStack {
                    Text("No Projection Yet.")
                        .foregroundStyle(.secondary)
                    Text("Enter a valid year and percentage, then tap **Run Scenario**.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("Projections are illustrative. Past performance is not indicative of future results.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: 380, minHeight: 180)
                .background(Color.white.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
            } else {
                Chart(dataPoints, id: \.date) { dp in
                    LineMark(x: .value("Date", dp.date),
                             y: .value("Value", dp.value)
                    )
                }
                .foregroundStyle(LinearGradient(colors: [.blue, .green], startPoint: .leading, endPoint:.trailing))
                .chartXScale(domain: minDate...maxDate)
                .chartXAxis {
                    AxisMarks(values: xLines) {
                        value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date,format: .dateTime.year().month())
                            }
                        }
                    }
                }
                .chartYScale(domain: 0...yAxisMax)
                .chartYAxis { AxisMarks(values: [0, yAxisMax / 4, yAxisMax / 2, yAxisMax * 3 / 4, yAxisMax]) {
                        value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let val = value.as(Double.self) {
                                Text(val, format: .currency(code: "USD")
                                    .precision(.fractionLength(0))
                                    .presentation(.narrow))
                            }
                        }
                    }
                }
            }
               
        }
    }
    private var footer: some View {
        HStack {
            Spacer()
            VStack {
                Text("Current Value")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                Text(sceneVM.currentValueNow, format: .currency(code:  "USD").presentation(.narrow))
                    .foregroundStyle(.secondary)
                    .font(.system(size: 18))
            }
            Spacer()
            VStack {
                Text("Estimated Value \n at Retirement")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                Text(sceneVM.estimatedFutureValue, format: .currency(code:  "USD").presentation(.narrow))
                    .foregroundStyle(.secondary)
                    .font(.system(size: 18))
            }
            Spacer()
        }
    }
}
#Preview {
    let storedData = StoredData.sharedSD
    _ = storedData.importCSV(rawCSVData: SampleCSV.sample())
    let nis = "10001"
    
    guard let member = storedData.members.first(where: { $0.nisNumber == nis }) else {
        fatalError("Member not found for NIS: \(nis)")
    }
    
   return ScenarioPlannerView(member: member)
        .environmentObject(AuthViewModel())
        .environmentObject(StoredData.sharedSD)
}
