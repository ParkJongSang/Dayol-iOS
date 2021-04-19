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
    static let addPageModalTopMargin: CGFloat = 57.0
}

class DiaryPaperViewerViewController: UIViewController {
    // MARK: - Properties
    
    typealias PaperModel = DiaryInnerModel.PaperModel
    
    private let disposeBag = DisposeBag()
    private var cancellable = [Cancellable]()
    private let viewModel: DiaryPaperViewerViewModel
    private var innerModels: [DiaryInnerModel]?
    
    var currentIndex: Int = 0
    
    // MARK: - UI Component
    
    private let barLeftItem = DYNavigationItemCreator.barButton(type: .backWhite)
    private let barRightItem = DYNavigationItemCreator.barButton(type: .more)
    private let toolBar = DYNavigationItemCreator.functionToolbar()
    private let leftFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let rightFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private(set) var paperViewControllers: [DiaryPaperViewController]?
    
    private let emptyView: DiaryPaperEmptyView = {
        let view = DiaryPaperEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
        navigationController?.navigationBar.barTintColor = viewModel.coverColor
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
        super.viewWillDisappear(animated)
    }
    
    private func initView() {
        view.backgroundColor = .white
        view.addSubview(emptyView)
        setupPageViewController()
        setupNavigationBars()
        setConstraint()
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
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    // MARK: - Bind
    
    private func bind() {
        bindTitle()
        bindEvent()
        bindPaperModel()
    }
    
    private func bindTitle() {
        viewModel.title
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] titleValue in
                let titleView = DYNavigationItemCreator.titleView(titleValue, color: .white)
                self?.navigationItem.titleView = titleView
            })
            .disposed(by: disposeBag)
    }

    private func bindPaperModel() {
        viewModel.paperList
            .observeOn(MainScheduler.instance)
            .filter({ [weak self] inners -> Bool in
                let shouldShowDiaryPeper = !inners[0].paperList.isEmpty
                
                self?.emptyView.isHidden = (shouldShowDiaryPeper == true)
                
                return shouldShowDiaryPeper
            })
            .subscribe(onNext: { [weak self] inners in
                guard let self = self else { return }
                
                let paperList = inners[0].paperList
                var diaryPaperViewControllers = [DiaryPaperViewController]()
                self.innerModels = inners
                
                for (index, paper) in paperList.enumerated() {
                    let paperViewModel = DiaryPaperViewModel(paper: paper, numberOfPapers: 3)
                    let paperViewController = DiaryPaperViewController(index: index, viewModel: paperViewModel)
                    diaryPaperViewControllers.append(paperViewController)
                }
                self.paperViewControllers = diaryPaperViewControllers
                self.pageViewController.setViewControllers([diaryPaperViewControllers[self.currentIndex]], direction: .forward, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    private func bindEvent() {
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
                self?.navigationController?.pushViewController(paperEditViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(didTapEmptyView))
        emptyView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func didTapEmptyView() {
        presentPaperModal(toolType: .add)
    }

    private func presentPaperModal(toolType: PaperModalViewController.PaperToolType) {
        guard let paperList = innerModels?[0].paperList else { return }
        
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        let screenHeight = keyWindow?.bounds.height ?? .zero
        let modalHeight: CGFloat = screenHeight - Design.addPageModalTopMargin
        let modalStyle: DYModalConfiguration.ModalStyle = isPadDevice ? .normal : .custom(containerHeight: modalHeight)
        let configuration = DYModalConfiguration(dimStyle: .black,
                                                 modalStyle: modalStyle)

        let papers = paperList.compactMap {
            PaperModalModel.PaperListCellModel(id: $0.id,
                                               isStarred: false,
                                               paperStyle: $0.paperStyle,
                                               paperType: $0.paperType)
        }
        let modalVC = PaperModalViewController(toolType: toolType, configure: configuration, papers: papers)

        modalVC.didSelectContentItem
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                
                let dismissCompletionHandler: () -> Void = {
                    guard let selectedViewController = self.paperViewControllers?[safe: index] else { return }
                    
                    self.pageViewController.setViewControllers([selectedViewController], direction: .forward, animated: false, completion: nil)
                }
                
                modalVC.dismiss(animated: true) {
                    dismissCompletionHandler()
                }
            })
            .disposed(by: disposeBag)
        
        modalVC.didSelectAddItem
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let dismissCompletionHandler: () -> Void = {
                    self.presentPaperModal(toolType: .add)
                }
                
                modalVC.dismiss(animated: true) {
                    dismissCompletionHandler()
                }
            })
            .disposed(by: disposeBag)
        
        presentCustomModal(modalVC)
    }
}

extension DiaryPaperViewerViewController {
    var currentViewController: DiaryPaperViewController? {
        guard let viewControllers = pageViewController.viewControllers as? [DiaryPaperViewController] else { return nil }
        
        return viewControllers[safe: currentIndex]
    }
}
