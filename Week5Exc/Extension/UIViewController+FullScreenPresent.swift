import Foundation
import UIKit

extension UIViewController {
    func presentFullScreen(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
    }
}
