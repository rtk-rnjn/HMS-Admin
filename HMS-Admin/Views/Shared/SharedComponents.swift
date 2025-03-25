import SwiftUI

// This file contains shared UI components used across multiple views

struct StatusBadge: View {
    let isActive: Bool
    
    var body: some View {
        Text(isActive ? "Active" : "Inactive")
            .font(.callout)
            .fontWeight(.medium)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isActive ? Color.green : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
} 