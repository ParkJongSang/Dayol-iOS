//
//  AddPaperHeaderView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/02.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let titleFont = UIFont.appleBold(size: 18.0)
    static let titleLetterSpacing: CGFloat = -0.7
    static let titleColor = UIColor.black
    static let titleAreaSpacing: CGFloat = 8.0
}

private enum Text: String {
    case title = "add_memo_alert_title"
    
    var stringValue: String {
        return self.rawValue.localized
    }
}

class AddPaperHeaderView: UIView {
    private(set) var disposeBag = DisposeBag()
    private(set) var barLeftButton = DYNavigationItemCreator.barButton(type: .cancel)
    private(set) var barRightButton = DYNavigationItemCreator.barButton(type: .done)
    
    let didTappedDone = PublishSubject<Void>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.build(
            text: Text.title.stringValue,
            font: Design.titleFont,
            align: .center,
            letterSpacing: Design.titleLetterSpacing,
            foregroundColor: Design.titleColor
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        initView()
        setConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension AddPaperHeaderView {

    func initView() {
        addSubview(titleLabel)
        addSubview(barLeftButton)
        addSubview(barRightButton)

        barLeftButton.translatesAutoresizingMaskIntoConstraints = false
        barRightButton.translatesAutoresizingMaskIntoConstraints = false
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            barLeftButton.topAnchor.constraint(equalTo: topAnchor,
                                               constant: Design.titleAreaSpacing),
            barLeftButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: Design.titleAreaSpacing),

            barRightButton.topAnchor.constraint(equalTo: topAnchor,
                                                constant: Design.titleAreaSpacing),
            barRightButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -Design.titleAreaSpacing)
        ])
    }

    private func bind() {
        barRightButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.didTappedDone.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
