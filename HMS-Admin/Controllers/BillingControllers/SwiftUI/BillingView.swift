//
//  BillingView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

struct BillingView: View {
    // Sample data - would be replaced with real data from your database
    var invoices: [RazorpayPaymentlinkResponse] = []
    
    private var totalRevenue: Double = 0

    private var totalRefunds: Double = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Cards
                summaryCardsView
                
                // Invoice List Header
                HStack {
                    Text("Recent Payments")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        // Action to view all invoices
                    }) {
                        Text("View All")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                // Invoice List
                LazyVStack(spacing: 12) {
                    ForEach(invoices) { invoice in
                        InvoiceCard(invoice: invoice)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Billing")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // Summary Cards View
    private var summaryCardsView: some View {
        HStack(spacing: 15) {
            // Total Revenue Card
            SummaryCardView(
                title: "Total Revenue",
                amount: totalRevenue,
                icon: "dollarsign.circle.fill",
                color: .blue
            )
            
            // Total Refunds Card
            SummaryCardView(
                title: "Total Refunds",
                amount: totalRefunds,
                icon: "arrow.counterclockwise.circle.fill",
                color: .red
            )
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }
}

// Summary Card View
struct SummaryCardView: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Card Header with icon
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            Spacer()
            
            // Amount
            Text(String(format: "$%.2f", amount))
                .font(.title2)
                .fontWeight(.bold)
            
            // Title
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct InvoiceCard: View {
    let invoice: Invoice

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(invoice.patientName)
                        .font(.headline)
                    Text(invoice.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Text(String(format: "$%.2f", invoice.amount))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(invoice.status == "Completed" ? .blue : 
                                   invoice.status == "Cancelled" ? .red : .orange)
            }
            
            HStack {
                // Payment method
                Label("Credit Card", systemImage: "creditcard")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                InvoiceStatusBadge(status: invoice.status)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}

struct InvoiceStatusBadge: View {
    let status: String

    var backgroundColor: Color {
        switch status {
        case "Completed": return .blue
        case "Pending": return .orange
        case "Cancelled": return .red
        default: return .gray
        }
    }

    var body: some View {
        Text(status)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor.opacity(0.15))
            .foregroundColor(backgroundColor)
            .cornerRadius(6)
    }
}

#Preview {
    NavigationView {
        BillingView()
    }
}
