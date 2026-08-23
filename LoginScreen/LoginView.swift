import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showHome = false
    @State private var showPassword = false

    var body: some View {

        NavigationStack {

            VStack(spacing: 20) {

                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .accessibilityIdentifier("emailField")

                // Password field with eye icon
                HStack {

                    if showPassword {
                        TextField("Password", text: $password)
                            .accessibilityIdentifier("passwordField")
                    } else {
                        SecureField("Password", text: $password)
                            .accessibilityIdentifier("passwordField")
                    }

                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4))
                )

                // Error message
                if !errorMessage.isEmpty {

                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .accessibilityIdentifier("loginErrorMessage")
                }

                Button("Login") {

                    validateLogin()

                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .accessibilityIdentifier("loginButton")
            }
            .padding(24)

            .navigationDestination(isPresented: $showHome) {
                HomeView()
            }
        }
    }

    private func validateLogin() {

        errorMessage = ""

      
        if email.isEmpty {

            errorMessage = "Please enter your email."
            return
        }

        if !email.contains("@") {

            errorMessage = "Please enter a valid email."
            return
        }

        
        if password.isEmpty {

            errorMessage = "Please enter your password."
            return
        }

        if password.count < 6 {

            errorMessage = "Password must be at least 6 characters."
            return
        }

        
        showHome = true
    }
}

#Preview {
    LoginView()
}
