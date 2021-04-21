//
//  LassoInfoView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/04/08.
//

import UIKit

private enum Design {
    static let infoImage = Assets.Image.ToolBar.Lasso.info
    static let infoTextFont: UIFont = .appleRegular(size: 14.0)
    static let infoTextColor: UIColor = .gray800
    static let infoTextSpacing: CGFloat = -0.26
    static let infoTextLine = 2

    static let stackViewSpacing: CGFloat = 31.0
    static let stackViewTopMargin: CGFloat = 21.0
    static let stackViewWidth: CGFloat = 315.0
}

private enum Text {
    static var infoText: String {
        return "edit_lasso_text".localized
    }
}

class LassoInfoView: UIView {

    // MARK: UI Property

    private let infoImageView: UIImageView = {
        let imageView = UIImageView(image: Design.infoImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = Design.infoTextLine
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Design.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension LassoInfoView {

    private func initView() {
        infoLabel.attributedText = NSAttributedString.build(text: Text.infoText,
                                                            font: Design.infoTextFont,
                                                            align: .center,
                                                            letterSpacing: Design.infoTextSpacing,
                                                            foregroundColor: Design.infoTextColor)
        stackView.addArrangedSubview(infoImageView)
        stackView.addArrangedSubview(infoLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: Design.stackViewTopMargin),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: Design.stackViewWidth)
        ])
    }

}
