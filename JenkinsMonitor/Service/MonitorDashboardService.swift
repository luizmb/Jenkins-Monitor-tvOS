import UIKit

class MonitorDashboardService: NSObject {

    func all() -> [MonitorDashboard] {
        let monitorStorage = UserDefaults.standard

        guard let objMonitor = monitorStorage.object(forKey: "monitors"),
              let binaryData = objMonitor as? Data,
              let keyedArchive = NSKeyedUnarchiver.unarchiveObject(with: binaryData),
              let decodedMonitors = keyedArchive as? [MonitorDashboard]
        else {
            return []
        }

        return decodedMonitors
    }

    func save(_ monitor: MonitorDashboard) {
        var collection = all()
        if let updateIndex = collection.index(where: { $0.id == monitor.id }) {
            collection[updateIndex] = monitor
        } else {
            collection.append(monitor)
        }

        let monitorStorage = UserDefaults.standard
        let binaryList = NSKeyedArchiver.archivedData(withRootObject: collection)
        monitorStorage.set(binaryList, forKey: "monitors")
    }

    func delete(_ monitor: MonitorDashboard) {
        var collection = all()
        guard let deleteIndex = collection.index(where: { $0.id == monitor.id }) else {
            return
        }

        collection.remove(at: deleteIndex)
        let monitorStorage = UserDefaults.standard
        let binaryList = NSKeyedArchiver.archivedData(withRootObject: collection)
        monitorStorage.set(binaryList, forKey: "monitors")
    }
}
