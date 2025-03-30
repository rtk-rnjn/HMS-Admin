//
//  DashboardHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import SwiftUI
import UIKit

class DashboardHostingController: UIHostingController<DashboardView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DashboardView())
        rootView.delegate = self
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up tab bar item
        tabBarItem = UITabBarItem(
            title: "Dashboard",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        // Configure navigation bar
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true

        updateUI()
    }

    // MARK: Private

    private func updateUI() {
        Task {
            let doctorCount = await fetchActiveDoctorCount()
            DispatchQueue.main.async {
                self.rootView.activeDoctorCount = doctorCount
            }
        }

        Task {
            let patientCount = await fetchPatientCount()
            DispatchQueue.main.async {
                self.rootView.patientCount = patientCount
            }
        }
    }

    private func fetchActiveDoctorCount() async -> Int {
        guard let staffs = await DataController.shared.fetchDoctors() else {
            return 0
        }

        return staffs.count
    }

    private func fetchPatientCount() async -> Int {
        guard let staffs = await DataController.shared.fetchDoctors() else {
            return 0
        }

        var patients: [String: Int] = [:]

        for staff in staffs {
            let appointments: [Appointment]? = await DataController.shared.fetchAppointments(byDoctorWithId: staff.id)
            guard let appointments else { return 0 }

            for appointment in appointments {
                patients[appointment.patientId] = 0
            }
        }

        return patients.count
    }
}
