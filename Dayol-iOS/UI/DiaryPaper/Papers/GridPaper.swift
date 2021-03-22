//
//  GridPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import RxSwift

private enum Design {
    static let gridLineWidth: CGFloat = 1
    static let gridColor = UIColor(decimalRed: 233, green: 233, blue: 233, alpha: 0.5)
}

private extension PaperStyle {
    static let gridCellWidth: CGFloat = 20.0
    static let gridCellHeight: CGFloat = 20.0

    var numberOfCellInRow: Int {
        return Int(size.width / Self.gridCellWidth) + 1
    }

    var numberOfCellInCol: Int {
        return Int(size.height / Self.gridCellHeight) + 1
    }

    var gridSize: CGSize {
        return CGSize(width: Self.gridCellWidth * CGFloat(numberOfCellInRow),
                      height: Self.gridCellHeight * CGFloat(numberOfCellInCol))
    }
}

class GridPaper: BasePaper {
    private let gridImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func initView() {
        super.initView()
        gridImageView.image = getGridImage()
        gridImageView.contentMode = .topLeft

        sizeDefinitionView.addSubViewPinEdge(gridImageView)
    }
}

private extension GridPaper {

    func getGridImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(paperStyle.gridSize, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setStrokeColor(Design.gridColor.cgColor)
        context.setLineWidth(Design.gridLineWidth)
        context.setLineCap(.square)

        for row in 0..<paperStyle.numberOfCellInCol + 1 {
            let positionY = row * Int(PaperStyle.gridCellHeight)
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: Int(paperStyle.gridSize.width), y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        for col in 0..<paperStyle.numberOfCellInRow + 1{
            let positionX = col * Int(PaperStyle.gridCellWidth)
            let startPoint = CGPoint(x: positionX, y: 0)
            let endPoint = CGPoint(x: positionX, y: Int(paperStyle.gridSize.height))

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        context.strokePath()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
