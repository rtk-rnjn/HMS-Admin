//
//  AdminProfileView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct AdminProfileView: View {
    weak var delegate: ProfileHostingController?

   @Environment(\.horizontalSizeClass) var sizeClass
    @State private var showLogoutAlert = false
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    @State private var notificationFeedback = UINotificationFeedbackGenerator()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sizeClass == .regular ? 140 : 120, height: sizeClass == .regular ? 140 : 120)
                        .foregroundColor(Color(.systemGray4))
                        .clipShape(Circle())

                    // Admin Name
                    Text("Admin")
                        .font(.system(size: 22, weight: .bold))

                    // Admin Role Badge
//                    Text("Administrator")
//                        .font(.system(size: 13, weight: .semibold))
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 6)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
                }
                .padding(.top, 16)
                .padding(.bottom, 8)

                // Information Sections with adaptive layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: sizeClass == .regular ? 500 : 300))], spacing: 20) {

                    // Contact Information Section
                    InfoSectionCard(title: "Contact Information") {
                        InfoRow(icon: "envelope.fill", label: "Email", value: "admin@hms.local")
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "building.2.fill", label: "Department", value: "Administrator")
                    }
                }

                                 // Logout Button

                                Button(action: {
                                    // Heavy impact when showing logout confirmation
                                    impactFeedback.prepare()
                                    impactFeedback.impactOccurred(intensity: 1.0)
                                    showLogoutAlert = true
                                }) {
                                    Text("Logout")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal)
                                .alert(isPresented: $showLogoutAlert) {
                                    Alert(
                                        title: Text("Confirm Logout"),
                                        message: Text("Are you sure you want to log out?"),
                                        primaryButton: .destructive(Text("Logout")) {
                                            // Error haptic when confirming logout
                                            notificationFeedback.prepare()
                                            notificationFeedback.notificationOccurred(.error)
                                            DataController.shared.logout()
                                            delegate?.performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
                                        },
                                        secondaryButton: .cancel {
                                            // Light impact when canceling
                                            impactFeedback.prepare()
                                            impactFeedback.impactOccurred(intensity: 0.5)
                                        }
                                    )
                                }
                            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        // .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
