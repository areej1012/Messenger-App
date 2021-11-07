//
//  StyleButton.swift
//  Messenger App
//
//  Created by administrator on 28/10/2021.
//

import Foundation
import UIKit
class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 10
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
