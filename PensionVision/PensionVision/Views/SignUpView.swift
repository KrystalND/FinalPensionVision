//
//  SignUpView.swift
//  PensionVision
//
//  Created by Krystal D on 20/10/2025.
//
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    enum ModeSV { case memberSignUp, adminSignUp }
    
    @State private var mode: ModeSV = .memberSignUp
    @State private var nis: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var adminEmail: String = ""
    @State private var adminPassword: String = ""
    @State private var adminConfirmPassword: String = ""
    @State private var adminSystemKey: String = ""
    
    private func resetFields() {
        nis = ""
        email = ""
        password = ""
        confirmPassword = ""
        adminEmail = ""
        adminSystemKey = ""
        adminConfirmPassword = ""
        adminPassword = ""
        authVM.errorMessage = nil
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                    LinearGradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                VStack {
                    VStack {
                        HStack{
                            Text("Create Your Account")
                                .font(.system(size: 30, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .bold, design: .default))
                        }
                    }
                    Picker("Login as", selection: $mode) {
                        Text("Member").tag(ModeSV.memberSignUp)
                        Text("Admin").tag(ModeSV.adminSignUp)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    Group {
                        if mode == .memberSignUp {
                            memberSignUpView
                        } else {
                            adminSignUpView
                        }
                    }
                    }
                }
            }
        .onAppear {
            resetFields()
        }
        .onChange(of: mode) { oldMode, newMode in
            guard oldMode != newMode else { return }
            resetFields()
        }
        }
    private var memberSignUpView: some View {
        
        VStack {
            Form {
                    Section {
                            VStack(alignment: .leading){
                                Text("NIS Number")
                                    .font(.title3.weight(.bold))
                                    .foregroundColor(.white.opacity(0.9))
                                TextField("E.g. 123456", text: $nis)
                                    .textInputAutocapitalization(.never)
                            }
                        VStack(alignment: .leading){
                            Text("Email")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            TextField("E.g. jane\("")@penvis.com", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                        }
                        VStack(alignment: .leading){
                            Text("Password")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            SecureField("E.g. year2025", text: $password)
                                .textInputAutocapitalization(.never)
                                .textContentType(.oneTimeCode)
                        }
                        VStack(alignment: .leading){
                            Text("Confirm Password")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            SecureField("E.g. year2025", text: $confirmPassword)
                                .textInputAutocapitalization(.never)
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.2))
                
                        Section {
                            if let message = authVM.errorMessage {
                            Text(message)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.red)
                            } else {
                                Text("")
                            }
                    }
                    .listRowBackground(Color.clear)
                
                    Section {
                        Button {
                            Task {
                                await authVM.signUpMemberVM(nis: nis, email: email, password: password, confirmPassword: confirmPassword)
                            }
                            
                        } label: {
                            Text("Sign Up")
                                .frame(width:350, height: 50)
                                .background(LinearGradient(colors:[.blue, .green.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .bold()
                        }
                    }
                        .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
        }
    }
    private var adminSignUpView: some View {
        VStack {
            Form {
                    Section {

                        VStack(alignment: .leading){
                            Text("Admin Email")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            TextField("E.g. jane\("")@penvis.com", text: $adminEmail)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                        }
                        VStack(alignment: .leading){
                            Text("Password")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            SecureField("E.g. year2025", text: $adminPassword)
                                .textInputAutocapitalization(.never)
                        }
                        VStack(alignment: .leading){
                            Text("Confirm Password")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            SecureField("E.g. year2025", text: $adminConfirmPassword)
                                .textInputAutocapitalization(.never)
                        }
                            VStack (alignment: .leading){
                                Text("Admin System Key")
                                    .font(.title3.weight(.bold))
                                    .foregroundColor(.white.opacity(0.9))
                                SecureField("E.g. Pinehill", text: $adminSystemKey)
                                    .textInputAutocapitalization(.never)
                            }
                    }
                    .listRowBackground(Color.white.opacity(0.2))
                
                        Section {
                            if let message = authVM.errorMessage {
                            Text(message)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.red)
                            } else {
                                Text("")
                            }
                    }
                    .listRowBackground(Color.clear)
                
                    Section {
                        Button {
                            Task {
                                await authVM.signUpAdminVM(email: adminEmail, password: adminPassword, confirmPassword: adminConfirmPassword, adminSystemKey: adminSystemKey)
                            }
                            
                        } label: {
                            Text("Sign Up")
                                .frame(width:350, height: 50)
                                .background(LinearGradient(colors:[.blue, .green.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                                .bold()
                        }
                    }
                        .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
