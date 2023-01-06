//
//  AviatoButton.swift
//  Aviato
//
//  Created by v.sklyarov on 06.01.2023.
//

import Foundation
import UIKit

final class AviatoButton: UIButton {
    
    private enum VisualConstants {
        static let backgroundColor = UIColor.white
        static let selectedBackgroundColor = UIColor(red: 1, green: 0.8, blue: 1, alpha: 0.1)
        static let cornerRadius: CGFloat = 10.0
    }
    
    var buttonAction: (() -> Void)?
    
    // MARK: - Initializers

    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    #endif

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupButton() {
        layer.cornerRadius = VisualConstants.cornerRadius
        backgroundColor = VisualConstants.backgroundColor
        setTitleColor(UIColor(red: 0, green: 0, blue: 0.4, alpha: 1), for: .normal)
    }
    
    private func toggleAnimationButtonColor() {
       var animator = UIViewPropertyAnimator()
       animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: { [unowned self] in
           backgroundColor = isHighlighted ? VisualConstants.selectedBackgroundColor : .white
           layer.borderColor = isHighlighted ? UIColor.white.cgColor : VisualConstants.selectedBackgroundColor.cgColor
           setTitleColor(isHighlighted ? UIColor.white : VisualConstants.selectedBackgroundColor, for: .highlighted)
       })
       animator.startAnimation()
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        toggleAnimationButtonColor()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        toggleAnimationButtonColor()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        toggleAnimationButtonColor()
        buttonAction?()
    }
    
}
