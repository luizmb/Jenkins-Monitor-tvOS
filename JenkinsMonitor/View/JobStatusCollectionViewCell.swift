import UIKit

class JobStatusCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastBuildNumberLabel: UILabel!
    @IBOutlet weak var lastBuildTimeLabel: UILabel!
    @IBOutlet weak var buildProgressView: UIProgressView!
}
