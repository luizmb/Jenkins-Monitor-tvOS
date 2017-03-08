import UIKit

enum NavigationPage {
    case monitor(MonitorDashboard)

    func instantiateViewController(storyboard: UIStoryboard) -> UIViewController {
        switch self {
        case let .monitor(monitorDashboard):
            let monitorVc = storyboard.instantiateViewController(withIdentifier: "monitorScene") as! MonitorViewController
            monitorVc.monitorDashboard = monitorDashboard
            return monitorVc
        }
    }
}

extension UIStoryboard {
    func instantiateViewController(rootPage: NavigationPage) -> UIViewController {
        return rootPage.instantiateViewController(storyboard: self)
    }
}
