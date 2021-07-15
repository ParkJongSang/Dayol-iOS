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
}

class MonthlyCalendarHeaderView: UIView {
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

    init(month: Month) {
        super.init(frame: .zero)
        self.month = month
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(monthLabel)
        addSubview(arrowButton)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            monthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Design.monthLeading),
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: Design.monthTop),
            monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Design.monthBottom),
            
            arrowButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            arrowButton.leftAnchor.constraint(equalTo: monthLabel.rightAnchor, constant: Design.buttonLeft)
        ])
    }
}

extension MonthlyCalendarHeaderView {
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

