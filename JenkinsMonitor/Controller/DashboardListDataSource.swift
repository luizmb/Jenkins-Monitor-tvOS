import UIKit

protocol DashboardCellCreator: class {
    func configureCell(indexPath: IndexPath, from dashboard: MonitorDashboard?) -> UITableViewCell
}

class DashboardListDataSource: NSObject, UITableViewDataSource {

    weak var dashboardCellCreator: DashboardCellCreator?
    weak var delegate: DataSourceDelegate?
    var dashboardList: [MonitorDashboard] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dashboardCellCreator = dashboardCellCreator else {
            return UITableViewCell()
        }

        return dashboardCellCreator.configureCell(indexPath: indexPath, from: dashboardList[indexPath.row])
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }

        let monitor = self.dashboardList[indexPath.row]
        MonitorDashboardService().delete(monitor)
        dashboardList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    func refreshData() {
        self.dashboardList = MonitorDashboardService().all()
        self.delegate?.dataSourceDidRefreshItems()
    }
}
