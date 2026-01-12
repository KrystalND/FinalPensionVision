//
//  LoginView.swift
//  PensionVision
//
//  Created by Krystal D on 20/10/2025.
//
import SwiftUI

 struct LoginView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    
    enum ModeLV { case member, admin }
    
    @State private var mode: ModeLV = .member
    @State private var nis: String = ""
    @State private var password: String = ""
    @State private var adminEmail: String = ""
    @State private var adminSystemKey: String = ""
    @State private var adminPassword: String = ""
    @State private var goSignUp = false
    @State private var goAdminImport = false
    @State private var goMemberDashboard = false
    
    private func resetFields() {
        nis = ""
        password = ""
        adminEmail = ""
        adminSystemKey = ""
        adminPassword = ""
        authVM.errorMessage = nil
    }
    
    public var body: some View {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.8), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        HStack{
                            Text("Member & Admin Portal")
                                .font(.system(size: 30, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .bold, design: .default))
                        }
                    }
                    
                    Picker("Login as", selection: $mode) {
                        Text("Member").tag(ModeLV.member)
                        Text("Admin").tag(ModeLV.admin)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    Group {
                        if mode == .member {
                            memberView
                        } else {
                            adminView
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
            .navigationBarBackButtonHidden(true)
    }
    private var memberView: some View {
        VStack {
            Form {
                Section {
                    HStack(alignment: .top){
                        Image(systemName: "number.square")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 20, weight: .bold, design: .default))
                        VStack (alignment: .leading){
                            Text("NIS Number")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            TextField("e.g. 123456", text: $nis)
                                .textInputAutocapitalization(.never)
                        }
                    }
                    HStack(alignment: .top){
                        Image(systemName: "lock")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 20, weight: .bold, design: .default))
                        VStack (alignment: .leading){
                            Text("Password")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            SecureField("e.g. Queen876", text: $password)
                                .textInputAutocapitalization(.never)
                        }
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
                            await authVM.signInMemberVM(nis: nis, password: password)
                            if authVM.errorMessage == nil, authVM.user?.role == .planMember {
                                goMemberDashboard = true
                            }
                        }
                        
                    } label: {
                        Text("Sign In")
                            .frame(width:350, height: 50)
                            .bold()
                            .background(LinearGradient(colors:[.blue, .green.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            
            HStack{
                Spacer()
                Button(action: {
                    authVM.errorMessage = nil
                    
                    guard !nis.isEmpty else {
                        authVM.errorMessage = "Please enter your NIS number"
                        return
                    }
                    Task {
                        await authVM.resetMemberPasswordVM(nis: nis)
                    }
                }) {
                    Text("Forgot \n Password?")
                        .bold()
                        .underline()
                }
                Spacer()
            Button {
                goSignUp = true
                
            } label: {
                Text("Need an \n Account?")
                    .bold()
                    .underline()
            }
            Spacer()
        }
            
    }
        .navigationDestination(isPresented: $goSignUp) {
            SignUpView()
        }
        .navigationDestination(isPresented: $goMemberDashboard) {
            MemberDashboardView(nis: nis)
        }
    }
    
    private var adminView: some View {
        VStack {
            Form {
                Section {
                    HStack(alignment: .top){
                        Image(systemName: "at")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 20, weight: .bold, design: .default))
                        VStack (alignment: .leading){
                            Text("Admin Email")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            TextField("E.g. jane\("")@penvis.com", text: $adminEmail)
                                .textInputAutocapitalization(.never)
                        }
                    }
                    HStack(alignment: .top){
                        Image(systemName: "lock")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 20, weight: .bold, design: .default))
                        VStack (alignment: .leading){
                            Text("Password")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            SecureField("E.g. Queen876", text: $adminPassword)
                                .textInputAutocapitalization(.never)
                                .textContentType(.oneTimeCode)
                        }
                    }
                    HStack(alignment: .top){
                        Image(systemName: "key.horizontal")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 20, weight: .bold, design: .default))
                        VStack (alignment: .leading){
                            Text("Admin System Key")
                                .font(.title3.weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                            SecureField("E.g. Pinehill", text: $adminSystemKey)
                                .textInputAutocapitalization(.never)
                        }
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
                    HStack{
                        Spacer()
                        Button {
                            goSignUp = false
                            Task {
                                await authVM.signInAdminVM(email: adminEmail, password: adminPassword, systemKey: adminSystemKey)
                                if authVM.errorMessage == nil, authVM.user?.role == .admin { goAdminImport = true
                                }
                            }
                            
                        } label: {
                            Text("Sign In")
                                .frame(width:350, height: 50)
                                .bold()
                                .background(LinearGradient(colors:[.blue, .green.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(40)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            
            HStack{
                Spacer()
                Button(action: {
                    authVM.errorMessage = nil
                    
                    guard !adminEmail.isEmpty else {
                        authVM.errorMessage = "Please enter your admin email."
                        return
                    }
                    guard !adminSystemKey.isEmpty else {
                        authVM.errorMessage = "Please enter your system key."
                        return
                    }
                    Task {
                        await authVM.resetAdminPasswordVM(email: adminEmail, systemKey: adminSystemKey)
                    }
                }) {
                    Text("Forgot \n Password?")
                        .bold()
                        .underline()
                }
                Spacer()
            Button {
                goSignUp = true
                
            } label: {
                Text("Need an \n Account?")
                    .bold()
                    .underline()
            }
            Spacer()
        }
    }
        .navigationDestination(isPresented: $goSignUp) {
            SignUpView()
        }
        .navigationDestination(isPresented: $goAdminImport) {
            AdminImportView()
        }
    }
}
#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}


