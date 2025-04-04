//
//  ReportsHostingController.swift
//  HMS-Admin
//
//  Created by Claude on 28/04/25.
//

import UIKit
import SwiftUI

class ReportsHostingController: UIHostingController<ReportsView> {

    // MARK: Lifecycle

    init() {
        let reportsView = ReportsView()
        super.init(rootView: reportsView)

        title = "Reports"
        modalPresentationStyle = .fullScreen
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var totalRevenue: Int = 0
    var uniquePatients: Int = 0
    var metrics: [MetricData] = []
    var appointmentData: [WeeklyData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Task {
            _ = await fetchPatientCounts()
            _ = await fetchWeeklyAppointments()
            guard let bills = await DataController.shared.fetchBills() else {
                return
            }

            totalRevenue = bills.reduce(0) { $0 + $1.amountPaid }

            DispatchQueue.main.async {
                self.rootView.metrics = self.generateMetrics()
                self.rootView.appointmentData = self.appointmentData
            }
        }
    }

    func generateMetrics() -> [MetricData] {
        return [
            MetricData(title: "Appointments", value: "\(uniquePatients)", icon: "calendar", isPositive: true, color: Color("iconBlue")),
            MetricData(title: "Revenue", value: "Rs. \(totalRevenue / 100)", icon: "dollarsign.circle", isPositive: true, color: Color("iconBlue"))
        ]
    }

    // MARK: Private

    private func fetchPatientCounts() async -> Int {
        guard let doctors = await DataController.shared.fetchDoctors() else {
            return 0
        }

        var uniquePatients: [String: Int] = [:]

        for doctor in doctors {
            let appointments: [Appointment]? = await DataController.shared.fetchAppointments(byDoctorWithId: doctor.id)
            guard let appointments else { continue }

            for appointment in appointments {
                uniquePatients[appointment.patientId] = 0
            }
        }

        self.uniquePatients = uniquePatients.count
        return uniquePatients.count
    }

    private func fetchWeeklyAppointments() async -> [String: Int] {
        guard let doctors = await DataController.shared.fetchDoctors() else {
            return [:]
        }

        var weeklyCounts: [String: Int] = [:]
        let calendar = Calendar.current

        for doctor in doctors {
            let appointments: [Appointment]? = await DataController.shared.fetchAppointments(byDoctorWithId: doctor.id)
            guard let appointments else { continue }

            for appointment in appointments {
                let weekOfYear = calendar.component(.weekOfYear, from: appointment.createdAt)
                let year = calendar.component(.year, from: appointment.createdAt)
                let weekKey = "Week \(weekOfYear), \(year)"

                weeklyCounts[weekKey, default: 0] += 1
            }
        }

        appointmentData = [WeeklyData(week: "Week 1", count: weeklyCounts.count)]
        return weeklyCounts
    }

}
