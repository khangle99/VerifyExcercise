import Foundation
import UIKit

@IBDesignable
class SemiChipButton: UIButton {
    private var scaleSize: CGFloat = 0 // dua theo height
    private var cornerRadius: CGFloat = 0
    private var minorRadius: CGFloat = 0
    
    init(frame: CGRect, shouldInvert: Bool = false) {
        super.init(frame: frame)
        initUI(shouldInvert: shouldInvert)
    }
    
    private func initUI(shouldInvert: Bool) {
        scaleSize = frame.size.height
        cornerRadius = scaleSize/2
        minorRadius = cornerRadius/5
        addTarget(self, action: #selector(simpleClick(_:)), for: .touchUpInside)
        layer.cornerRadius = minorRadius
        if (shouldInvert) {
            roundCorners(corners: [.topRight, .bottomRight], radius: cornerRadius)
        } else {
            roundCorners(corners: [.topLeft, .bottomLeft], radius: cornerRadius)
        }
    }
    override func prepareForInterfaceBuilder() {
        initUI(shouldInvert: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func simpleClick(_ sender: UIButton) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.05) { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        } completion: { (isComplete) in
            UIView.animate(withDuration: 0.05) { [weak self] in
                self?.transform = .identity
                self?.isUserInteractionEnabled = true
            }
        }
    }
    
}
