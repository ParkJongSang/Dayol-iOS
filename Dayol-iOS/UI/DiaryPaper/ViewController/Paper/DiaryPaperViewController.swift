//
//  DiaryPaperViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/10.
//

import UIKit
import Combine
import RxSwift

enum DiaryPaperEventType {
    case showDatePicker
    case showPaperSelect(paperType: PaperType)
    case showAddSchedule(date: Date, scheduleType: ScheduleModalType)
}

private enum Design {
    enum Margin {
        static let contentProgressSpace: CGFloat = 34
        static let progressSize: CGSize = .init(width: 48, height: 88)
    }
}

class DiaryPaperViewController: DYBaseEditViewController {
    let didReceivedEvent = PublishSubject<DiaryPaperEventType>()
    let index: Int
    let scaleSubject = PassthroughSubject<CGFloat, Error>()
    let viewModel: DiaryPaperViewModel

    private var cancellable = [AnyCancellable]()
    private var paperHeight = NSLayoutConstraint()

    private var scaleVariable: CGFloat {
        let orientation = viewModel.orientation
        let paperSize = PaperOrientationConstant.size(orentantion: orientation)
        if isIPad {
            switch orientation {
            case .portrait:
                return self.view.frame.height / paperSize.height
            case .landscape:
                return self.view.frame.width / paperSize.width
            }
        } else {
            return self.view.frame.width / paperSize.width
        }
    }

    private var paperView: PaperView?
//    override var contentsView: DYContentsView {
//        get {
//            paper.contentsView
//        } set {
//            paper.contentsView = newValue
//        }
//    }
//
//    private let paperScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//
//        return scrollView
//    }()

    private let progressView: DiarySwipeAddPaperView = {
        let progressView = DiarySwipeAddPaperView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0)

        return progressView
    }()
    
    init(index: Int, viewModel: DiaryPaperViewModel) {
        self.index = index
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        paperView?.transform = .init(scaleX: scaleVariable, y: scaleVariable)
    }
    
    private func initView() {
        setupPaperView()

        guard let paperView = self.paperView else { return }
        view.addSubview(paperView)

        view.backgroundColor = UIColor(decimalRed: 246, green: 248, blue: 250)
        progressView.isHidden = true
        setupConstraint()
        paperActionBind()
    }

    private func setupPaperView() {
        switch viewModel.paperType {
        case .monthly:
            let monthlyViewModel = MonthlyCalendarViewModel(date: viewModel.date)
            paperView = MonthlyCalendarPaperView(viewModel: monthlyViewModel, orientation: viewModel.orientation)
        case .weekly:
            let weeklyViewModel = WeeklyCalendarViewModel(date: viewModel.date)
            paperView = WeeklyCalendarView(viewModel: weeklyViewModel, orientation: viewModel.orientation)
        case .daily:
            let dailyViewModel = DailyPaperViewModel(date: viewModel.date)
            paperView = DailyPaperView(viewModel: dailyViewModel, orientation: viewModel.orientation)
        case .cornell:
            paperView = CornellPaperView(orientation: viewModel.orientation)
        case .muji:
            paperView = MujiPaperView(orientation: viewModel.orientation)
        case .grid:
            paperView = GridPaperView(orientation: viewModel.orientation)
        case .quartet:
            paperView = QuartetPaperView(orientation: viewModel.orientation)
        case .tracker:
            paperView = MonthlyTrackerPaperView(orientation: viewModel.orientation)
        }
        paperView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint() {
        guard let paperView = self.paperView else { return }
        NSLayoutConstraint.activate([
            paperView.widthAnchor.constraint(equalToConstant: PaperOrientationConstant.size(orentantion: viewModel.orientation).width),
            paperView.heightAnchor.constraint(equalToConstant: PaperOrientationConstant.size(orentantion: viewModel.orientation).height),
            paperView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            paperView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func showProgressView(show: Bool) {
        progressView.isHidden = !show
    }

    func setProgress(_ progress: CGFloat) {
        progressView.setProgress(progress / 116)
    }
}

extension DiaryPaperViewController {
    var readyToAdd: Bool {
        return progressView.readyToAdd
    }

    var paperType: PaperType {
        return viewModel.paperType
    }

    func paperActionBind() {
//        paper.showPaperSelect
//            .observe(on:MainScheduler.instance)
//            .subscribe(onNext: { [weak self] paperType in
//                self?.didReceivedEvent.onNext(.showPaperSelect(paperType: paperType))
//            })
//            .disposed(by: disposeBag)
//
//        paper.showAddSchedule
//            .observe(on:MainScheduler.instance)
//            .subscribe(onNext: { [weak self] date, scheduleType in
//                self?.didReceivedEvent.onNext(.showAddSchedule(date: date, scheduleType: scheduleType))
//            })
//            .disposed(by: disposeBag)
    }
}
