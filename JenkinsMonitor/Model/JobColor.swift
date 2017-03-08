import Foundation
import UIKit

enum JobColor: String {
    case blue = "blue"
    case blueAnime = "blue_anime"
    case red = "red"
    case redAnime = "red_anime"
    case yellow = "yellow"
    case yellowAnime = "yellow_anime"
    case aborted = "aborted"
    case abortedAnime = "aborted_anime"

    func isBuilding() -> Bool {
        return [.blueAnime, .redAnime, .yellowAnime, .abortedAnime].contains(self)
    }

    func toUIColor() -> UIColor {
        switch self {
        case .blue, .blueAnime:
            return .init(red: 0.0, green: 0.39, blue: 0.0, alpha: 1.0)
        case .yellow, .yellowAnime:
            return .yellow
        case .red, .redAnime:
            return .red
        case .aborted, .abortedAnime:
            return .darkGray
        }
    }
}
