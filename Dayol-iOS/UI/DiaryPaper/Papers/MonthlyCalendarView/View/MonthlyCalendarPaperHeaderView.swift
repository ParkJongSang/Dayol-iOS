//
//  MonthlyCalendarHeaderView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/25.
//

import UIKit
import RxCocoa
import RxSwift

private enum Design {
    static let monthFont: UIFont = UIFont.helveticaBold(size: 26)
    static let monthLetterSpace: CGFloat = -0.79
    static let mohthFontColor: UIColor = .black
    static var monthTop: CGFloat = 18
    static var monthLeading: CGFloat = 18
    static var monthBottom: CGFloat = 18
    
    static let buttonLeft: CGFloat = 8
    static let buttonSize: CGSize = CGSize(width: 8, height: 4)
    static let buttonImage = UIImage(named: "downArrow")

    static let sundayColor = UIColor.dayolRed
    static let saturdayColor = UIColor(decimalRed: 41, green: 85, blue: 230)
    static let weekDayHeight: CGFloat = 20

    static let dayFont = UIFont.systemFont(ofSize: 11, weight: .bold)
    static let dayColor: UIColor = .black
    static let dayLetterSpace: CGFloat = -0.42

    static let separatorLineColor: UIColor = .gray200
    static let separatorLineWidth: CGFloat = 1

    static func height(orientation: Paper.PaperOrientation) -> CGFloat {
        switch orientation {
        case .landscape:
            return 101
        case .portrait:
            return 86
        }
    }
}

protocol MonthlyCalendarPaperHeaderViewDelegate: AnyObject {
    func headerViewDidTappedLabel(_ monthlyCalendarHeaderView: MonthlyCalendarPaperHeaderView)
}

final class MonthlyCalendarPaperHeaderView: UICollectionReusableView {
    static func height(orientation: Paper.PaperOrientation) -> CGFloat {
        return Design.height(orientation: orientation)
    }

    weak var delegate: MonthlyCalendarPaperHeaderViewDelegate?

    private let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = Design.mohthFontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Design.buttonSize.width, height: Design.buttonSize.height))
        let buttonImage = Design.buttonImage
        button.setImage(Design.buttonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    private let weekDayView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let separatorLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Design.separatorLineWidth))
        view.backgroundColor = Design.separatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let dayLabels: [UILabel] = {
        var labels = [UILabel]()
        let attributes: [NSAttributedString.Key: Any] = [
            .font : Design.dayFont,
            .kern : Design.dayLetterSpace
        ]
        WeekDay.allCases.forEach { weekday in
            let dayColor: UIColor
            let label = UILabel()
            if weekday == .sunday {
                dayColor = Design.sundayColor
            } else if weekday == .saturday {
                dayColor = Design.saturdayColor
            } else {
                dayColor = Design.dayColor
            }
            let attributedText = NSAttributedString(string: weekday.stringValue, attributes: attributes)
            label.textColor = dayColor
            label.attributedText = attributedText
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            labels.append(label)
        }

        return labels
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(monthLabel)
        addSubview(arrowButton)
        addSubview(weekDayView)
        addSubview(separatorLine)
        dayLabels.forEach { weekDayView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.monthLeading),
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: Design.monthTop),
            
            arrowButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            arrowButton.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: Design.buttonLeft),

            weekDayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            weekDayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekDayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekDayView.heightAnchor.constraint(equalToConstant: Design.weekDayHeight),

            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.topAnchor.constraint(equalTo: weekDayView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: Design.separatorLineWidth),
        ])
    }

    @objc
    private func didTappedHeaderView(_ sender: Any?) {
        delegate?.headerViewDidTappedLabel(self)
    }
}

extension MonthlyCalendarPaperHeaderView {
    var month: Month {
        get {
            return Month.allCases.first { $0.asString == monthLabel.attributedText?.string } ?? .january
        }
        set {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: Design.monthFont,
                .kern: Design.monthLetterSpace
            ]
            let attributedText = NSMutableAttributedString(string: newValue.asString, attributes: attributes)
            monthLabel.attributedText = attributedText
        }
    }
}

