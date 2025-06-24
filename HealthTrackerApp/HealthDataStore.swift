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
    @Published var totalSteps: Double = 0
    @Published var totalDistance: Double = 0 // in kilometers
    @Published var totalActiveEnergy: Double = 0 // in kilocalories
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let types: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        healthStore.requestAuthorization(toShare: [], read: types) { success, error in
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

    func fetchSummary() {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!

        let stepQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let self = self else { return }
            let value = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                self.totalSteps = value
            }
        }

        let energyQuery = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let self = self else { return }
            let value = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            DispatchQueue.main.async {
                self.totalActiveEnergy = value
            }
        }

        let distanceQuery = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, _ in
            guard let self = self else { return }
            let value = result?.sumQuantity()?.doubleValue(for: .meter()) ?? 0
            DispatchQueue.main.async {
                self.totalDistance = value / 1000
            }
        }

        healthStore.execute(stepQuery)
        healthStore.execute(energyQuery)
        healthStore.execute(distanceQuery)
    }
}
