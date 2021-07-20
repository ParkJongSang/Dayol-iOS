//
//  WeeklyCalendarView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/01.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let numberOfSection: Int = 1
    static let numberOfRow: Int = 4
    static let numberOfItemPerRow: Int = 2
    static let numberOfItem: Int = 8

    //TODO: Delete
    static let dummyFont: UIFont = .appleRegular(size: 15)
}

class WeeklyCalendarView: PaperView {
    private(set) var maxHeightPerRowDict: [Int: CGFloat] = [Int: CGFloat]()

    let showAddSchedule = PublishSubject<Date>()
    let showSelectPaper = PublishSubject<Void>()

    private let viewModel: WeeklyCalendarViewModel
    private var dayModel: [WeeklyCalendarDataModel]?
    private var month: Month?
    var disposeBag = DisposeBag()

    private let dummyModel: [String] = [
        "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST",
        "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTEST",
        "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTES",
        "TEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TESTTEST/TESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTESTTEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST/TEST"
    ]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionView()
    }

    init(viewModel: WeeklyCalendarViewModel, orientation: Paper.PaperOrientation) {
        self.viewModel = viewModel
        super.init(orientation: orientation)
        addSubviews()
        setupCollectionView()
        setupConstraints()
        bind()
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
        collectionView.register(WeeklyCalendarViewCell.self)
        collectionView.registerHeader(WeeklyCalendarHeaderView.self)
    }
    
    private func bind() {
        viewModel.dateModel()
            .subscribe(onNext: {[weak self] models in
                guard let month = models[safe: 1]?.month else { return }
                self?.month = month
                self?.dayModel = models
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCollectionView() {
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    @objc
    private func didTappedHeaderView(_ sender: WeeklyCalendarHeaderView) {
        showSelectPaper.onNext(())
    }
}

// MARK: - CollectionView Delegate

extension WeeklyCalendarView: UICollectionViewDelegate {
    
}

// MARK: - CollectionView DataSource

extension WeeklyCalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: WeeklyCalendarHeaderView.height)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueHeaderView(WeeklyCalendarHeaderView.self, for: indexPath)
        headerView.month = month

        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = dayModel?[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCalendarViewCell.identifier, for: indexPath) as? WeeklyCalendarViewCell else {
            return UICollectionViewCell()
        }


        let text = dummyModel[safe: indexPath.item - 1] ?? ""
        let attributedText = NSAttributedString.build(text: text, font: Design.dummyFont, align: .natural, letterSpacing: 0.0, foregroundColor: .black)
        cell.configure(model: model, text: attributedText)

        if model.isFirst {
            cell.setFirstCell(true)
        }

        cell.didLongTapped
            .bind { [weak self] in
                guard let self = self,
                      let dayModel = self.dayModel?[safe: indexPath.item]
                else { return }
                let day = dayModel.day
                let month = dayModel.month.rawValue + 1
                let year = dayModel.year

                let date = DateType.yearMonthDay.date(year: year, month: month, day: day) ?? .now

                self.showAddSchedule.onNext(date)
            }
            .disposed(by: disposeBag)
        
        return cell
    }
}

// MARK: - CollectionView FlowLayout

extension WeeklyCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        let row = Int(CGFloat(indexPath.item) * CGFloat(0.5))
        let width = collectionViewSize.width * 0.5

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
        let width = collectionView.frame.size.width * 0.5
        let defaultHeight = (collectionView.frame.height - WeeklyCalendarHeaderView.height) * 0.25
        var estimatedHeight = defaultHeight

        for index in 0..<itemPerRow {
            let modelIndex = (row * itemPerRow) + index
            let text = dummyModel[safe: modelIndex - 1] ?? ""
            let attributedText = NSAttributedString.build(text: text, font: Design.dummyFont, align: .natural, letterSpacing: 0.0, foregroundColor: .black)
            let textHeight: CGFloat = PaperTextableCell.estimatedHeight(
                width: width,
                attributedText: attributedText
            )
            estimatedHeight = max(estimatedHeight, textHeight)
        }

        maxHeightPerRowDict[row] = estimatedHeight

        return estimatedHeight
    }
}
