import UIKit

enum StepAction {
    case push(UIViewController)
    case present(UIViewController, UIModalPresentationStyle)
    case dismiss
    case pop
    case none
}
