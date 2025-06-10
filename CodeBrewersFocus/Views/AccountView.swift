//
//  AccountView.swift
//  CodeBrewersFocus
//
//  Created by Sandra on 7/6/2025.
//

import SwiftUI

struct AccountView: View {
    @State private var notificationsEnabled = true
    @State private var selectedLanguage = "English"
    @State private var name: String = ""
    @State private var email: String = ""
    let languages = ["English", "Spanish", "French", "German", "Hindi"]

    var body: some View {
        Form {
            Section(header: Text("Name").foregroundColor(.gray)) {
                TextField("alex_0406", text: $name)
                    .autocapitalization(.words)
            }

            Section(header: Text("E-mail").foregroundColor(.gray)) {
                TextField("alexbernedett@gmail.com", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }

            Section {
                // Change Password
                HStack {
                    Text("Change password")
                    Spacer()
                    Image(systemName: "lock.fill")
                        .foregroundColor(.blue)
                }

                // Change Language (no icon)
                HStack {
                    Picker("Change language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Spacer()
                }

                // Notifications Toggle (no icon)
                Toggle(isOn: $notificationsEnabled) {
                    Text("Notifications")
                }
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // Save logic placeholder
                    print("Saved: Name = \(name), Email = \(email), Language = \(selectedLanguage), Notifications = \(notificationsEnabled)")
                }
            }
        }
    }
}

#Preview {
    AccountView()
}
