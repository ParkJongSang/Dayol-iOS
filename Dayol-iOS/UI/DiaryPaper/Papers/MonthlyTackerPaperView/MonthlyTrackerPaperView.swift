//
//  MonthlyTrackerPaperView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/07/11.
//

import UIKit

private enum Design {
    static func backgroundImage(orientation: Paper.PaperOrientation) -> UIImage? {
        switch orientation {
        case .landscape:
            return UIImage(named: "monthlyTrackerBackgroundLandscape")
        case .portrait:
            return UIImage(named: "monthlyTrackerBackgroundPortrait")
        }
    }
}

final class MonthlyTrackerPaperView: PaperView {
    private let trackerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(orientation: Paper.PaperOrientation) {
        super.init(orientation: orientation)
        trackerImageView.image = Design.backgroundImage(orientation: orientation)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(trackerImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerImageView.topAnchor.constraint(equalTo: topAnchor),
            trackerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackerImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
