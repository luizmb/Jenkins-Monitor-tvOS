import Foundation

extension Job {
    static func fromJson(json: [String: Any]) -> Job? {
        guard let name = json["name"] as? String,
            let url = json["url"] as? String,
            let colorName = json["color"] as? String,
            let color = JobColor(rawValue: colorName) else {
                return nil
        }

        let lastBuild = json["lastBuild"] as? [String: Any]
        return Job(name: name, url: url, jobColor: color, lastBuild: Build.fromJson(json: lastBuild))
    }
}
