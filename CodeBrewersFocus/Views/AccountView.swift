// Created by Arjun Agarwal on Jun 11

import SwiftUI

// MARK: - AccountView: Displays user account settings and password change modal
struct AccountView: View {
    // User settings variables
    @State private var notificationsEnabled = true
    @State private var selectedLanguage = "English"

    // Password modal related variables
    @State private var showPasswordBox = false
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    // Supported languages for picker
    let languages = ["English", "Spanish", "French", "German", "Hindi"]

    var body: some View {
        ZStack {
            // MARK: - Main Form
            Form {
                // Display static name (non-editable)
                Section(header: Text("Name").foregroundColor(.gray)) {
                    Text("Alex_0406")
                        .autocapitalization(.words)
                }

                // Display static email (non-editable)
                Section(header: Text("E-mail").foregroundColor(.gray)) {
                    Text("alexbernadett@gmail.com")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                // Interactive settings section
                Section {
                    // Password change trigger
                    HStack {
                        Text("Change password")
                        Spacer()
                        Image(systemName: "lock.fill")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showPasswordBox = true
                            }
                    }

                    // Language selection dropdown
                    Picker("Change language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    // Notifications toggle switch
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Notifications")
                    }
                }
            }
            // Disable interaction with background form when password modal is active
            .blur(radius: showPasswordBox ? 3 : 0)
            .disabled(showPasswordBox)

            // MARK: - Password Modal Overlay
            if showPasswordBox {
                // Dimmed background
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                // Modal box
                VStack(spacing: 0) {
                    // Title
                    Text("Change Password")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)

                    Divider()

                    // Password input fields and hint
                    VStack(spacing: 10) {
                        SecureField("Create new password", text: $newPassword)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        SecureField("Confirm new password", text: $confirmPassword)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Text("Your password must be at least 8 characters long, include a number, an uppercase letter and a lowercase letter.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    Divider()

                    // Cancel and Save buttons
                    HStack(spacing: 0) {
                        Button("Cancel") {
                            // Reset and close modal
                            showPasswordBox = false
                            newPassword = ""
                            confirmPassword = ""
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.red)

                        Divider()
                            .frame(width: 1, height: 44)

                        Button("Save") {
                            // Save new password if valid
                            if isValidPassword(newPassword), newPassword == confirmPassword {
                                print("Password set to: \(newPassword)")
                            } else {
                                print("Validation failed")
                            }
                            showPasswordBox = false
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                    }
                }
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 20)
            }
        }
        // Navigation bar settings
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // Intended for future implementation (currently placeholder)
                }
            }
        }
    }
}

// MARK: - Password Validation Function
/// Validates password using a regex pattern:
/// - Minimum 8 characters
/// - At least one uppercase letter
/// - At least one lowercase letter
/// - At least one digit
func isValidPassword(_ password: String) -> Bool {
    let regex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$"#
    return password.range(of: regex, options: .regularExpression) != nil
}
#Preview {
    MainTabView()
}
