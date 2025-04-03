import SwiftUI

struct AllActivitiesView: View {

    // MARK: Internal

    let logs: [Log]

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

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    // Haptic feedback generator
    @State private var impactFeedback: UIImpactFeedbackGenerator = .init(style: .medium)

}
