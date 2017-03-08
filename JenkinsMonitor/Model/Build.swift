import Foundation

struct Build {
    var displayName: String
    var estimatedDuration: Int
    var duration: Int
    var timestamp: Date
    var endTime: Date {
        get {
            return timestamp.addingTimeInterval(Double(duration) / 1000)
        }
    }
    var progress: Float
}
