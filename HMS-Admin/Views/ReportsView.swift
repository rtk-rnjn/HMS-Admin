//
//  ReportsView.swift
//  HMS-Admin
//

//

import SwiftUI
import Charts

struct ReportsView: View {
    weak var delegate: ReportsHostingController?
    // MARK: Internal

    var body: some View {
        NavigationView {
            mainContentView
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    // Metrics data (sample)
    var metrics: [MetricData] = []

    // MARK: - Sample Data

    var appointmentData: [WeeklyData] = []

    private var dateRangeText: String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        // Get the first day of current month
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonth
        components.day = 1
        let startDate = calendar.date(from: components)!

        // Get the last day of current month
        components.month = currentMonth + 1
        components.day = 0
        let endDate = calendar.date(from: components)!

        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate)), \(currentYear)"
    }

    // MARK: - Content Views

    private var mainContentView: some View {
        ScrollView {
            VStack(spacing: 25) {
                timeSelectionView
                metricsGridView
                appointmentsOverviewSection
            }
            .padding(.vertical)
        }
        .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
        .navigationTitle("Reports Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
        }
    }

    private var timeSelectionView: some View {
        VStack(spacing: 8) {
            Text(dateRangeText)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    private var metricsGridView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            ForEach(metrics) { metric in
                MetricCardView(metric: metric)
            }
        }
        .padding(.horizontal)
    }

    private var appointmentsOverviewSection: some View {
        ReportSectionView(title: "Appointments Overview") {
            VStack(spacing: 20) {
                appointmentsChartView
//                appointmentsMetricsView
            }
        }
    }

    private var appointmentsChartView: some View {
        Group {
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(appointmentData, id: \.week) { item in
                        LineMark(
                            x: .value("Week", item.week),
                            y: .value("Count", item.count)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 0...40)
            }
        }
    }

    private var appointmentsMetricsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 10) {
            AppointmentMetricView(title: "Scheduled", value: "124", color: .blue)
            AppointmentMetricView(title: "Completed", value: "98", color: Color(red: 0.2, green: 0.5, blue: 0.8))
            AppointmentMetricView(title: "Cancelled", value: "18", color: Color(red: 0.4, green: 0.6, blue: 0.9))
        }
    }

    private var revenueMetricsView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            RevenueMetricView(title: "Total Revenue", value: "$45,230", icon: "dollarsign.circle", color: .blue)
            RevenueMetricView(title: "Net Profit", value: "$17,380", icon: "chart.line.uptrend.xyaxis", color: Color(red: 0.2, green: 0.5, blue: 0.8))
        }
    }
}

// MARK: - Supporting Views

// Section Container
struct ReportSectionView<Content: View>: View {

    // MARK: Lifecycle

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    // MARK: Internal

    let title: String
    let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 15) {
                content
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
}

// Metric Card
struct MetricCardView: View {
    let metric: MetricData

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: metric.icon)
                    .font(.headline)
                    .foregroundColor(metric.color)
                    .frame(width: 30, height: 30)
                    .background(metric.color.opacity(0.1))
                    .cornerRadius(8)

                Spacer()

                Text("")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(metric.isPositive ? .green : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        (metric.isPositive ? Color.green : Color.red)
                            .opacity(0.1)
                    )
                    .cornerRadius(12)
            }

            Text(metric.value)
                .font(.title2)
                .fontWeight(.bold)

            Text(metric.title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// Appointment Metric View
struct AppointmentMetricView: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// Doctor Card View
struct DoctorCardView: View {
    let doctor: DoctorPerformance

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Doctor info section
            HStack {
                Image(systemName: doctor.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("iconBlue"))
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)

                    Text(doctor.specialty)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.leading, 12)

                Spacer()
            }

            Divider()
                .padding(.top, 8)

            // Patients section
            HStack(alignment: .center) {
                // Patient count
                HStack(spacing: 6) {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("iconBlue"))
                        .font(.callout)

                    Text("\(doctor.patients)")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 8)
        }
        .padding(16)
        .frame(width: 320)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(UIColor.systemGray5), lineWidth: 1)
        )
    }
}

// Staff Metric View
struct StaffMetricView: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(Color("iconBlue"))
                .frame(width: 24, height: 24)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

// Revenue Metric View
struct RevenueMetricView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color("iconBlue"))
                .frame(width: 36, height: 36)
                .background(color.opacity(0.1))
                .cornerRadius(18)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// Simple Line Chart (iOS 15 Fallback)
struct SimpleLineChartView: View {

    // MARK: Internal

    let data: [Double]
    let labels: [String]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Chart
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0..<data.count, id: \.self) { index in
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 2, height: getHeight(for: data[index], in: geometry))

                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)

                            Text(labels[index])
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 5)
                        .frame(width: (geometry.size.width - 40) / CGFloat(data.count))
                    }
                }
                .frame(height: geometry.size.height * 0.85)

                // Zero line
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
            }
            .padding(.top, 10)
        }
    }

    // MARK: Private

    private func getHeight(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        let maxValue = data.max() ?? 1
        let availableHeight = geometry.size.height * 0.8
        return CGFloat(value / maxValue) * availableHeight
    }
}

// Simple Bar Chart (iOS 15 Fallback)
struct SimpleBarChartView: View {

    // MARK: Internal

    let data: [Double]
    let labels: [String]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Chart
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(0..<data.count, id: \.self) { index in
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .frame(width: min(40, (geometry.size.width - 80) / CGFloat(data.count)), height: getHeight(for: data[index], in: geometry))

                            Text(labels[index])
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .frame(width: (geometry.size.width - 40) / CGFloat(data.count))
                    }
                }
                .frame(height: geometry.size.height * 0.85)

                // Zero line
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
            }
            .padding(.top, 10)
        }
    }

    // MARK: Private

    private func getHeight(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        let maxValue = data.max() ?? 1
        let availableHeight = geometry.size.height * 0.8
        return CGFloat(value / maxValue) * availableHeight
    }
}

// MARK: - Data Models

// Metric Data Model
struct MetricData: Identifiable {
    let id: UUID = .init()
    let title: String
    let value: String
    let icon: String
    let isPositive: Bool
    let color: Color
}

// Monthly Data Model
struct WeeklyData {
    let week: String
    let count: Int
}

// Doctor Performance Model
struct DoctorPerformance: Identifiable {
    let id: UUID = .init()
    let name: String
    let specialty: String
    let patients: Int
    let image: String
}

// Staff Performance Model
struct StaffPerformance: Identifiable {
    let id: UUID = .init()
    let department: String
    let efficiency: Int
    let icon: String
}

// Revenue Data Model
struct RevenueData {
    let month: String
    let revenue: Double
}

#Preview {
    ReportsView()
}
