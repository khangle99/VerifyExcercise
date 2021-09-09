import Foundation
import UIKit

class CategoryTableViewCell: UICollectionViewCell {
    
    private let chip: ChipButton = {
        let chip = ChipButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        chip.setTitleColor(.black, for: .normal)
        chip.titleLabel?.textColor = .black
        chip.layer.shadowOpacity = 0.2
        chip.layer.shadowRadius = 5
        chip.layer.shadowOffset = CGSize(width: 4, height: 4)
        return chip
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutUI()
    }
    
    private func layoutUI() {
        chip.isUserInteractionEnabled = false
        chip.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chip)
        NSLayoutConstraint.activate([
            chip.topAnchor.constraint(equalTo: self.topAnchor),
            chip.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            chip.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            chip.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    func configureWith(_ allergen: String, isSelected: Bool) {
        chip.setTitle(allergen, for: .normal)
        if (isSelected) {
            chip.layer.backgroundColor = UIColor.brown.cgColor
        } else {
            chip.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
