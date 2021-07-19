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

class DailyPaperView: BasePaper {
    private(set) var maxHeightPerRowDict: [Int: CGFloat] = [Int: CGFloat]()
    
    private let disposeBag = DisposeBag()

    //TODO: Delete
    private let dummyModel: String = "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST"

    private let titleArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()
    
    override func configure(viewModel: PaperViewModel, orientation: Paper.PaperOrientation) {
        super.configure(viewModel: viewModel, orientation: orientation)
        titleArea.addSubview(dateLabel)
        titleArea.addSubview(dayLabel)
        titleArea.addSubview(separatorView)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(PaperTextableCell.self)

        contentView.addSubview(titleArea)
        contentView.addSubview(collectionView)
        contentView.backgroundColor = CommonPaperDesign.defaultBGColor
        
        setupConstraints()
        
        bindEvent()
    }
    
    func bindEvent() {
        guard let viewModel = viewModel as? DailyPaperViewModel else { return }

        viewModel.date
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dateString in
                self?.dateText = dateString
            })
            .disposed(by: disposeBag)

        viewModel.day
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] day in
                self?.dayText = day
            })
            .disposed(by: disposeBag)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: titleArea.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: titleArea.leadingAnchor,
                                               constant: Design.dateLeftMargin),

            dayLabel.firstBaselineAnchor.constraint(equalTo: dateLabel.firstBaselineAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor,
                                               constant: Design.dayLeftMargin),

            separatorView.leadingAnchor.constraint(equalTo: titleArea.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: titleArea.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: titleArea.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Design.separatorHeight),

            titleArea.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleArea.heightAnchor.constraint(equalToConstant: Design.titleAreaHeight),

            collectionView.topAnchor.constraint(equalTo: titleArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}

private extension DailyPaperView {
    var dateText: String? {
        get {
            return dateLabel.attributedText?.string
        }
        set {
            guard let dateString = newValue else { return }
            dateLabel.attributedText = NSAttributedString.build(text: dateString,
                                                                font: Design.dateFont,
                                                                align: .left,
                                                                letterSpacing: Design.dateSpacing,
                                                                foregroundColor: Design.titleColor)
            dateLabel.sizeToFit()
        }
    }

    var dayText: DailyPaperViewModel.Day? {
        get {
            guard let rawValue = dayLabel.attributedText?.string else { return nil }
            return DailyPaperViewModel.Day(rawValue: rawValue)
        }
        set {
            guard let day = newValue else { return }
            dayLabel.attributedText = NSAttributedString.build(text: day.rawValue,
                                                               font: Design.dayFont,
                                                               align: .left,
                                                               letterSpacing: Design.daySpacing,
                                                               foregroundColor: Design.titleColor)
            dayLabel.sizeToFit()
        }
    }
}

// MARK: - CollectionView Delegate

extension DailyPaperView: UICollectionViewDelegate {

}

// MARK: - CollectionView DataSource

extension DailyPaperView: UICollectionViewDataSource {
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
