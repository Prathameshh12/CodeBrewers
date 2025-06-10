// Created by Arjun Agarwal

import SwiftUI

struct AccountView: View {
    @State private var notificationsEnabled = true
    @State private var selectedLanguage = "English"
    @State private var name: String = ""
    @State private var email: String = ""

    @State private var showPasswordBox = false
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    let languages = ["English", "Spanish", "French", "German", "Hindi"]

    var body: some View {
        ZStack {
            Form {
                Section(header: Text("Name").foregroundColor(.gray)) {
                    TextField("Enter your name", text: $name)
                        .autocapitalization(.words)
                }

                Section(header: Text("E-mail").foregroundColor(.gray)) {
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                Section {
                    HStack {
                        Text("Change password")
                        Spacer()
                        Image(systemName: "lock.fill")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showPasswordBox = true
                            }
                    }

                    Picker("Change language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Toggle(isOn: $notificationsEnabled) {
                        Text("Notifications")
                    }
                }
            }
            .blur(radius: showPasswordBox ? 3 : 0)
            .disabled(showPasswordBox)

            if showPasswordBox {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Text("Change Password")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)

                    Divider()

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

                    HStack(spacing: 0) {
                        Button("Cancel") {
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
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    print("Saved: Name = \(name), Email = \(email), Language = \(selectedLanguage), Notifications = \(notificationsEnabled)")
                }
            }
        }
    }
}

// MARK: - Password Validation Function
func isValidPassword(_ password: String) -> Bool {
    let regex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$"#
    return password.range(of: regex, options: .regularExpression) != nil
}
