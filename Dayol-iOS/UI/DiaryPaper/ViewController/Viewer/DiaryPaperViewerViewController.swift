//
//  DiaryPaperViewerViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/07.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

private enum Design {
    enum Margin {
        static let addPageModalTopMargin: CGFloat = 57.0
    }
}

class DiaryPaperViewerViewController: DYViewController {
    enum Text {
        static var addScheduleTitle: String { "속지 또는 일정 등록" }
        static var addScheduleDesc: String { "선택한 날짜에 새로운 일정을 등록하거나 작성한 속지를 연결할 수 있습니다" }
        static var addScheduleAddButton: String { "일정추가" }
        static var addScheduleLinkButton: String { "속지연결" }
        static var addPaperTitle: String { "속지추가" }
        static var addPaperDesc: String { "새로운 속지를 추가 하시겠습니까?" }
        static var addPaperCancel: String { "취소" }
        static var addPaperConfirm: String { "추가" }
    }

    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var cancellable = [Cancellable]()
    private let viewModel: DiaryPaperViewerViewModel
    private var paperModels: [Paper]?
    
    var currentIndex: Int = -1
    
    // MARK: - UI Component
    
    private let barLeftItem = DYNavigationItemCreator.barButton(type: .backWhite)
    private let barRightItem = DYNavigationItemCreator.barButton(type: .more)
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private(set) var paperViewControllers: [DiaryPaperViewController]?
    let toolBar = DYNavigationItemCreator.functionToolbar()

    // MARK: - Init
    
    init(viewModel: DiaryPaperViewerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let coverColor: PaletteColor = PaletteColor.find(hex: viewModel.coverHex) ?? .DYBrown

        navigationController?.navigationBar.barTintColor = coverColor.uiColor
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        super.viewWillDisappear(animated)
    }
    
    private func initView() {
        view.backgroundColor = UIColor(decimalRed: 246, green: 248, blue: 250)
        setupPageViewController()
        setupNavigationBars()
    }
    
