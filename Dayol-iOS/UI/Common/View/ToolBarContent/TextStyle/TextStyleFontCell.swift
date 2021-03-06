//
//  TextStyleFontCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/06/21.
//

import UIKit

private enum Design {
    static let backgroundColor: UIColor = .white
    static let systemFontLabelFont: UIFont = .systemFont(ofSize: 16.0)
    static let systemFontLabelAlign: NSTextAlignment = .left
    static let systemFontLabelKern: CGFloat = -0.62
    static let systemFontLabelColor: UIColor = .gray900

    static let contentSideMargin: CGFloat = 18.0

    static let selectImage = Assets.Image.DYTextField.Font.selected
    static let deselectImage = Assets.Image.DYTextField.Font.deselected
}

private enum Text {
    // TODO: - 이건 로컬라이제이션이 필요 없는건가유 (? 3 ?)
    static var systemFontName: String {
        return "System Font".localized
    }
}

class TextStyleFontCell: UITableViewCell {

    static let cellHeight: CGFloat = 56.0

    // MARK: - UI Property

    private let systemFontLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(text: Text.systemFontName,
                                                        font: Design.systemFontLabelFont,
                                                        align: Design.systemFontLabelAlign,
                                                        letterSpacing: Design.systemFontLabelKern,
                                                        foregroundColor: Design.systemFontLabelColor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let customFontThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let selectButton: UIButton = {
        let button = UIButton()
        button.setImage(Design.deselectImage, for: .normal)
        button.setImage(Design.selectImage, for: .selected)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        setupCoantraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectButton.isSelected = selected
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        systemFontLabel.isHidden = false
        customFontThumbnail.isHidden = true
    }

    func setFontImage(image: UIImage?) {
        if let image = image {
            systemFontLabel.isHidden = true
            customFontThumbnail.isHidden = false
            customFontThumbnail.image = image
        }
    }

}

// MARK: - Initialize

private extension TextStyleFontCell {

    func initView() {
        contentView.backgroundColor = Design.backgroundColor

        contentView.addSubview(systemFontLabel)
        contentView.addSubview(customFontThumbnail)
        contentView.addSubview(selectButton)
    }

    func setupCoantraints() {
        let layoutGuide = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            systemFontLabel.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            systemFontLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor,
                                                     constant: Design.contentSideMargin),

            customFontThumbnail.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            customFontThumbnail.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor,
                                                         constant: Design.contentSideMargin),

            selectButton.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            selectButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor,
                                                   constant: -Design.contentSideMargin)
        ])
    }

}
