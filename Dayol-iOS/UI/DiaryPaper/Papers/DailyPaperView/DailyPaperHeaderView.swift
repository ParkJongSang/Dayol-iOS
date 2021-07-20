//
//  DailyPaperHeaderView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/20.
//

import UIKit

private enum Design {
    static let titleColor = UIColor.black
    static let titleAreaHeight: CGFloat = 60.0

    static let separatorColor = UIColor(decimalRed: 233, green: 233, blue: 233)
    static let separatorHeight: CGFloat = 1.0

    static let dateFont = UIFont.helveticaBold(size: 26.0)
    static let dateSpacing: CGFloat = -0.79
    static let dateTop: CGFloat = 15
    static let dateLeading: CGFloat = 18
    static let dateBottom: CGFloat = 14

    static let dayFont = UIFont.systemFont(ofSize: 13.0, weight: .bold)
    static let daySpacing: CGFloat = -0.5

    static let dateLeftMargin: CGFloat = 18.0
    static let dayLeftMargin: CGFloat = 7.0

    static func height(orientation: Paper.PaperOrientation) -> CGFloat {
        switch orientation {
        case .landscape:
            return 72
        case .portrait:
            return 60
        }
    }
}

final class DailyPaperHeaderView: UICollectionReusableView {
    static func height(orientation: Paper.PaperOrientation) -> CGFloat {
        return Design.height(orientation: orientation)
    }

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

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(dateLabel)
        addSubview(dayLabel)
        addSubview(separatorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Design.dateTop),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.dateLeading),

            dayLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: Design.dayLeftMargin),

            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Design.separatorHeight)
        ])
    }
}

extension DailyPaperHeaderView {
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

    var dayText: String? {
        get {
            return dayLabel.attributedText?.string
        }
        set {
            guard let day = newValue else { return }
            dayLabel.attributedText = NSAttributedString.build(text: day,
                                                               font: Design.dayFont,
                                                               align: .left,
                                                               letterSpacing: Design.daySpacing,
                                                               foregroundColor: Design.titleColor)
            dayLabel.sizeToFit()
        }
    }
}
