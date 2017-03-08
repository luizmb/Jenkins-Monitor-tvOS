import Foundation

extension MonitorResult {
    static func fromJson(json: [String: Any]) -> MonitorResult? {
        guard let name = json["name"] as? String,
            let jobs = json["jobs"] as? [[String: Any]] else {
                return nil
        }

        return MonitorResult(jobs: jobs.flatMap(Job.fromJson),
                             name: name)
    }
}
