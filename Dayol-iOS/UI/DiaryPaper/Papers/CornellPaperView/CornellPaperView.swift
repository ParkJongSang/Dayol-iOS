//
//  CornellPaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/27.
//

import UIKit
import RxSwift

private enum Design {
    static let redLineColor = UIColor(decimalRed: 226, green: 88, blue: 88)
    static let headerSeparatorColor = UIColor.gray800
    static let lineColor = UIColor(decimalRed: 233, green: 233, blue: 233)

    static let lineWidth: CGFloat = 1
    static let lineHeight: CGFloat = 30.0

    static func titleAreaHeight(orentation: Paper.PaperOrientation) -> CGFloat {
        switch orentation {
        case .landscape: return 83.0
        case .portrait: return 79.0
        }
    }

    static func redLineOriginX(orentation: Paper.PaperOrientation) -> CGFloat {
        switch orentation {
        case .landscape: return 200.0
        case .portrait: return 100.0
        }
    }

    static func numberOfLineInPage(orientation: Paper.PaperOrientation, isFirstPage: Bool) -> Int {
        let paperSize = PaperOrientationConstant.size(orentantion: orientation)
        if isFirstPage {
            return Int(paperSize.height - titleAreaHeight(orentation: orientation) / Self.lineHeight) + 1
        } else {
            return Int(paperSize.height / Self.lineHeight) + 1
        }
    }

    static let numberOfSection: Int = 1
    static let numberOfRow: Int = 15
    static let numberOfItemPerRow: Int = 2
    static let numberOfItem: Int = 30

    static let defaultHeight: CGFloat = 31
    static let smallCellWidth: CGFloat = isIPad ? 200 : 100
    static let bigCellWidth: CGFloat = isIPad ? 824 : 275

    static func smallCellWidth(orientation: Paper.PaperOrientation) -> CGFloat {
        switch orientation {
        case .landscape:
            return 200
        case .portrait:
            return 100
        }
    }

    static func bigCellWidth(orientation: Paper.PaperOrientation) -> CGFloat {
        switch orientation {
        case .landscape:
            return 824
        case .portrait:
            return 275
        }
    }

    //TODO: Delete
    static let dummyFont: UIFont = .appleRegular(size: 15)
}

class CornellPaperView: PaperView {
    private(set) var maxHeightPerRowDict: [Int: CGFloat] = [Int: CGFloat]()

    //TODO: Delete
    private let dummyModel: [String] = [
        "TESTT",
        "TES",
        "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTES",
        "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST"
    ]

    private let redLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.redLineColor

        return view
    }()

    override init(orientation: Paper.PaperOrientation) {
        super.init(orientation: orientation)
        addSubviews()
        setupConstraints()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(collectionView)
        addSubview(redLineView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: Design.titleAreaHeight(orentation: orientation)),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            redLineView.widthAnchor.constraint(equalToConstant: Design.lineWidth),
            redLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.smallCellWidth),
            redLineView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            redLineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PaperTextableCell.self)
    }
}

// MARK: - CollectionView Delegate

extension CornellPaperView: UICollectionViewDelegate {

}

// MARK: - CollectionView DataSource

extension CornellPaperView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Design.numberOfSection
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Design.numberOfItem
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PaperTextableCell.self, for: indexPath)
        let text = dummyModel[safe: indexPath.item] ?? ""
        //TODO: Modify DYTextView
        let attributedText = NSAttributedString.build(text: text, font: Design.dummyFont, align: .natural, letterSpacing: 0.0, foregroundColor: .black)

        cell.configure(attributedText: attributedText)
        return cell
    }
}

// MARK: - CollectionView Flowlayout Delegate

extension CornellPaperView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let row = Int(CGFloat(indexPath.item) * CGFloat(0.5))
        let width = indexPath.item % 2 == 0 ? Design.smallCellWidth(orientation: orientation) : Design.bigCellWidth(orientation: orientation)

        let height = maxHeightPerRow(collectionView, at: row)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    private func maxHeightPerRow(_ collectionView: UICollectionView, at row: Int) -> CGFloat {
        guard maxHeightPerRowDict[row] == nil else {
            return maxHeightPerRowDict[row] ?? 0
        }

        let itemPerRow = Design.numberOfItemPerRow
        let defaultHeight = Design.defaultHeight
        var estimatedHeight = defaultHeight

        for index in 0..<itemPerRow {
            let modelIndex = (row * itemPerRow) + index
            let width = modelIndex % 2 == 0 ? Design.smallCellWidth(orientation: orientation) : Design.bigCellWidth(orientation: orientation)
            let text = dummyModel[safe: modelIndex] ?? ""
            let textHeight: CGFloat = PaperTextableCell.estimatedHeight(
                width: width,
                attributedText: NSAttributedString(string: text)
            )
            estimatedHeight = max(estimatedHeight, textHeight)
        }

        maxHeightPerRowDict[row] = estimatedHeight

        return estimatedHeight
    }
}
