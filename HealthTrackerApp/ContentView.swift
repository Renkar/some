import SwiftUI
import HealthKit
import Charts

struct ContentView: View {
    @StateObject private var store = HealthDataStore()
    
    var body: some View {
        NavigationView {
            VStack {
                if store.dataPoints.isEmpty {
                    Text("No data yet").padding()
                } else {
                    Chart(store.dataPoints) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Steps", point.value)
                        )
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day))
                    }
                    .frame(height: 200)
                }
            }
            .navigationTitle("Health Summary")
        }
        .onAppear {
            store.requestAuthorization()
            store.fetchSteps()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
