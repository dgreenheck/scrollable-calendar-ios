//
//  GradientView.swift
//  ScrollableCalendarDemo
//

import UIKit

/// View which fades to the system background color at the top and bottom edges
class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.frame = self.bounds
        // Specify five colors here to split gradient into five bands.
        // This way the calendar will fade at the top and bottom edges to give it a 3D look
        gradientLayer.colors = [UIColor.systemBackground.cgColor,
                                UIColor.systemBackground.withAlphaComponent(0).cgColor,
                                UIColor.systemBackground.withAlphaComponent(0).cgColor,
                                UIColor.systemBackground.withAlphaComponent(0).cgColor,
                                UIColor.systemBackground.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
