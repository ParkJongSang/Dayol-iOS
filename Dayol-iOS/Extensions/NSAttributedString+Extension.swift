//
//  NSAttributedString+Extension.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/16.
//

import UIKit

extension NSAttributedString {
    static func build(
        text: String,
        font: UIFont,
        align: NSTextAlignment,
        letterSpacing: CGFloat,
        foregroundColor: UIColor
    ) -> Self {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = align

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: foregroundColor,
            .kern: letterSpacing
        ]

        // NSMutableAttributedString 에서도 사용하기위해 Self 사용
        return Self(string: text, attributes: attributes)
    }

    func height(with width: CGFloat) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.attributedText = self
        label.sizeToFit()

        return label.frame.height
    }
}
