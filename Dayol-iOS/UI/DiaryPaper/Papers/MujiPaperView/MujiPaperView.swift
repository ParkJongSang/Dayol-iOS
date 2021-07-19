//
//  MujiPaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit

private enum Design {
    static let numberOfSection: Int = 1
    static let numberOfRow: Int = 1
    static let numberOfItemPerRow: Int = 1
    static let numberOfItem: Int = 1

    //TODO: Delete
    static let dummyFont: UIFont = .appleRegular(size: 15)
}

class MujiPaperView: BasePaper {
    private(set) var maxHeightPerRowDict: [Int: CGFloat] = [Int: CGFloat]()

    //TODO: Delete
    private let dummyModel: String = "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST"

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    override func configure(viewModel: PaperViewModel, orientation: Paper.PaperOrientation) {
        super.configure(viewModel: viewModel, orientation: orientation)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PaperTextableCell.self)
        contentView.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - CollectionView Delegate

extension MujiPaperView: UICollectionViewDelegate {

}

// MARK: - CollectionView DataSource

extension MujiPaperView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Design.numberOfSection
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Design.numberOfItem
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PaperTextableCell.self, for: indexPath)

        //TODO: Modify DYTextView
        let attributedText = NSAttributedString.build(text: dummyModel, font: Design.dummyFont, align: .natural, letterSpacing: 0.0, foregroundColor: .black)

        cell.configure(attributedText: attributedText)
        return cell
    }
}

// MARK: - CollectionView Flowlayout Delegate

extension MujiPaperView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        let width = collectionViewSize.width

        let height = maxHeightPerRow(collectionView, at: 0)
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

        let width = collectionView.frame.size.width
        let defaultHeight = collectionView.frame.size.height
        var estimatedHeight = defaultHeight

        let textHeight: CGFloat = PaperTextableCell.estimatedHeight(
            width: width,
            attributedText: NSAttributedString(string: dummyModel)
        )
        estimatedHeight = max(estimatedHeight, textHeight)

        maxHeightPerRowDict[row] = estimatedHeight

        return estimatedHeight
    }
}
