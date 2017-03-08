import UIKit

class EditMonitorViewController: UIViewController {

    var monitor = MonitorDashboard(url: "https://", columns: 3)

    @IBOutlet weak var columnsCountLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard Details"

        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = backButton

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveButton

        self.urlTextField.text = monitor.url
        self.columnsCountLabel.text = "\(monitor.columns)"
    }

    @IBAction func moreColumnsButtonPressed(_ sender: Any) {
        guard self.monitor.columns < 6 else { return }
        self.monitor.columns += 1
        self.columnsCountLabel.text = "\(monitor.columns)"
    }

    @IBAction func lessColumnsButtonPressed(_ sender: Any) {
        guard self.monitor.columns > 1 else { return }
        self.monitor.columns -= 1
        self.columnsCountLabel.text = "\(monitor.columns)"
    }

    func editMonitor(monitor: MonitorDashboard) {
        self.monitor = monitor
    }

    internal func cancel() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    internal func save() {
        guard let url = urlTextField.text,
                  !url.isEmpty else {
            urlTextField.becomeFirstResponder()
            return
        }
        monitor.url = url
        MonitorDashboardService().save(monitor)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
