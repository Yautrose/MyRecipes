import UIKit
import SwiftUI

@IBDesignable class RatingControl: UIStackView {

    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectesStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButton()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    @objc func ratingButtonPressed(button: UIButton){
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }

    private func setupButton() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
       
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle, compatibleWith:
                                    self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundle, compatibleWith:
                                        self.traitCollection)
        
        for _ in 1...starCount {
            
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(emptyStar, for: [.selected, .highlighted])
            
            button.adjustsImageSizeForAccessibilityContentSizeCategory = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(ratingButtonPressed(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
            
        }
        updateButtonSelectesStates()
    }
    
    private func updateButtonSelectesStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
