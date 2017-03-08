import UIKit
import Alamofire

class MonitorViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, JobCellCreator, DataSourceDelegate {

    var timer: Timer!
    var dataSource: MonitorServiceDataSource!
    var monitorDashboard: MonitorDashboard?
    let cellIdentifier = "jobStatus"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = MonitorServiceDataSource()
        self.dataSource.jobCellCreator = self
        self.dataSource.delegate = self

        self.collectionView?.dataSource = self.dataSource
        self.collectionView?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        self.timer = Timer(fire: Date(), interval: 10.0, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.loadTable()
        })
        RunLoop.current.add(self.timer, forMode: .commonModes)
    }

    func configureCell(indexPath: IndexPath, from job: Job?) -> UICollectionViewCell {
        let cell = collectionView!.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

        guard let jobStatusCell = cell as? JobStatusCollectionViewCell else {
            return cell
        }

        guard let job = job else {
            return jobStatusCell
        }

        jobStatusCell.nameLabel.text = job.name
        jobStatusCell.backgroundColor = job.jobColor.toUIColor()
        jobStatusCell.buildProgressView.isHidden = true

        if let build = job.lastBuild {
            jobStatusCell.lastBuildTimeLabel.text = build.endTime.timeAgo(numericDates: true)
            jobStatusCell.lastBuildNumberLabel.text = build.displayName
            jobStatusCell.buildProgressView.isHidden = !job.jobColor.isBuilding()
            jobStatusCell.buildProgressView.progress = build.progress
        }

        return jobStatusCell
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }

    func loadTable() {
        guard let monitorDashboard = monitorDashboard else { return }
        self.dataSource.refreshData(url: monitorDashboard.url)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: Float = 10

        let columnsCount = monitorDashboard?.columns ?? 1
        let totalHorizontalSpacing = CGFloat(spacing * Float(columnsCount + 1))
        let columnWidth = (UIScreen.main.bounds.width - totalHorizontalSpacing) / CGFloat(columnsCount)
        let rowsCount = ceilf(Float(self.dataSource.lastResult?.jobs?.count ?? 1) / Float(columnsCount))
        let totalVerticalSpacing = CGFloat(spacing * (rowsCount + 1))
        let rowsHeight = (UIScreen.main.bounds.height - totalVerticalSpacing) / CGFloat(rowsCount)

        return CGSize(width: columnWidth, height: rowsHeight);
    }

    func dataSourceDidRefreshItems() {
        collectionView?.reloadData()
    }
}
