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
                                    showLogoutAlert = true // Show confirmation popup
                                }) {
                                    Text("Logout")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                                .alert(isPresented: $showLogoutAlert) {
                                    Alert(
                                        title: Text("Confirm Logout"),
                                        message: Text("Are you sure you want to log out?"),
                                        primaryButton: .destructive(Text("Logout")) {
                                            DataController.shared.logout()
                                            delegate?.performSegue(withIdentifier: "segueShowSignInViewController", sender: nil)
                                        },
                                        secondaryButton: .cancel()
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
