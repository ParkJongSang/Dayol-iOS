//
//  DailyPaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit
import RxSwift

private enum Design {
    static let titleColor = UIColor.black
    static let titleAreaHeight: CGFloat = 60.0

    static let separatorColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorHeight: CGFloat = 1.0

    static let dateFont = UIFont.helveticaBold(size: 26.0)
    static let dateSpacing: CGFloat = -0.79
    static let dayFont = UIFont.systemFont(ofSize: 13.0, weight: .bold)
    static let daySpacing: CGFloat = -0.5

    static let dateLeftMargin: CGFloat = 18.0
    static let dayLeftMargin: CGFloat = 7.0

    static let numberOfSection: Int = 1
    static let numberOfRow: Int = 1
    static let numberOfItemPerRow: Int = 1
    static let numberOfItem: Int = 1

    //TODO: Delete
    static let dummyFont: UIFont = .appleRegular(size: 15)
}

class DailyPaperView: PaperView {
    private(set) var maxHeightPerRowDict: [Int: CGFloat] = [Int: CGFloat]()

    private let viewModel: DailyPaperViewModel
    private let disposeBag = DisposeBag()

    //TODO: Delete
    private let dummyModel: String = "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST"

    init(viewModel: DailyPaperViewModel,orientation: Paper.PaperOrientation) {
        self.viewModel = viewModel
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(PaperTextableCell.self)
        collectionView.registerHeader(DailyPaperHeaderView.self)
    }
}

// MARK: - CollectionView Delegate

extension DailyPaperView: UICollectionViewDelegate {

}

// MARK: - CollectionView DataSource

extension DailyPaperView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: DailyPaperHeaderView.height(orientation: orientation))
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueHeaderView(DailyPaperHeaderView.self, for: indexPath)
        headerView.dateText = viewModel.date.string(with: .monthDay)
        headerView.dayText = WeekDay(rawValue: viewModel.date.weekday)?.stringValue

        return headerView
    }

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

extension DailyPaperView: UICollectionViewDelegateFlowLayout {
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
