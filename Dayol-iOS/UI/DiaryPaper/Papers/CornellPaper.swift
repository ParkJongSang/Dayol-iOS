//
//  CornellPaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/27.
//

import RxSwift

private enum Design {
    static let redLineColor = UIColor(decimalRed: 226, green: 88, blue: 88)
    static let headerSeparatorColor = UIColor(decimalRed: 102, green: 102, blue: 102)
    static let lineColor = UIColor(decimalRed: 233, green: 233, blue: 233)

    static let lineWidth: CGFloat = 1
}

private extension PaperStyle {

    static let lineHeight: CGFloat = 30.0

    var titleAreaHeight: CGFloat {
        switch self {
        case .horizontal: return 50.0
        case .vertical: return 64.0
        }
    }

    var redLineOriginX: CGFloat {
        switch self {
        case .horizontal: return 200.0
        case .vertical: return 100.0
        }
    }

    func numberOfLineInPage(isFirstPage: Bool) -> Int {
        if isFirstPage {
            return Int(size.height - titleAreaHeight / Self.lineHeight) + 1
        } else {
            return Int(size.height / Self.lineHeight) + 1
        }
    }

}

class CornellPaper: BasePaper {
    private let cornellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private(set) var isFirstPage: Bool = true
    
    override func initView() {
        super.initView()
        cornellImageView.image = getCornellImage(isFirstPage: isFirstPage)
        cornellImageView.contentMode = .topLeft
        sizeDefinitionView.addSubViewPinEdge(cornellImageView)
    }
}

private extension CornellPaper {
    func getCornellImage(isFirstPage: Bool) -> UIImage? {
        let paperSize = CGSize(width: paperStyle.size.width, height: paperStyle.size.height)
        UIGraphicsBeginImageContextWithOptions(paperSize, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }

        context.setLineWidth(Design.lineWidth)
        context.setLineCap(.square)

        // MARK: Draw Each base Line

        context.setStrokeColor(Design.lineColor.cgColor)

        let positionMargin = isFirstPage ? paperStyle.titleAreaHeight : 0

        for row in 0..<paperStyle.numberOfLineInPage(isFirstPage: isFirstPage) + 1 {
            let positionY = row * Int(PaperStyle.lineHeight) + Int(positionMargin)
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: Int(paperStyle.size.width), y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)
        }

        context.strokePath()

        // MARK: Draw Red Line

        context.setStrokeColor(Design.redLineColor.cgColor)

        let positionX = paperStyle.redLineOriginX
        let startPoint = CGPoint(x: positionX, y: positionMargin)
        let endPoint = CGPoint(x: positionX, y: paperStyle.size.height)

        context.move(to: startPoint)
        context.addLine(to: endPoint)

        context.strokePath()

        // MARK: Draw Header If Needed

        if isFirstPage {
            context.setStrokeColor(Design.headerSeparatorColor.cgColor)

            let positionY = paperStyle.titleAreaHeight
            let startPoint = CGPoint(x: 0, y: positionY)
            let endPoint = CGPoint(x: paperStyle.size.width, y: positionY)

            context.move(to: startPoint)
            context.addLine(to: endPoint)

            context.strokePath()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
