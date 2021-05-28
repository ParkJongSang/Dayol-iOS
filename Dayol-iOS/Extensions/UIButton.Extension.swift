//
//  UIButton.Extension.swift
//  Dayol-iOS
//
//  Created by Seonho Ban on 2021/05/19.
//

import UIKit

// MARK: - UIButton Set Background Color

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        setBackgroundImage(imageWithColor(color: color), for: state)
    }
}

