//
//  HomeView.swift
//  PensionVision
//
//  Created by Krystal D on 23/10/2025.
//
import SwiftUI

struct HomeView: View {
    
    @State private var animationColour: Color = .white
    @State private var runningAnimation = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    HStack{
                        Text("PensionVision")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundColor(animationColour)
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 35))
                            .foregroundColor(animationColour)
                            .bold()
                    }
                    
                    HStack{
                        Text("Planning for retirement has never been easier")
                            .foregroundColor(animationColour)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    NavigationLink {
                        LoginView()
                        
                    } label: {
                        Text("Let's get started")
                            .frame(width:260, height: 50)
                            .bold()
                            .background(LinearGradient(colors:[.blue, .green.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                    .padding()
                }
                    .onAppear {
                        guard !runningAnimation else { return }
                        runningAnimation = true
                        
                        withAnimation(.easeInOut(duration: 0.9)) {
                            animationColour = .blue.opacity(0.8)
                        }
                        withAnimation(.easeInOut(duration: 0.9).delay(0.9)) {
                            animationColour = .white.opacity(0.8)
                        }

                    }
                }
            }
        }
    }

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(StoredData.sharedSD)
}
