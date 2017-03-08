import UIKit

class MainViewController: UIPageViewController, UIPageViewControllerDataSource {

    var timer: Timer!
    let transitionTime = 8.0
    var isScrolling = false

    private var pages: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.dataSource = self
        self.assignPlayButton()
        self.assignMenuButton()
    }

    func assignPlayButton() {
        let playTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPressed))
        playTapRecognizer.allowedPressTypes = [NSNumber(integerLiteral: UIPressType.playPause.rawValue)]
        self.view.addGestureRecognizer(playTapRecognizer)
    }

    func playPressed() {
        isScrolling = !isScrolling
        if isScrolling {
            setupTimer()
        } else {
            self.timer.invalidate()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.pages = MonitorDashboardService().all()
            .flatMap(NavigationPage.monitor)
            .flatMap(self.storyboard!.instantiateViewController)

        guard let initialViewController = self.pages.first else {
            return
        }

        self.setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        if pages.count == 0 {
            presentConfigurationViewController()
        }
    }

    func assignMenuButton() {
        let menuTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentConfigurationViewController))
        menuTapRecognizer.allowedPressTypes = [NSNumber(integerLiteral: UIPressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuTapRecognizer)
    }

    func presentConfigurationViewController() {
        let configScene = storyboard!.instantiateViewController(withIdentifier: "configScene")
        self.present(configScene, animated: true)
    }

    func setupTimer() {
        self.timer = Timer(fire: Date(timeInterval: transitionTime, since: Date()), interval: transitionTime, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.scrollDashboards()
        })
        RunLoop.current.add(self.timer, forMode: .commonModes)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first else {
            return 0
        }
        return pages.index(of: currentViewController) ?? 0
    }

    func scrollDashboards() {
        let currentIndex = self.presentationIndex(for: self)
        let nextIndex = currentIndex >= pages.count - 2 ? 0 : currentIndex + 1
        self.setViewControllers([pages[nextIndex]], direction:.reverse, animated:true, completion: nil)
    }
}
