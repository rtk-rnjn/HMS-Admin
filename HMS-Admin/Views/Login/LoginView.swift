import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoginInProgress = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var isLoggedIn = false
    
    // Validation
    private var isFormValid: Bool {
        return isValidEmail(email) && !password.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Logo/header area
                    VStack(spacing: 16) {
                        // Logo with fallback
                        Group {
                            if UIImage(named: "AppLogo") != nil {
                                Image("AppLogo")
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                // Fallback logo
                                Image(systemName: "building.columns.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(width: 120, height: 120)
                        .padding(.top, 40)
                        
                        Text("HMS Admin")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Hospital Management System")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 40)
                    }
                    
                    // Form area
                    VStack(spacing: 24) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            HStack {
                                TextField("Enter your email", text: $email)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .disableAutocorrection(true)
                                
                                if !email.isEmpty {
                                    Button(action: { email = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            HStack {
                                if showPassword {
                                    TextField("Enter your password", text: $password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                                
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(password.isEmpty ? .gray : .blue)
                                }
                                .disabled(password.isEmpty)
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        // Forgot password
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // Forgot password action
                            }) {
                                Text("Forgot Password?")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Sign in button
                        Button(action: {
                            login()
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(isFormValid ? Color.blue : Color.blue.opacity(0.5))
                                    .cornerRadius(8)
                                    .frame(height: 50)
                                
                                if isLoginInProgress {
                                    HStack(spacing: 10) {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        Text("Signing in...")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .disabled(!isFormValid || isLoginInProgress)
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Footer
                    Text("v1.0 © 2025 HMS Admin")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "Unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                DoctorListView()
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onAppear {
                // Check if user is already logged in
                if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                    isLoggedIn = true
                }
            }
        }
    }
    
    // MARK: - Functions
    
    private func login() {
        isLoginInProgress = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Task {
                let success = await DataController.shared.login(emailAddress: email, password: password)
                
                DispatchQueue.main.async {
                    isLoginInProgress = false
                    
                    if success {
                        // Save login state
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        isLoggedIn = true
                    } else {
                        errorMessage = "Invalid email or password"
                        showError = true
                    }
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
} 