//
//  ReportsView.swift
//  HMS-Admin
//
//  Created by Claude on 28/04/25.
//

import SwiftUI
import Charts

struct ReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // Time filter selection
    @State private var selectedTimeRange = 1 // 0: Day, 1: Week, 2: Month, 3: Year
    private let timeRanges = ["Day", "Week", "Month", "Year"]
    
    // Metrics data (sample)
    private let metrics: [MetricData] = [
        MetricData(title: "Appointments", value: "124", icon: "calendar", growth: "+12%", isPositive: true, color: Color("iconBlue")),
        MetricData(title: "Revenue", value: "$12,450", icon: "dollarsign.circle", growth: "+8%", isPositive: true, color: Color("iconBlue"))
    ]
    
    // Top doctors data (sample)
    private let topDoctors: [DoctorPerformance] = [
        DoctorPerformance(name: "Dr. Smith", specialty: "Cardiology", rating: 4.9, patients: 124, image: "person.crop.circle.fill"),
        DoctorPerformance(name: "Dr. Johnson", specialty: "Neurology", rating: 4.8, patients: 98, image: "person.crop.circle.fill"),
        DoctorPerformance(name: "Dr. Williams", specialty: "Pediatrics", rating: 4.7, patients: 112, image: "person.crop.circle.fill"),
        DoctorPerformance(name: "Dr. Jones", specialty: "Orthopedics", rating: 4.6, patients: 86, image: "person.crop.circle.fill"),
        DoctorPerformance(name: "Dr. Brown", specialty: "Oncology", rating: 4.5, patients: 74, image: "person.crop.circle.fill")
    ]
    
    var body: some View {
        NavigationView {
            mainContentView
        }
    }
    
    // MARK: - Content Views
    
    private var mainContentView: some View {
        ScrollView {
            VStack(spacing: 25) {
                timeSelectionView
                metricsGridView
                appointmentsOverviewSection
                doctorPerformanceSection
                staffPerformanceSection
                revenueAnalyticsSection
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Filter options
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
    
    private var timeSelectionView: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(0..<timeRanges.count, id: \.self) { index in
                Text(timeRanges[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
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
                appointmentsMetricsView
            }
        }
    }
    
    private var appointmentsChartView: some View {
        Group {
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(appointmentData, id: \.month) { item in
                        LineMark(
                            x: .value("Month", item.month),
                            y: .value("Count", item.count)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 0...150)
            } else {
                // Fallback for iOS 15
                SimpleLineChartView(data: appointmentData.map { Double($0.count) }, labels: appointmentData.map { $0.month })
                    .frame(height: 200)
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
    
    private var doctorPerformanceSection: some View {
        ReportSectionView(title: "Doctor Performance") {
            VStack(alignment: .leading, spacing: 15) {
                Text("Top Performing Doctors")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(topDoctors) { doctor in
                            DoctorCardView(doctor: doctor)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
    
    private var staffPerformanceSection: some View {
        ReportSectionView(title: "Staff Performance") {
            VStack(spacing: 15) {
                staffPerformanceChartView
                staffPerformanceMetricsView
            }
        }
    }
    
    private var staffPerformanceChartView: some View {
        Group {
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(staffPerformance, id: \.department) { item in
                        BarMark(
                            x: .value("Department", item.department),
                            y: .value("Efficiency", item.efficiency)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .cornerRadius(8)
                    }
                }
                .frame(height: 220)
                .chartYScale(domain: 0...100)
            } else {
                // Fallback for iOS 15
                SimpleBarChartView(
                    data: staffPerformance.map { Double($0.efficiency) },
                    labels: staffPerformance.map { $0.department }
                )
                .frame(height: 220)
            }
        }
    }
    
    private var staffPerformanceMetricsView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            ForEach(staffPerformance) { staff in
                StaffMetricView(title: staff.department, value: "\(staff.efficiency)%", icon: staff.icon)
            }
        }
    }
    
    private var revenueAnalyticsSection: some View {
        ReportSectionView(title: "Revenue Analytics") {
            VStack(spacing: 15) {
                revenueMetricsView
                revenueChartView
            }
        }
    }
    
    private var revenueMetricsView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            RevenueMetricView(title: "Total Revenue", value: "$45,230", icon: "dollarsign.circle", color: .blue)
            RevenueMetricView(title: "Net Profit", value: "$17,380", icon: "chart.line.uptrend.xyaxis", color: Color(red: 0.2, green: 0.5, blue: 0.8))
        }
    }
    
    private var revenueChartView: some View {
        Group {
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(revenueData, id: \.month) { item in
                        LineMark(
                            x: .value("Month", item.month),
                            y: .value("Revenue", item.revenue)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                        
                        AreaMark(
                            x: .value("Month", item.month),
                            y: .value("Revenue", item.revenue)
                        )
                        .foregroundStyle(
                            .linearGradient(
                                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.01)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 0...50000)
            } else {
                // Fallback for iOS 15
                SimpleLineChartView(
                    data: revenueData.map { $0.revenue / 1000 }, // Scale down for display
                    labels: revenueData.map { $0.month }
                )
                .frame(height: 200)
            }
        }
    }
    
    // MARK: - Sample Data
    
    // Appointment data (sample)
    private let appointmentData = [
        MonthlyData(month: "Jan", count: 65),
        MonthlyData(month: "Feb", count: 78),
        MonthlyData(month: "Mar", count: 95),
        MonthlyData(month: "Apr", count: 82),
        MonthlyData(month: "May", count: 90),
        MonthlyData(month: "Jun", count: 105)
    ]
    
    // Staff performance data (sample)
    private let staffPerformance = [
        StaffPerformance(department: "Ortho", efficiency: 92, icon: "figure.walk"),
        StaffPerformance(department: "Cardiology", efficiency: 85, icon: "heart"),
        StaffPerformance(department: "Neurology", efficiency: 88, icon: "brain.head.profile"),
        StaffPerformance(department: "Pediatrics", efficiency: 91, icon: "figure.child")
    ]
    
    // Revenue data (sample)
    private let revenueData = [
        RevenueData(month: "Jan", revenue: 32450),
        RevenueData(month: "Feb", revenue: 35780),
        RevenueData(month: "Mar", revenue: 41200),
        RevenueData(month: "Apr", revenue: 38900),
        RevenueData(month: "May", revenue: 42350),
        RevenueData(month: "Jun", revenue: 45230)
    ]
}

// MARK: - Supporting Views

// Section Container
struct ReportSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
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
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(metric.color)
                    .frame(width: 30, height: 30)
                    .background(metric.color.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(metric.growth)
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
            
            // Ratings & Patients section
            HStack(alignment: .center) {
                // Star rating
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= Int(doctor.rating) ? "star.fill" : "star")
                            .font(.system(size: 16))
                            .foregroundColor(index <= Int(doctor.rating) ? .yellow : Color(UIColor.systemGray4))
                    }
                }
                
                Text(String(format: "%.1f", doctor.rating))
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading, 8)
                
                Spacer()
                
                // Patient count
                HStack(spacing: 6) {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("iconBlue"))
                        .font(.system(size: 16))
                    
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
    
    private func getHeight(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        let maxValue = data.max() ?? 1
        let availableHeight = geometry.size.height * 0.8
        return CGFloat(value / maxValue) * availableHeight
    }
}

// Simple Bar Chart (iOS 15 Fallback)
struct SimpleBarChartView: View {
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
    
    private func getHeight(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        let maxValue = data.max() ?? 1
        let availableHeight = geometry.size.height * 0.8
        return CGFloat(value / maxValue) * availableHeight
    }
}

// MARK: - Data Models

// Metric Data Model
struct MetricData: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let icon: String
    let growth: String
    let isPositive: Bool
    let color: Color
}

// Monthly Data Model
struct MonthlyData {
    let month: String
    let count: Int
}

// Doctor Performance Model
struct DoctorPerformance: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let rating: Double
    let patients: Int
    let image: String
}

// Staff Performance Model
struct StaffPerformance: Identifiable {
    let id = UUID()
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
