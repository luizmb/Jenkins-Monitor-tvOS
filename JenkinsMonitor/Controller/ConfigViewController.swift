import UIKit

class ConfigViewController: UITableViewController, DashboardCellCreator, DataSourceDelegate {
    var dataSource: DashboardListDataSource!
    let cellIdentifier = "dashboardRow"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = DashboardListDataSource()
        self.dataSource.dashboardCellCreator = self
        self.dataSource.delegate = self

        self.tableView?.dataSource = self.dataSource
        self.tableView?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.refreshData()
    }

    func configureCell(indexPath: IndexPath, from dashboard: MonitorDashboard?) -> UITableViewCell {
        let cell = tableView!.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        guard let dashboardCell = cell as? DashboardRowCell else {
            return cell
        }

        guard let dashboard = dashboard else {
            return dashboardCell
        }

        dashboardCell.urlLabel.text = dashboard.url
        dashboardCell.columnsLabel.text = "\(dashboard.columns)"
        return dashboardCell
    }

    func dataSourceDidRefreshItems() {
        self.tableView.reloadData()
    }

    @IBAction func trashButtonPressed(_ sender: Any) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }

    @IBAction func addMonitor(_ sender: Any) {
        let detailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "editMonitor")
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "editMonitor") as? EditMonitorViewController else {
            return
        }

        let monitor = self.dataSource.dashboardList[indexPath.row]
        detailsViewController.editMonitor(monitor: monitor)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
