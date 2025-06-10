
//  Created by Arjun Agarwal

import SwiftUI

struct ManageSubscriptionView: View {
    @State private var cardNumber: String = "**** **** **** ****"
    @State private var expiryDate: String = "mm / yy"
    @State private var cvc: String = "123"
    @State private var autoRenew: Bool = true
    @State private var isEditing: Bool = false
    
    var body: some View {
        
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Plan Cards (Equal size & matching design)
                    HStack(spacing: 16) {
                        let boxWidth: CGFloat = UIScreen.main.bounds.width * 0.44
                        let boxHeight: CGFloat = 160
                        
                        // Current Plan Card
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Current Plan").foregroundColor(.gray)
                            Text("$25").font(.title).bold()
                            Spacer()
                            Button(action: {
                                // Change plan action
                            }) {
                                Text("Change")
                                    .padding(.horizontal, 22)
                                    .padding(.vertical, 10)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule()) // match styling too
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding() //  MAKE THIS MATCH WITH Next Payment
                        .padding(.bottom, 12)
                        .frame(width: boxWidth, height: boxHeight)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        
                        // Next Payment Card
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Next Payment").foregroundColor(.gray)
                            Text("$50").font(.title).bold()
                            Spacer()
                            Button(action: {
                                // Manage payment action
                            }) {
                                Text("Manage")
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
                        .frame(width: boxWidth, height: boxHeight)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                    }
                    .padding(.horizontal)
                    
                    // Updated Payment Information Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Payment Information")
                            .font(.headline)
                        
                        // Card Number Field
                        HStack {
                            Text("Card Number:")
                                .frame(width: 100, alignment: .leading)
                            TextField("**** **** **** ****", text: $cardNumber)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .onChange(of: cardNumber) {
                                    cardNumber = String(cardNumber.prefix(16)).filter { $0.isNumber }
                                }
                        }
                        
                        // Expiry & CVC and Auto-Renew
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Exp Date:")
                                        .frame(width: 80, alignment: .leading)
                                    
                                    TextField("mm/yy", text: $expiryDate)
                                        .keyboardType(.numberPad)
                                        .padding()
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(10)
                                        .onChange(of: expiryDate) {
                                            // Allow only digits
                                            var digits = expiryDate.filter { $0.isNumber }

                                            // Limit to 4 digits max
                                            if digits.count > 4 {
                                                digits = String(digits.prefix(4))
                                            }

                                            // Format with slash after first 2 digits
                                            if digits.count >= 3 {
                                                let month = digits.prefix(2)
                                                let year = digits.suffix(from: digits.index(digits.startIndex, offsetBy: 2))
                                                expiryDate = "\(month)/\(year)"
                                            } else {
                                                expiryDate = digits
                                            }
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
                            
                            // Auto-Renew Toggle Card
                          
                             }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        
                        // Auto-Renew Toggle
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
                }
                .navigationTitle("Manage Subscription")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            // Save logic here
                            print("Saved: Card - \(cardNumber), Exp - \(expiryDate), CVC - \(cvc), Auto-Renew - \(autoRenew)")
                        }
                        .foregroundColor(.blue)
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
                
            }
        }
    
    
    
    
    
    