    private func setupNavigationBars() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barLeftItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barRightItem)
        
        setToolbarItems([leftFlexibleSpace, UIBarButtonItem(customView: toolBar), rightFlexibleSpace], animated: false)
        
        barLeftItem.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupPageViewController() {
        for subview in  pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }

    func setupLastViewContoller() {
        currentViewController?.showProgressView(show: isLastViewContrller)
    }
    
    // MARK: - Bind
    
    private func bind() {
        bindTitle()
        bindNavigationEvent()
        bindPaperModel()
    }
    
    private func bindTitle() {
        viewModel.title
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] titleValue in
                let titleView = DYNavigationItemCreator.titleView(titleValue, color: .white)
                self?.navigationItem.titleView = titleView
            })
            .disposed(by: disposeBag)
    }

    private func bindPaperModel() {
        viewModel.didUpdatedPaper
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] papers in
                guard let self = self else { return }
                self.setupViewControllers(papers: papers)
            })
            .disposed(by: disposeBag)

        viewModel.didFavoriteChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isFavorite in
                self?.toolBar.setFavorite(isFavorite)
            })
            .disposed(by: disposeBag)
    }

    private func bindNavigationEvent() {
        barLeftItem.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        toolBar.pageButton.rx.tap
            .bind { [weak self] in
                self?.presentPaperModal(toolType: .list)
            }
            .disposed(by: disposeBag)

        toolBar.editButton.rx.tap
            .bind { [weak self] in
                guard let currentVC = self?.currentViewController else { return }
                let viewModel = currentVC.viewModel

                let paperEditViewController = DiaryPaperEditViewController(viewModel: viewModel)
                let nav = DYNavigationController(rootViewController: paperEditViewController)
                nav.modalPresentationStyle = .overFullScreen
                nav.modalTransitionStyle = .crossDissolve

                self?.present(nav, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

        toolBar.favoriteButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      let currentVC = self.currentViewController
                else { return }

                let currentPaperId = currentVC.viewModel.paperId
                let currentFavorite = currentVC.viewModel.isFavorite

                self.viewModel.updateFavorite(paperId: currentPaperId, !currentFavorite)
            }
            .disposed(by: disposeBag)

        toolBar.garbageButton.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      let currentVC = self.currentViewController
                else { return }
                let currentPaperId = currentVC.viewModel.paperId

                self.viewModel.deletePaper(currentPaperId)
            }
            .disposed(by: disposeBag)
    }

    func presentPaperModal(toolType: PaperModalViewController.PaperToolType) {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let screenHeight = keyWindow?.bounds.height ?? .zero
        let topInset = keyWindow?.safeAreaInsets.top ?? 0
        let modalHeight: CGFloat = screenHeight - (Design.Margin.addPageModalTopMargin + topInset)
        let modalStyle: DYModalConfiguration.ModalStyle = isIPad ? .normal : .custom(containerHeight: modalHeight)
        let configuration = DYModalConfiguration(dimStyle: .black,
                                                 modalStyle: modalStyle)

        let modalVC = PaperModalViewController(diaryId: viewModel.diaryId, toolType: toolType, configure: configuration)
        modalVC.delegate = self

        presentCustomModal(modalVC)
    }

    private func setupViewControllers(papers: [Paper]) {
        if papers.isEmpty {
            setupEmptyViewController()
        } else {
            setupPaperViewController(papers: papers)
        }
    }

    private func setupPaperViewController(papers: [Paper]) {
        var diaryPaperViewControllers = [DiaryPaperViewController]()
        let currentPaperEvent = viewModel.currentPaperEvent

        paperModels = papers
        toolBar.activateButtons()

        for (index, paper) in papers.enumerated() {
            let paperViewModel = DiaryPaperViewModel(paper: paper, numberOfPapers: Int(paper.pageCount))
            let paperViewController = DiaryPaperViewController(index: index, viewModel: paperViewModel)

            paperViewController.didReceivedEvent
                .subscribe(onNext: { event in
                    switch event {
                    case .showDatePicker:
                        self.presentPaperModal(toolType: .date)
                    case let .showPaperSelect(paperType: paperType):
                        self.presentPaperModal(toolType: .paperType(type: paperType))
                    case let .showAddSchedule(date: date, scheduleType: scheduleType):
                        self.presentScheduleModal(date: date, scheduleType: scheduleType)
                    }
                })
                .disposed(by: self.disposeBag)
            paperViewController.contentsView.isUserInteractionEnabled = false

            diaryPaperViewControllers.append(paperViewController)
        }
        let direction: UIPageViewController.NavigationDirection
        let animated: Bool
        paperViewControllers = diaryPaperViewControllers
        switch currentPaperEvent {
        case .add:
            animated = true
            direction = .forward
            currentIndex = papers.count - 1
        case .delete:
            animated = true
            if currentIndex > papers.count - 1 {
                currentIndex = papers.count - 1
                direction = .reverse
            } else {
                direction = .forward
            }
        case .load:
            direction = .forward
            animated = false
            currentIndex = 0
        }

        pageViewController.setViewControllers([diaryPaperViewControllers[self.currentIndex]], direction: direction, animated: animated, completion: nil)
        setupCurrentViewController()
        setupLastViewContoller()
    }

    private func setupCurrentViewController() {
        toolBar.setFavorite(currentViewController?.viewModel.isFavorite ?? false)
    }

    private func setupEmptyViewController() {
        let vc = DiaryPaperEmptyViewController()
        vc.delegate = self

        toolBar.inactivateButtons()
        pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }

    private func moveToPage(index: Int) {
        guard let selectedViewController = self.paperViewControllers?[safe: index], currentIndex != index else { return }
        let direction: UIPageViewController.NavigationDirection
        if currentIndex < index {
            direction = .forward
        } else {
            direction = .reverse
        }
        currentIndex = index
        self.pageViewController.setViewControllers([selectedViewController], direction: direction, animated: true, completion: nil)
    }

    private func presentScheduleModal(date: Date, scheduleType: ScheduleModalType) {
        let alert = DayolAlertController(title: Text.addScheduleTitle, message: Text.addScheduleDesc)
        alert.addAction(.init(title: Text.addScheduleLinkButton, style: .cancel, handler: {
            print("LinkButton")
        }))
        alert.addAction(.init(title: Text.addScheduleAddButton, style: .default, handler: { [weak self] in
            self?.presentPaperModal(toolType: .shedule(date: date, scheduleType: scheduleType))
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension DiaryPaperViewerViewController {
    var currentViewController: DiaryPaperViewController? {
        return paperViewControllers?[safe: currentIndex];
    }

    var isLastViewContrller: Bool {
        return (currentViewController?.index ?? 0) == (paperViewControllers?.count ?? 0) - 1
    }
}

extension DiaryPaperViewerViewController: PaperModalViewDelegate {
    func didTappedItem(_ paper: Paper) {
        guard let index = paperModels?.firstIndex(where: { $0.id == paper.id }) else { return }
        moveToPage(index: index)
    }
    
    func didTappedAddItem() {
        presentPaperModal(toolType: .add)
    }

    func didTappedMonthlyAdd() {
        presentPaperModal(toolType: .date)
    }

    func didSelectedDate(didSelected date: Date?) {
//        guard let currentVC = currentViewController, let pickedDate = date else { return }
//        let orientaion = currentVC.paper.orientaion
//
//        viewModel.addPaper(.monthly, orientation: orientaion, date: pickedDate)
    }

    func didTappedAddDone(paperType: PaperType, orientation: Paper.PaperOrientation) {
        viewModel.addPaper(paperType, orientation: orientation)
    }
}

extension DiaryPaperViewerViewController: DiaryPaperEmptyViewControllerDelegate {
    func didTapEmptyView() {
        presentPaperModal(toolType: .add)
    }
}
