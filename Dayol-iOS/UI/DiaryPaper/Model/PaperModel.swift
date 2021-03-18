//
//  PaperModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/20.
//

import UIKit

enum CommonPaperDesign {
    static let defaultBGColor = UIColor.white
    static let borderColor = UIColor(decimalRed: 233, green: 233, blue: 233)
}

enum PaperStyle: String, CaseIterable {
    case horizontal
    case vertical
}

enum PaperType {

    case monthly
    case weekly
    case daily(date: Date)
    case cornell
    case muji
    case grid
    case four
    case tracker

    static var allCases: [PaperType] {
        return [.monthly,
                .weekly,
                .daily(date: Date()),
                .cornell,
                .muji,
                .grid,
                .four,
                .tracker]
    }

    var title: String {
        switch self {
        case .monthly: return "memo_list_monthly".localized
        case .weekly: return "memo_list_weekly".localized
        case .daily(_): return "memo_list_daily".localized
        case .cornell: return "memo_list_kornell".localized
        case .muji: return "memo_list_muji".localized
        case .grid: return "memo_list_grid".localized
        case .four: return "memo_list_4cell".localized
        case .tracker: return "memo_list_tracker".localized
        }
    }
}

extension PaperStyle {
    var paperWidth: CGFloat {
        switch self {
        case .horizontal: return 1024.0
        case .vertical: return 614.0
        }
    }

    var paperHeight: CGFloat {
        switch self {
        case .horizontal: return 662.0
        case .vertical: return 917.0
        }
    }

    var maximumZoomIn: CGFloat {
        return 3.0
    }

    func contentStackViewInset(scrollViewSize: CGSize) -> UIEdgeInsets {
        let width = scrollViewSize.width
        let gap = (width - paperWidth) / 2
        return UIEdgeInsets(top: 0, left: gap, bottom: 20, right: gap)
    }

    func minimumZoomOut(scrollViewSize: CGSize) -> CGFloat {
        switch self {
        case .horizontal:
            return scrollViewSize.width / paperWidth
        case .vertical:
            return scrollViewSize.height / paperHeight
        }
    }
}

struct Line {
    // drawing object에 대한 모델
}

struct Sticker {
    // sticker object에 대한 모델
}

struct Label {
    // label object에 대한 모델
}

struct DrawModel {
    var lines: [Line] = []
    var stickers: [Sticker] = []
    var labels: [Label]  = []
}
