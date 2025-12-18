import Foundation

// MARK: - Sleep Day Model
struct SleepDay: Identifiable {
    let id = UUID()
    let label: String       // e.g. "Mon"
    let hours: Double       // e.g. 7.5
    let quality: String     // e.g. "Good"
}

extension SleepDay {
    static let sampleWeek: [SleepDay] = [
        SleepDay(label: "Mon", hours: 7.5, quality: "Good"),
        SleepDay(label: "Tue", hours: 6.8, quality: "Okay"),
        SleepDay(label: "Wed", hours: 8.2, quality: "Great"),
        SleepDay(label: "Thu", hours: 5.9, quality: "Poor"),
        SleepDay(label: "Fri", hours: 7.0, quality: "Good"),
        SleepDay(label: "Sat", hours: 8.5, quality: "Great"),
        SleepDay(label: "Sun", hours: 7.3, quality: "Good")
    ]
}


