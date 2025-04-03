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
    
    // Current and previous month data
    private var currentMonthDoctorCount: Int = 0
    private var previousMonthDoctorCount: Int = 0
    private var currentMonthPatientCount: Int = 0
    private var previousMonthPatientCount: Int = 0

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

    // MARK: - Navigation

    func showReports() {
        let reportsController = ReportsHostingController()
        reportsController.modalPresentationStyle = .formSheet
        navigationController?.present(reportsController, animated: true)
    }

    func fetchLogs() async -> [Log] {
        let logs: [Log]? = await DataController.shared.fetchLogs()
        guard let logs else {
            return []
        }

        return logs
    }

    // MARK: Private

    private func updateUI() {
        Task {
            await fetchDoctorCounts()
            DispatchQueue.main.async {
                self.rootView.activeDoctorCount = self.currentMonthDoctorCount
                self.rootView.doctorTrend = self.calculatePercentageChange(
                    current: self.currentMonthDoctorCount,
                    previous: self.previousMonthDoctorCount
                )
            }
        }

        Task {
            await fetchPatientCounts()
            DispatchQueue.main.async {
                self.rootView.patientCount = self.currentMonthPatientCount
                self.rootView.patientTrend = self.calculatePercentageChange(
                    current: self.currentMonthPatientCount,
                    previous: self.previousMonthPatientCount
                )
            }
        }

        Task {
            let logs = await fetchLogs()
            DispatchQueue.main.async {
                self.rootView.logs = logs
            }
        }
    }
    
    // Calculate percentage change between current and previous values
    private func calculatePercentageChange(current: Int, previous: Int) -> String {
        guard previous > 0 else {
            return current > 0 ? "+100%" : "0%"
        }
        
        let change = current - previous
        let percentage = (Double(change) / Double(previous)) * 100.0
        
        let sign = percentage >= 0 ? "+" : ""
        return "\(sign)\(Int(percentage))%"
    }
    
    // Fetch current and previous month doctor counts
    private func fetchDoctorCounts() async {
        // Current month
        guard let currentMonthDoctors = await DataController.shared.fetchDoctors() else {
            currentMonthDoctorCount = 0
            previousMonthDoctorCount = 0
            return
        }
        
        currentMonthDoctorCount = currentMonthDoctors.count
        
        // Use 80% of current value for previous month in this demo
        // In a real app, you would fetch historical data from your database
        previousMonthDoctorCount = Int(Double(currentMonthDoctorCount) * 0.8)
    }
    
    // Fetch current and previous month patient counts
    private func fetchPatientCounts() async {
        // Get patient count for current month
        guard let doctors = await DataController.shared.fetchDoctors() else {
            currentMonthPatientCount = 0
            previousMonthPatientCount = 0
            return
        }
        
        var uniquePatients: [String: Int] = [:]
        
        for doctor in doctors {
            let appointments: [Appointment]? = await DataController.shared.fetchAppointments(byDoctorWithId: doctor.id)
            guard let appointments else { continue }
            
            for appointment in appointments {
                uniquePatients[appointment.patientId] = 0
            }
        }
        
        currentMonthPatientCount = uniquePatients.count
        
        // Use 70% of current value for previous month in this demo
        // In a real app, you would fetch historical data from your database
        previousMonthPatientCount = Int(Double(currentMonthPatientCount) * 0.7)
    }
}
