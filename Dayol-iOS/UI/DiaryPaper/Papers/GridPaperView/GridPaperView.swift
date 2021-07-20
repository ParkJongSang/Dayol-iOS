//
//  GridPaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit
import RxSwift

private enum Design {
    static let gridLineWidth: CGFloat = 1
    static let gridColor = UIColor(decimalRed: 233, green: 233, blue: 233, alpha: 0.5)

    static let gridCellWidth: CGFloat = 20.0
    static let gridCellHeight: CGFloat = 20.0

    static func numberOfCellInRow(orientation: Paper.PaperOrientation) -> Int {
        return Int(PaperOrientationConstant.size(orentantion: orientation).width / Self.gridCellWidth) + 1
    }

    static func numberOfCellInCol(orientation: Paper.PaperOrientation) -> Int {
        return Int(PaperOrientationConstant.size(orentantion: orientation).height / Self.gridCellHeight) + 1
    }

    static func gridSize(orientation: Paper.PaperOrientation) -> CGSize {
        return CGSize(width: Self.gridCellWidth * CGFloat(Self.numberOfCellInRow(orientation: orientation)),
                      height: Self.gridCellHeight * CGFloat(Self.numberOfCellInCol(orientation: orientation)))
    }
}

final class GridPaperView: PaperView {
    private let gridImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(orientation: Paper.PaperOrientation) {
        super.init(orientation: orientation)
        gridImageView.image = getGridImage()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(gridImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gridImageView.topAnchor.constraint(equalTo: topAnchor),
            gridImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension GridPaperView {

    func getGridImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(Design.gridSize(orientation: orientation), false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setStrokeColor(Design.gridColor.cgColor)
        context.setLineWidth(Design.gridLineWidth)
        context.setLineCap(.square)

        for row in 0..<Design.numberOfCellInCol(orientation: orientation) + 1 {
            let positionY = row * Int(Design.gridCellHeight)
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: Int(Design.gridSize(orientation: orientation).width), y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        for col in 0..<Design.numberOfCellInRow(orientation: orientation) + 1{
            let positionX = col * Int(Design.gridCellWidth)
            let startPoint = CGPoint(x: positionX, y: 0)
            let endPoint = CGPoint(x: positionX, y: Int(Design.gridSize(orientation: orientation).height))

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
