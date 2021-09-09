import Foundation
import UIKit

@IBDesignable
class ChipButton: UIButton {
    
    override func prepareForInterfaceBuilder() {
        initUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    private func initUI() {
        titleLabel?.sizeToFit()
        layer.cornerRadius = frame.height/2
        backgroundColor = .red

        addTarget(self, action: #selector(onPress(_:)), for: .touchUpInside)
    }
    
    @objc func onPress(_ sender: UIView) {
        UIView.animate(withDuration: 0.1, animations:  {
            self.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }, completion: { (isComplete) in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
}
