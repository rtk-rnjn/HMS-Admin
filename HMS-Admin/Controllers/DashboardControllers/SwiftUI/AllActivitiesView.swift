import SwiftUI

struct AllActivitiesView: View {
    let logs: [Log]
    @Environment(\.dismiss) private var dismiss
    
    // Haptic feedback generator
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        List(logs, id: \.self) { log in
            ActivityRow(log: log)
                .onTapGesture {
                    impactFeedback.prepare()
                    impactFeedback.impactOccurred(intensity: 0.5)
                }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Recent Activity")
        .navigationBarTitleDisplayMode(.large)
    }
} 