//
//  HelpView.swift
//  PensionVision
//
//  Created by Krystal D on 09/11/2025.
//
import SwiftUI

struct HelpView: View {
    @StateObject var aiVM = AIHelpViewModel()
    @Environment(\.dismiss) private var back
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
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
                VStack {
                    HStack {
                        Text("Help")
                            .font(.system(size: 30, weight: .bold, design: .default))
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 25, weight: .bold, design: .default))
                    }
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)

                }
                VStack(alignment: .center) {
                    Text("Understanding Your Pension")
                        .font(.system(size: 20, weight: .bold, design: .default))
                    
                    TextField(" Type your question here...", text: $aiVM.question)
                        .padding()
                        .tint(.white)
                        .frame(width: 320, height: 50)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                    Button {
                        Task { await aiVM.ai()}
                    } label : {
                        Text("Enter")
                            .frame(width:300, height: 50)
                            .bold()
                            .background(LinearGradient(colors:[.blue, .green.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                    }
                }
                .foregroundStyle(.white)
                .padding()
                Spacer()
                
                VStack {
                    if !aiVM.aiAnswer.isEmpty {
                        ScrollView {
                            Text("AI Response:")
                                .foregroundStyle(.white)
                            Text(aiVM.aiAnswer)
                                .font(.system(size: 20))
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    HelpView()
}
