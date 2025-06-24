import Foundation
import HealthKit

struct DataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

class HealthDataStore: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var dataPoints: [DataPoint] = []
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let steps = HKObjectType.quantityType(forIdentifier: .stepCount)!
        healthStore.requestAuthorization(toShare: [], read: [steps]) { success, error in
            if !success {
                print("Authorization failed")
            }
        }
    }
    
    func fetchSteps() {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        query.initialResultsHandler = { [weak self] _, results, error in
            guard let self = self else { return }
            guard let results = results else { return }
            var newPoints: [DataPoint] = []
            results.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let value = sum.doubleValue(for: .count())
                    newPoints.append(DataPoint(date: statistics.startDate, value: value))
                }
            }
            DispatchQueue.main.async {
                self.dataPoints = newPoints
            }
        }
        healthStore.execute(query)
    }
}
