import Foundation

extension Build {
    static func fromJson(json: [String: Any]?) -> Build? {
        guard let json = json,
            let displayName = json["displayName"] as? String,
            let timestampInt = json["timestamp"] as? Int else {
                return nil
        }

        let estimatedDuration = json["estimatedDuration"] as? Int ?? 0
        let duration = json["duration"] as? Int ?? 0
        let timestamp = Date(timeIntervalSince1970: Double(timestampInt) / 1000)
        let currentDuration = Date().timeIntervalSince(timestamp)
        let estimatedProgress = Float(currentDuration) / Float(estimatedDuration / 1000)
        let progress = duration != 0 ? Float(1) : estimatedProgress
        return Build(displayName: displayName, estimatedDuration: estimatedDuration, duration: duration, timestamp: timestamp, progress: progress)
    }
}
