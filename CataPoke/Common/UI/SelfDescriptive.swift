import UIKit

protocol SelfDescriptive {
    static var selfDescription: String { get }
}

extension SelfDescriptive where Self: UIView {
    static var selfDescription: String {
        String(describing: self)
    }
}
