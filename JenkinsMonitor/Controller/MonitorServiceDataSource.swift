import UIKit

protocol JobCellCreator: class {
    func configureCell(indexPath: IndexPath, from job: Job?) -> UICollectionViewCell
}

protocol DataSourceDelegate: class {
    func dataSourceDidRefreshItems()
}

class MonitorServiceDataSource: NSObject, UICollectionViewDataSource {

    weak var jobCellCreator: JobCellCreator?
    weak var delegate: DataSourceDelegate?

    var lastResult: MonitorResult? {
        didSet {
            self.delegate?.dataSourceDidRefreshItems()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lastResult?.jobs?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let jobCellCreator = jobCellCreator else {
            return UICollectionViewCell()
        }

        return jobCellCreator.configureCell(indexPath: indexPath, from: lastResult?.jobs?[indexPath.row])
    }

    func refreshData(url: String) {
        MonitorService().getMonitor(with: url) { [weak self] (monitorResult, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error)
                return
            }

            strongSelf.lastResult = monitorResult
        }
    }

}
