# HealthTrackerApp

This repository contains a simple SwiftUI example that reads HealthKit data and presents it with a polished SwiftUI design. The app requests HealthKit authorization, aggregates the last seven days of data, and displays summary cards and a line chart using the Charts framework.

## Structure
- **HealthTrackerApp.swift** – Entry point for the app.
- **ContentView.swift** – SwiftUI view that shows summary cards and a line chart.
- **HealthDataStore.swift** – Helper class for HealthKit requests and aggregation.
- **README.md** – Documentation for the example.

## Building
1. Open `HealthTrackerApp.xcodeproj` or create a new project in Xcode 14 or later.
2. Add the files from the `HealthTrackerApp` directory to your project.
3. Ensure your app's capabilities include HealthKit.
4. Build and run on an iOS device running iOS 16 or later.

For more details see the [HealthTrackerApp README](HealthTrackerApp/README.md).
