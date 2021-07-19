//
//  WeeklyCalendarViewCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/01.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static let weekdayLetterSpace: CGFloat = -0.42
    static let dayLetterSpace: CGFloat = -0.24
    
    static let weeklyLabelLetterSpace: CGFloat = -0.24
    static let weeklyLabelColor: UIColor = UIColor(decimalRed: 0, green: 0, blue: 0, alpha: 0.2)
    static let weeklyLabelFont = UIFont.systemFont(ofSize: 13, weight: .bold)
    
    static let saturdayColor: UIColor = UIColor(decimalRed: 43, green: 81, blue: 206)
    static let sundayColor: UIColor = UIColor.dayolRed
    
    static let weekdayFont = UIFont.systemFont(ofSize: 11, weight: .bold)
    static let dayFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    
    static let dayLabelTop: CGFloat = 8
    static let dayLabelLeading: CGFloat = 8
    static let dayLabelHeight: CGFloat = 15
    
    static let weeklyLabelTop: CGFloat = 8
    static let weeklyLabelLeading: CGFloat = 8
    static let weeklyLabelHeight: CGFloat = 15
    
    static let weekdayLabelLeading: CGFloat = 8
    static let weekdayLabelHeight: CGFloat = 13
    // TODO: Event Design
    
    static let separatorLineColor: UIColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorLineWidth: CGFloat = 1

    static let textInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: -5, right: -5)
}

private enum Text: String {
    case weekly = "WEEKLY"
}

class WeeklyCalendarViewCell: UICollectionViewCell {
    private enum LabelType {
        case day
        case weekly
        case weekday
    }

    static let identifier: String = "\(WeeklyCalendarViewCell.self)"

    let didLongTapped = PublishSubject<Void>()
    var disposeBag = DisposeBag()

    
    private let rightSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let topSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Design.separatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let weeklyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()

    private(set) var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byCharWrapping

        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = ""
        disposeBag = DisposeBag()
    }
    
    private func initView() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weeklyLabel)
        contentView.addSubview(weekdayLabel)
        contentView.addSubview(rightSeparatorLine)
        contentView.addSubview(topSeparatorLine)
        contentView.addSubview(textView)
        setupConstraints()

        setupGestureRecognizer()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.dayLabelTop),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.dayLabelLeading),
            dayLabel.heightAnchor.constraint(equalToConstant: Design.dayLabelHeight),
            
            weeklyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.weeklyLabelTop),
            weeklyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.weeklyLabelLeading),
            weeklyLabel.heightAnchor.constraint(equalToConstant: Design.weeklyLabelHeight),
            
            weekdayLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: Design.weekdayLabelLeading),
            weekdayLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            weekdayLabel.heightAnchor.constraint(equalToConstant: Design.weekdayLabelHeight),
            
            rightSeparatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightSeparatorLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightSeparatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightSeparatorLine.widthAnchor.constraint(equalToConstant: Design.separatorLineWidth),
            
            topSeparatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topSeparatorLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeparatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topSeparatorLine.heightAnchor.constraint(equalToConstant: Design.separatorLineWidth),

            textView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: Design.textInset.top),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.textInset.left),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Design.textInset.right),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Design.textInset.bottom)
        ])
    }

    func configure(model: WeeklyCalendarDataModel, text: NSAttributedString) {
        dayLabel.attributedText = attributedString(type: .day, model: model)
        weeklyLabel.attributedText = attributedString(type: .weekly, model: model)
        weekdayLabel.attributedText = attributedString(type: .weekday, model: model)
        textView.attributedText = text
        
        setFirstCell(false)
    }
    
    func setFirstCell(_ isFirst: Bool) {
        dayLabel.isHidden = isFirst
        weekdayLabel.isHidden = isFirst
        weeklyLabel.isHidden = !isFirst
        textView.isHidden = isFirst
    }

    private func setupGestureRecognizer() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongTappedCell(_:)))
        addGestureRecognizer(longTapGesture)
    }

    @objc
    private func didLongTappedCell(_ sender: Any?) {
        didLongTapped.onNext(())
    }
    
    private func attributedString(type: LabelType, model: WeeklyCalendarDataModel) -> NSAttributedString {
        switch type {
        case .day:
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: Design.dayLetterSpace,
                .font: Design.dayFont
            ]
            
            return NSAttributedString(string: String(model.day), attributes: attributes)
        case .weekday:
            var fontColor = UIColor.gray900
            if model.weekDay == .sunday {
                fontColor = Design.sundayColor
            } else if model.weekDay == .saturday {
                fontColor = Design.saturdayColor
            }
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: Design.weekdayLetterSpace,
                .font: Design.weekdayFont,
                .foregroundColor: fontColor
            ]
            
            return NSAttributedString(string: model.weekDay.stringValue, attributes: attributes)
        case .weekly:
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: Design.weeklyLabelLetterSpace,
                .font: Design.dayFont,
                .foregroundColor: Design.weeklyLabelColor
            ]
            
            return NSAttributedString(string: "WEEKLY", attributes: attributes)
        }
    }
}
