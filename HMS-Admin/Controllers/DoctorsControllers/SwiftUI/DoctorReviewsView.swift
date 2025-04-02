import SwiftUI

struct DoctorReviewsView: View {
    let doctor: Staff
    @Environment(\.dismiss) var dismiss
    @State private var reviews: [Review] = []
    @State private var sortOrder: SortOrder = .none
    
    enum SortOrder {
        case none
        case highestRating
        case lowestRating
    }
    
    var sortedReviews: [Review] {
        switch sortOrder {
        case .none:
            return reviews
        case .highestRating:
            return reviews.sorted { $0.rating > $1.rating }
        case .lowestRating:
            return reviews.sorted { $0.rating < $1.rating }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(sortedReviews) { review in
                    ReviewDetailCard(review: review)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                dismiss()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 16, weight: .regular))
                }
                .foregroundColor(.blue)
            },
            trailing: Menu {
                Button(action: {
                    sortOrder = .highestRating
                }) {
                    Label("Highest Rating", systemImage: "star.fill")
                }
                Button(action: {
                    sortOrder = .lowestRating
                }) {
                    Label("Lowest Rating", systemImage: "star")
                }
                if sortOrder != .none {
                    Button(action: {
                        sortOrder = .none
                    }) {
                        Label("Clear Filter", systemImage: "xmark")
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
        )
        .navigationTitle("Reviews")
        .onAppear {
            loadReviews()
        }
    }
    
    private func loadReviews() {
        // Temporary mock data for testing
        reviews = [
            Review(patientName: "Patient 1",
                  rating: 4.5,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
            Review(patientName: "Patient 1",
                  rating: 4.0,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
            Review(patientName: "Patient 1",
                  rating: 4.5,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
            Review(patientName: "Patient 1",
                  rating: 4.5,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date()),
            Review(patientName: "Patient 1",
                  rating: 4.5,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date())
        ]
    }
}

struct ReviewDetailCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Patient name and date in one row
            HStack {
                Text(review.patientName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(review.date.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            // Review comment
            Text(review.comment)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
            
            // Rating at the bottom
            HStack(spacing: 4) {
                Text(String(format: "%.1f", review.rating))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 16))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 255/255, green: 255/255, blue: 255/255))
        .cornerRadius(16)
        .padding(.horizontal)
    }
} 