# HealthTrackerApp

This is a minimal SwiftUI application that demonstrates how to read step data
from HealthKit and present it in a simple line chart. The app requests access
to HealthKit, aggregates step counts for the last 7 days, and displays a chart
using the Charts framework.

## Files
- `HealthTrackerApp.swift` – Main entry point for the SwiftUI app.
- `ContentView.swift` – Displays a chart of step data.
- `HealthDataStore.swift` – Handles HealthKit authorization and data queries.

The code requires iOS 16 or later for the `Charts` framework.
