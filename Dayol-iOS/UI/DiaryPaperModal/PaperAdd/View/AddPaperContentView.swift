//
//  AddPaperContentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let tabBarBGColor = UIColor.white
    static let contentBGColor = UIColor(decimalRed: 242, green: 244, blue: 246)

    static let tabBarHeight: CGFloat = 50.0

    static let tabBarFont = UIFont.appleBold(size: 18.0)
    static let tabBarLetterSpacing: CGFloat = -0.7
    static let tabBarSelectedColor = UIColor.black
    // TODO: - guide update
    static let tabBarDeselectedColor = UIColor.gray

    static let itemSpacing: CGFloat = 43.0
    static let lineSpacing: CGFloat = 29.0
}

private enum Text: String {
    case portrait = "create_add_memo_v"
    case landscape = "create_add_memo_h"
    
    var stringValue: String {
        return self.rawValue.localized
    }
}

class AddPaperContentView: UIView {

    private let disposeBag = DisposeBag()
    let viewModel = AddPaperContentViewModel()
    var currentSelectedCell: AddPaperCell?

    // MARK: - UI Property

    private let portraitTabButton = UnderLineButton()
    private let landscapeTabButton = UnderLineButton()
    private let tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = Design.tabBarBGColor
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Design.contentBGColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private(set) var currentTabType: PaperStyle {
        didSet {
            updateCurrentTabType()
        }
    }

    init() {
        self.currentTabType = isPadDevice ? .horizontal : .vertical
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        bindEvent()
        updateCurrentTabType()
    }

    override func draw(_ rect: CGRect) {
        layoutCollectionView(width: rect.width)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func updateCurrentTabType() {
        portraitTabButton.isSelected = currentTabType == .vertical
        landscapeTabButton.isSelected = currentTabType == .horizontal
        reloadData()
    }

    private func tabBarAttributedTitle(_ title: String, isSelected: Bool) -> NSAttributedString {
        let fontColor = isSelected ? Design.tabBarSelectedColor : Design.tabBarDeselectedColor
        return NSAttributedString.build(
            text: title,
            font: Design.tabBarFont,
            align: .center,
            letterSpacing: Design.tabBarLetterSpacing,
            foregroundColor: fontColor
        )
    }
}

// MARK: - Setup UI

extension AddPaperContentView {
    private func setupViews() {
        portraitTabButton.setAttributedTitle(
            tabBarAttributedTitle(Text.portrait.stringValue, isSelected: false),
            for: .normal
        )
        portraitTabButton.setAttributedTitle(
            tabBarAttributedTitle(Text.portrait.stringValue, isSelected: true),
            for: .selected
        )
        landscapeTabButton.setAttributedTitle(
            tabBarAttributedTitle(Text.landscape.stringValue, isSelected: false),
            for: .normal
        )
        landscapeTabButton.setAttributedTitle(
            tabBarAttributedTitle(Text.landscape.stringValue, isSelected: true),
            for: .selected
        )

        tabBarStackView.addArrangedSubview(portraitTabButton)
        tabBarStackView.addArrangedSubview(landscapeTabButton)
        addSubview(tabBarStackView)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AddPaperCell.self,
                                forCellWithReuseIdentifier: AddPaperCell.className)
        collectionView.register(AddPaperHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: AddPaperHeaderReusableView.className)
        collectionView.collectionViewLayout = getCollectionViewLayout(width: bounds.width)
        addSubview(collectionView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            tabBarStackView.topAnchor.constraint(equalTo: topAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: Design.tabBarHeight),

            collectionView.topAnchor.constraint(equalTo: tabBarStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

extension AddPaperContentView {

    private func bindEvent() {

        portraitTabButton.rx.tap
            .bind { [weak self] in
                self?.currentTabType = .vertical
            }
            .disposed(by: disposeBag)

        landscapeTabButton.rx.tap
            .bind { [weak self] in
                self?.currentTabType = .horizontal
            }
            .disposed(by: disposeBag)
    }

}
