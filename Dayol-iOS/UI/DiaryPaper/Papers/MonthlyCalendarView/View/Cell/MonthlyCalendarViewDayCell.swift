//
//  MonthlyCalendarViewDayCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/26
//

import UIKit

private enum Design {
    static let daySize: CGSize = CGSize(width: 16, height: 16)
    static let dayFont: UIFont = UIFont.systemFont(ofSize: 11, weight: .regular)
    static let dayLetterSpace: CGFloat = -0.2
    static let dayTextColorForCurrentMonth: UIColor = .black
    static let dayTextColorForOtherMonth = UIColor.black.withAlphaComponent(0.2)
    static let todayBackground: UIColor = UIColor(decimalRed: 226, green: 226, blue: 226)
    static let todayRadius: CGFloat = 8
    
    static let dayTop: CGFloat = 2
    static let dayLabelLeft: CGFloat = 2
    static let dayLabelRight: CGFloat = 2
    
    static let verticalSeparatorLineColor: UIColor = UIColor(decimalRed: 250, green: 250, blue: 250)
    static let horizontalSeparatorLineColor: UIColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorLineWidth: CGFloat = 1
}

class MonthlyCalendarViewDayCell: UICollectionViewCell {
    static let identifier = "\(MonthlyCalendarViewDayCell.self)"
    
    private let rightSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Design.verticalSeparatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Design.horizontalSeparatorLineColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dayBackgroundView: UIView = {
        let view =  UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Design.todayRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        return label
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
    
    private func initView() {
        contentView.addSubview(dayBackgroundView)
        contentView.addSubview(rightSeparatorLine)
        contentView.addSubview(bottomSeparatorLine)
        dayBackgroundView.addSubview(dayLabel)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            dayBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.dayTop),
            dayBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: Design.daySize.width),
            dayLabel.topAnchor.constraint(equalTo: dayBackgroundView.topAnchor),
            dayLabel.leftAnchor.constraint(equalTo: dayBackgroundView.leftAnchor, constant: Design.dayLabelLeft),
            dayLabel.rightAnchor.constraint(equalTo: dayBackgroundView.rightAnchor, constant: -Design.dayLabelRight),
            dayLabel.bottomAnchor.constraint(equalTo: dayBackgroundView.bottomAnchor),
            dayLabel.heightAnchor.constraint(equalToConstant: Design.daySize.height),
            
            rightSeparatorLine.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            rightSeparatorLine.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightSeparatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightSeparatorLine.widthAnchor.constraint(equalToConstant: Design.separatorLineWidth),
            
            bottomSeparatorLine.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bottomSeparatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomSeparatorLine.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bottomSeparatorLine.heightAnchor.constraint(equalToConstant: Design.separatorLineWidth)
        ])
    }
    
    private func dayAttributedString(_ day: Int, isCurrentMonth: Bool) -> NSAttributedString {
        let dayString = String(day)
        let textColor = isCurrentMonth ? Design.dayTextColorForCurrentMonth : Design.dayTextColorForOtherMonth
        let attributes: [NSAttributedString.Key : Any] = [
            .font : Design.dayFont,
            .kern : Design.dayLetterSpace,
            .foregroundColor : textColor,
        ]
        
        return NSAttributedString(string: dayString, attributes: attributes)
    }
    
    func configure(model: MonthlyCalendarDayModel) {
        dayLabel.attributedText = dayAttributedString(model.dayNumber, isCurrentMonth: model.isCurrentMonth)
        dayBackgroundView.backgroundColor = model.isToday ? Design.todayBackground : .clear
    }
}
