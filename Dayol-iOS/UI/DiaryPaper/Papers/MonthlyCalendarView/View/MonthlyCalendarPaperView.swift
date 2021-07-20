//
//  MonthlyCalendarPaperView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/25.
//

import UIKit
import RxSwift

private enum Design {
    enum IPadOrientation {
        case landscape
        case portrait
    }

    static let maxScheduleCount: Int = 3
}

final class MonthlyCalendarPaperView: PaperView {
    let longTappedIndex = PublishSubject<Int>()

    private var dateModel: MonthlyCalendarDataModel?
    private var dayModel: [MonthlyCalendarDayModel]?
    private let viewModel: MonthlyCalendarViewModel
    private let disposeBag = DisposeBag()

    private(set) var scheduleContainerViews: [PaperScheduleLineContainerView] = []
    var firstDatesOfSunday: [Date] = []

    init(viewModel: MonthlyCalendarViewModel, orientation: Paper.PaperOrientation) {
        self.viewModel = viewModel
        super.init(orientation: orientation)
        addSubviews()
        setupConstraints()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionView()
    }

    private func addSubviews() {
        addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MonthlyCalendarViewDayCell.self)
        collectionView.registerHeader(MonthlyCalendarPaperHeaderView.self)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateCollectionView() {
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupSchedules() {
        for index in 0..<6 {
            let scheduleLineContainer = makeScheduleLineContainer(index: index)
            self.scheduleContainerViews.append(scheduleLineContainer)
            addSubview(scheduleLineContainer)
        }
    }

    private func makeScheduleLineContainer(index: Int) -> PaperScheduleLineContainerView {
        let scheduleLineContainer = PaperScheduleLineContainerView(lineType: .month(paper: orientation))
        scheduleLineContainer.translatesAutoresizingMaskIntoConstraints = false
        scheduleLineContainer.set(
            scheduleCount: Design.maxScheduleCount,
            widthPerSchedule: collectionView.frame.size.width / 7,
            schedules: DYTestData.shared.scheduleModels,
            firstDateOfWeek: firstDatesOfSunday[index]
        )

        return scheduleLineContainer
    }

    private func bind() {
        viewModel.dateModel()
            .subscribe(onNext: { [weak self] dateModel in
                guard let self = self else { return }
                self.dateModel = dateModel
                self.days = dateModel.days
            })
            .disposed(by: disposeBag)

//        collectionView.longTappedIndex
//            .subscribe(onNext: { [weak self] index in
//                guard let self = self else { return }
//                let day = self.dateModel?.days[index].dayNumber ?? 0
//                let month = self.dateModel?.month.rawValue ?? 0
//                let year = self.dateModel?.year ?? 0
//
//                let date = DateType.yearMonthDay.date(year: year, month: month + 1, day: day) ?? Date.now
//
//                self.showAddSchedule.onNext(date)
//            })
//            .disposed(by: disposeBag)
    }
}

extension MonthlyCalendarPaperView {
    var days: [MonthlyCalendarDayModel]? {
        get {
            return self.dayModel
        }
        set {
            self.dayModel = newValue
            self.collectionView.reloadData()
            self.setupSchedules()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MonthlyCalendarPaperView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueHeaderView(MonthlyCalendarPaperHeaderView.self, for: indexPath)
        headerView.delegate = self
        headerView.month = dateModel?.month ?? .january

        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let day = dayModel?[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthlyCalendarViewDayCell.identifier, for: indexPath) as? MonthlyCalendarViewDayCell
        else { return UICollectionViewCell() }
        
        cell.configure(model: day)

        cell.didLongTapped
            .bind { [weak self] in
                guard let self = self else { return }

                self.longTappedIndex.onNext(indexPath.item)
            }
            .disposed(by: cell.disposeBag)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MonthlyCalendarPaperView: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension MonthlyCalendarPaperView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item % 6 == 0 {
            for index in 0..<scheduleContainerViews.count {
                updateScheduleLineContainerConstraint(index: index)
            }
        }

        return CGSize(width: collectionView.frame.size.width / 7, height: collectionView.frame.size.height / 6)
    }

    private func updateScheduleLineContainerConstraint(index: Int) {
        let cellHeight: CGFloat = collectionView.frame.size.height / 6
        let topConstant: CGFloat = 26 + (cellHeight * CGFloat(index))
        NSLayoutConstraint.activate([
            scheduleContainerViews[index].topAnchor.constraint(equalTo: topAnchor, constant: topConstant)
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MonthlyCalendarPaperView: MonthlyCalendarPaperHeaderViewDelegate {
    func headerViewDidTappedLabel(_ monthlyCalendarHeaderView: MonthlyCalendarPaperHeaderView) {
        
    }
}
