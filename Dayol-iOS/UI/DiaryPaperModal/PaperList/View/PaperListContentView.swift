//
//  PaperListContentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/02.
//

import RxSwift
import RxCocoa

private enum Design {
    static let contentBGColor = UIColor(decimalRed: 242, green: 244, blue: 246)

    static let collectionViewInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    static let itemSpacing: CGFloat = 28.0
    static let lineSpacing: CGFloat = isPadDevice ? 40.0 : 24.0
}

private enum Text: String {
    case info = "page_text"
    
    var stringValue: String {
        return self.rawValue.localized
    }
}

class PaperListContentView: UIView {

    let disposeBag = DisposeBag()
    let didSelectItem = PublishSubject<Int>()
    let didSelectAddCell = PublishSubject<Void>()
    
    private let papers: [PaperModalModel.PaperListCellModel]
    private var shouldShowInfoLabel: Bool {
        return true
    }

    private(set) lazy var viewModel: PaperListContentViewModel = PaperListContentViewModel(papers: papers)
    var isEditMode = false
    // MARK: - UI Property

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private(set) lazy var infoView: InfoView = {
        let view = InfoView(text: Text.info.stringValue)
        view.closeButton.rx.tap
            .bind { [weak self] in
                self?.contentStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
            .disposed(by: disposeBag)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = Design.collectionViewInset
        layout.itemSize = PaperListCell.cellSize
        layout.minimumInteritemSpacing = Design.itemSpacing
        layout.minimumLineSpacing = Design.lineSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Design.contentBGColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // TODO: - init에서 viewModel 받아서 바인딩 로직 추가
    init(papers: [PaperModalModel.PaperListCellModel]) {
        self.papers = papers
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func layoutCollectionView() {
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

private extension PaperListContentView {

    private func setupViews() {
        if shouldShowInfoLabel {
            contentStackView.addArrangedSubview(infoView)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PaperListCell.self,
                                forCellWithReuseIdentifier: PaperListCell.className)
        collectionView.register(PaperListAddCell.self,
                                forCellWithReuseIdentifier: PaperListAddCell.className)
        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGestureRecognizer.addTarget(self,
                                             action: #selector(didRecongizeLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        contentStackView.addArrangedSubview(collectionView)
        addSubview(contentStackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
