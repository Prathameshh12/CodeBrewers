//  Created by Arjun Agarwal

import SwiftUI

// MARK: - ManageSubscriptionView: Subscription & Payment Settings
struct ManageSubscriptionView: View {
    @State private var cardNumber = "**** **** **** ****"
    @State private var expiryDate = "mm / yy"
    @State private var cvc = "123"
    @State private var autoRenew = true
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Plan Cards
                HStack(spacing: 16) {
                    let boxWidth = UIScreen.main.bounds.width * 0.44
                    let boxHeight: CGFloat = 160

                    PlanCard(title: "Current Plan", price: "$25", actionTitle: "Change") {
                        // Change plan logic
                    }
                    .frame(width: boxWidth, height: boxHeight)

                    PlanCard(title: "Next Payment", price: "$50", actionTitle: "Manage") {
                        // Manage payment logic
                    }
                    .frame(width: boxWidth, height: boxHeight)
                }
                .padding(.horizontal)

                // MARK: - Payment Info Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Payment Information")
                        .font(.headline)

                    // Card Number
                    LabeledTextField(label: "Card Number:", text: $cardNumber, maxLength: 16)

                    // Expiry and CVC
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            ExpiryAndCVC(expiryDate: $expiryDate, cvc: $cvc)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 2)
                .padding(.horizontal)

                // MARK: - Auto-Renew
                HStack {
                    Text("Auto-Renew")
                        .font(.headline)
                    Spacer()
                    Toggle("", isOn: $autoRenew)
                        .labelsHidden()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 2)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Manage Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        print("Saved: Card - \(cardNumber), Exp - \(expiryDate), CVC - \(cvc), Auto-Renew - \(autoRenew)")
                    }
                    .foregroundColor(.blue)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

// MARK: - Reusable PlanCard View
struct PlanCard: View {
    let title: String
    let price: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).foregroundColor(.gray)
            Text(price).font(.title).bold()
            Spacer()
            Button(action: action) {
                Text(actionTitle)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .padding(.bottom, 12)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
    }
}

// MARK: - LabeledTextField
struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    let maxLength: Int

    var body: some View {
        HStack {
            Text(label)
                .frame(width: 100, alignment: .leading)
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .onChange(of: text) {
                    text = String(text.prefix(maxLength)).filter { $0.isNumber }
                }
        }
    }
}

// MARK: - Expiry and CVC Handler
struct ExpiryAndCVC: View {
    @Binding var expiryDate: String
    @Binding var cvc: String

    var body: some View {
        HStack {
            Text("Exp Date:")
                .frame(width: 80, alignment: .leading)
            TextField("mm/yy", text: $expiryDate)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .onChange(of: expiryDate) {
                    var digits = expiryDate.filter { $0.isNumber }
                    if digits.count > 4 { digits = String(digits.prefix(4)) }
                    expiryDate = digits.count >= 3 ? "\(digits.prefix(2))/\(digits.suffix(from: digits.index(digits.startIndex, offsetBy: 2)))" : digits
                }

            Text("CVC:")
                .frame(width: 40, alignment: .leading)
            TextField("123", text: $cvc)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .frame(width: 80)
                .onChange(of: cvc) {
                    cvc = String(cvc.prefix(3)).filter { $0.isNumber }
                }
        }
    }
}
