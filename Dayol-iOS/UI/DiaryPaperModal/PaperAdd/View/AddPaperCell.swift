//
//  AddPaperCell.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/13.
//

import UIKit

private enum Design {

    static let titleFont = UIFont.appleBold(size: 15.0)
    static let titleSpacing: CGFloat = -0.28
    static let titleColor = UIColor(decimalRed: 68, green: 68, blue: 68)

    static let contentStackViewSpacing: CGFloat = 11.0

    static let buttonImageOn = Assets.Image.PaperAdd.Button.on
    static let buttonImageOff = Assets.Image.PaperAdd.Button.off
}

class AddPaperCell: UICollectionViewCell {
    typealias ViewModel = PaperModalModel.AddPaperCellModel
    static let identifier = className

    enum Size {
        static let portrait = CGSize(width: 130, height: 229)
        static let landscape = CGSize(width: 130, height: 122)
    }

    override var isSelected: Bool {
        didSet {
            let image = isSelected ? Design.buttonImageOn : Design.buttonImageOff
            radioButtonImageView.image = image
        }
    }

    var viewModel: ViewModel? {
        didSet {
            configure(viewModel)
        }
    }

    // MARK: - UI Property

    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let radioButtonImageView: UIImageView = {
        let imageView = UIImageView(image: Design.buttonImageOff)
        return imageView
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Design.contentStackViewSpacing
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(_ viewModel: ViewModel?) {
        guard let viewModel = viewModel else { return }

        thumbnailImageView.image = UIImage(named: viewModel.thumbnailName)
        titleLabel.attributedText = NSAttributedString.build(
            text: viewModel.title,
            font: Design.titleFont,
            align: .left,
            letterSpacing: Design.titleSpacing,
            foregroundColor: Design.titleColor
        )
    }

}

private extension AddPaperCell {

    private func setupViews() {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(radioButtonImageView)

        contentStackView.addArrangedSubview(thumbnailImageView)
        contentStackView.addArrangedSubview(titleStackView)
        contentView.addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
