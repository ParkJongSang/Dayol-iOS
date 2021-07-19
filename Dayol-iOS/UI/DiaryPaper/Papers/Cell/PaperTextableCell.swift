//
//  PaperTextableCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/15.
//

import UIKit

private enum Design {
    static let textInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: -5, right: -5)
    static let borderColor: UIColor = .gray500
    static let borderWidth: CGFloat = 0.2

    static let defaultFont: UIFont = UIFont.appleRegular(size: 15)
}

final class PaperTextableCell: UICollectionViewCell {
    static func estimatedHeight(width: CGFloat, attributedText: NSAttributedString) -> CGFloat {
        return attributedText.height(with: width)
    }

    private(set) var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byCharWrapping

        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        contentView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        textView.text = ""
    }

    private func setupViews() {
        contentView.addSubview(textView)

        contentView.layer.borderWidth = Design.borderWidth
        contentView.layer.borderColor = Design.borderColor.cgColor
    }

    func configure(attributedText: NSAttributedString) {
        textView.attributedText = attributedText
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.textInset.top),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.textInset.left),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Design.textInset.right),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Design.textInset.bottom)
        ])
    }
}
