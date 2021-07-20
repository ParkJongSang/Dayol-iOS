//
//  WeeklyCalendarHeaderView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/01.
//

import UIKit
import RxCocoa
import RxSwift

private enum Design {
    static let monthFont: UIFont = UIFont.helveticaBold(size: 26)
    static let monthLetterSpace: CGFloat = -0.79
    static let mohthFontColor: UIColor = .black
    static let monthTop: CGFloat = 18
    static let monthLeading: CGFloat = 18
    
    static let buttonLeft: CGFloat = 8
    static let buttonSize: CGSize = CGSize(width: 8, height: 4)
    static let buttonImage = UIImage(named: "downArrow")
    static let height: CGFloat = 86
}

class WeeklyCalendarHeaderView: UICollectionReusableView {
    static let height: CGFloat = Design.height

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(monthLabel)
        addSubview(arrowButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Design.monthLeading),
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: Design.monthTop),
            
            arrowButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            arrowButton.leftAnchor.constraint(equalTo: monthLabel.rightAnchor, constant: Design.buttonLeft)
        ])
    }
}

extension WeeklyCalendarHeaderView {
    var month: Month? {
        get {
            return Month.allCases.first { $0.asString == monthLabel.attributedText?.string }
        }
        set {
            guard let stringValue = newValue?.asString else { return }
            let attributes: [NSAttributedString.Key: Any] = [
                .font: Design.monthFont,
                .kern: Design.monthLetterSpace
            ]
            let attributedText = NSMutableAttributedString(string: stringValue, attributes: attributes)
            monthLabel.attributedText = attributedText
        }
    }
}

