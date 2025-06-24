import SwiftUI
import HealthKit
import Charts

struct ContentView: View {
    @StateObject private var store = HealthDataStore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        SummaryCard(title: "Steps", value: Int(store.totalSteps).formatted())
                        SummaryCard(title: "Distance (km)", value: String(format: "%.1f", store.totalDistance))
                        SummaryCard(title: "Calories", value: String(format: "%.0f", store.totalActiveEnergy))
                    }
                    .padding(.horizontal)

                    if store.dataPoints.isEmpty {
                        Text("No data yet").padding()
                    } else {
                        Chart(store.dataPoints) { point in
                            LineMark(
                                x: .value("Date", point.date),
                                y: .value("Steps", point.value)
                            )
                            .interpolationMethod(.cardinal)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day))
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Health Summary")
            }
            .background(
                LinearGradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
        }
        .onAppear {
            store.requestAuthorization()
            store.fetchSteps()
            store.fetchSummary()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SummaryCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.25))
        )
    }
}
