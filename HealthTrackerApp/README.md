# HealthTrackerApp

This SwiftUI application reads several HealthKit metrics and presents them with
a colorful design. It aggregates the last 7 days of steps, distance and active
energy. A gradient background, summary cards and a line chart illustrate the
collected data.

## Files
- `HealthTrackerApp.swift` – Main entry point for the SwiftUI app.
- `ContentView.swift` – Shows summary cards and a line chart of step data.
- `HealthDataStore.swift` – Handles HealthKit authorization, aggregation and
  queries.

The code requires iOS 16 or later for the `Charts` framework.
