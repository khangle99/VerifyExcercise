import Foundation
import UIKit

@IBDesignable
class SmoothStepper: UIView {
    var counter = 0
    let countLabel: UILabel = UILabel()
  
    private var leftSemi: SemiChipButton!
    private var rightSemi: SemiChipButton!
    
    var primeColor: UIColor = UIColor.red {
        didSet {
            leftSemi.backgroundColor = primeColor
            rightSemi.backgroundColor = primeColor
        }
    }
    
    @objc func minus(_sender: SemiChipButton) {
        if counter != 0 {
            counter -= 1
            countLabel.text = "\(counter)"
        }
    }
    
    @objc func plus(_sender: SemiChipButton) {
        counter += 1
        countLabel.text = "\(counter)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        self.setupView()
    }
    
    private func setupView() {
        leftSemi = SemiChipButton(frame: CGRect(x: 0, y: 0, width: bounds.height*3/2, height: bounds.height), shouldInvert: false)
        leftSemi.translatesAutoresizingMaskIntoConstraints = false
        leftSemi.setTitle("-", for: .normal)
        addSubview(leftSemi)
        rightSemi = SemiChipButton(frame: CGRect(x: frame.height*1.5 + 4, y: 0, width: (bounds.height*3)/2, height: bounds.height), shouldInvert: true)
        rightSemi.translatesAutoresizingMaskIntoConstraints = false
        rightSemi.setTitle("+", for: .normal)
        addSubview(rightSemi)
        countLabel.textAlignment =  .center
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.text = "\(counter)"
        addSubview(countLabel)
        // layout
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftSemi.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftSemi.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftSemi.heightAnchor.constraint(equalToConstant: leftSemi.frame.height),
            leftSemi.widthAnchor.constraint(equalToConstant: leftSemi.frame.width),
            rightSemi.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightSemi.leadingAnchor.constraint(equalTo: leftSemi.trailingAnchor, constant: 4),
            rightSemi.widthAnchor.constraint(equalToConstant: rightSemi.frame.width),
            rightSemi.heightAnchor.constraint(equalToConstant: rightSemi.frame.height),
            countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: rightSemi.trailingAnchor, constant: 12)
        ])
        
        backgroundColor = .white
        
        layer.cornerRadius = frame.height/2
        
        leftSemi.addTarget(self, action: #selector(minus(_sender:)), for: .touchUpInside)
        rightSemi.addTarget(self, action: #selector(plus(_sender:)), for: .touchUpInside)
        
        primeColor = .black
    }
}
