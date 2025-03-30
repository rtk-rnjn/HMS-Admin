//
//  BillingView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

struct BillingView: View {
    var invoices: [Invoice] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                LazyVStack(spacing: 12) {
                    ForEach(invoices) { invoice in
                        InvoiceCard(invoice: invoice)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.large)
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

                InvoiceStatusBadge(status: invoice.status)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct InvoiceStatusBadge: View {
    let status: String

    var backgroundColor: Color {
        switch status {
        case "Completed": return .green
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
            .background(backgroundColor.opacity(0.2))
            .foregroundColor(backgroundColor)
            .clipShape(Capsule())
    }
}
