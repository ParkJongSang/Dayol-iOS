//
//  DailyPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

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
}

class DailyPaper: BasePaper {   
    private let disposeBag = DisposeBag()
    
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
    
    override func initView() {
        super.initView()
        titleArea.addSubview(dateLabel)
        titleArea.addSubview(dayLabel)
        titleArea.addSubview(separatorView)
        titleArea.translatesAutoresizingMaskIntoConstraints = false

        sizeDefinitionView.addSubview(titleArea)
        sizeDefinitionView.backgroundColor = CommonPaperDesign.defaultBGColor
        sizeDefinitionView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
        
        bindEvent()
    }
    
    func bindEvent() {
        guard let viewModel = viewModel as? DailyPaperViewModel else { return }

        viewModel.date
            .observeOn(MainScheduler.instance)
            .debug()
            .subscribe(onNext: { [weak self] dateString in
                self?.dateText = dateString
            })
            .disposed(by: disposeBag)

        viewModel.day
            .observeOn(MainScheduler.instance)
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

            titleArea.topAnchor.constraint(equalTo: sizeDefinitionView.topAnchor),
            titleArea.leadingAnchor.constraint(equalTo: sizeDefinitionView.leadingAnchor),
            titleArea.trailingAnchor.constraint(equalTo: sizeDefinitionView.trailingAnchor),
            titleArea.heightAnchor.constraint(equalToConstant: Design.titleAreaHeight)
        ])
    }

}

private extension DailyPaper {
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
