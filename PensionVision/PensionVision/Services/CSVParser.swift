//
//  CSVParser.swift
//  PensionVision
//
//  Created by Krystal D on 27/09/2025.
//
import Foundation

enum CSVParser {
    static let csvTitle = ["nis","first_name","last_name","dob","email", "employer","date","eeamt","eramt","investment","units","nav"]
    
    static func parse(csv: String) -> (members: [Member], navs: [NAV], error: CSVError?){
        let rows = csv.split(whereSeparator: { $0.isNewline}).map(String.init)
        let rawFileTitles = rows.first
        
        let fileTitles = csvSplitter(line: rawFileTitles ?? "")
        
        let titles = fileTitles.map { normalise(value: $0) }
        
        if titles != csvTitle {
            return ([], [], .incorrectTitle(correctTitle: csvTitle, inputTitle: fileTitles))
        }
        
        if rows.count <= 1 {
            return ([], [], .empty)
        }
        var memeberList: [String: Member] = [:]
        var navs: [NAV] = []
        
        let dFormatter: DateFormatter = {
            let dFormatter = DateFormatter()
            dFormatter.dateFormat = "yyyy-MM-dd"
            return dFormatter
        }()
        
        for (index, rawRow) in rows.dropFirst().enumerated() {
            let fileStarterRow = index + 2
            let column = csvSplitter(line: String(rawRow)).map {normalise(value: $0)}
            if column.count != csvTitle.count {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Incorrect number of columns"))
            }
            let nis = column[0]
            let firstName = column[1]
            let lastName = column[2]
            guard let dob = dFormatter.date(from: column[3]) else {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Invalid date of birth format"))
            }
            let email = column[4]
            let employer = column[5]
            
            guard let date = dFormatter.date(from: column[6]) else {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Invalid date format"))
            }
            guard let eeamt = Double(column[7]) else {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Invalid employee contribution amount "))
            }
            guard let eramt = Double(column[8]) else {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Invalid employer contribution amount"))
            }
            guard let investment = InvestmentProduct(rawValue: column[9]) else {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Invalid investment product"))
            }
            guard let units = Double((column[10])) else {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Invalid  unit number"))
            }
            guard let nav = Double(column[11]) else {
                return ([], [], .errorRow(row: fileStarterRow, issue: "Invalid  net asset value"))
            }
            if let existingMember = memeberList[nis] {
                if normalise(value: existingMember.email) != email {
                    return ([], [], .errorRow(row: fileStarterRow, issue: " Email addresses mismatch in file for NIS \(nis)" ))
                }
            }
            
            var member = memeberList[nis] ?? Member.init(
                nisNumber: nis,
                firstName: firstName,
                lastName: lastName,
                dob: dob,
                email: email,
                employer: employer,
                contributions: [],
                holdings: []
            )
            member.contributions.append(.init(date: date, employee: eeamt, employer: eramt))
            member.holdings.append(.init(date: date, investment: investment, units: units))
            memeberList[nis] = member
            navs.append(.init(date: date, investment: investment, nav: nav))
            
        }
        return (Array(memeberList.values), navs, nil)
        }
    
    private static func normalise(value: String) -> String {
        value.replacingOccurrences(of: "\u{FEFF}", with: "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    private static func csvSplitter(line: String) -> [String] {
        var csvLines: [String] = []
        var csvLine: String = ""
        var inQuotes: Bool = false
        
        for char in line {
            if char == "\"" {
                inQuotes.toggle()
                continue
            }else if char == "," && !inQuotes {
                csvLines.append(csvLine)
                csvLine.removeAll()
                continue
            }
            csvLine.append(char)
        }
        csvLines.append(csvLine)
        return csvLines
    }
    
}
