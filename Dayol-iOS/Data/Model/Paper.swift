//
//  Paper.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/06/13.
//

import Foundation

struct Paper {
    enum PaperOrientation: String {
        case portrait = "PORTRAIT"
        case landscape = "LANDSCAPE"
    }

    let id: String // P1, P2
    let diaryId: String
    let title: String
    let pageCount: Int32
    let orientation: String
    let type: PaperType
    let width: Float
    let height: Float

    var isFavorite: Bool
    var thumbnail: Data?
    var drawCanvas: Data
    var contents: [DecorationItem]

    var date: Date?

    init(id: String,
         diaryId: String,
         title: String,
         pageCount: Int,
         orientation: PaperOrientation,
         type: PaperType,
         width: Float,
         height: Float,
         thumbnail: Data?,
         drawCanvas: Data,
         contents: [DecorationItem],
         date: Date?,
         isFavorite: Bool) {
        self.id = id
        self.diaryId = diaryId
        self.title = title
        self.pageCount = Int32(pageCount)
        self.orientation = orientation.rawValue
        self.type = type
        self.width = width
        self.height = height
        self.thumbnail = thumbnail
        self.drawCanvas = drawCanvas
        self.contents = contents
        self.date = date
        self.isFavorite = isFavorite
    }
}

enum PaperType: String {
    case monthly
    case weekly
    case daily
    case cornell
    case muji
    case grid
    case quartet
    case tracker

    static var allCases: [PaperType] {
        return [.monthly,
                .weekly,
                .daily,
                .cornell,
                .muji,
                .grid,
                .quartet,
                .tracker]
    }

    init?(string: String) {
        self = PaperType(rawValue: string) ?? .muji
    }

    var asString: String {
        return self.rawValue.uppercased()
    }

    var typeName: String {
        switch self {
        case .monthly: return "memo_list_monthly".localized
        case .weekly: return "memo_list_weekly".localized
        case .daily: return "memo_list_daily".localized
        case .cornell: return "memo_list_kornell".localized
        case .muji: return "memo_list_muji".localized
        case .grid: return "memo_list_grid".localized
        case .quartet: return "memo_list_4cell".localized
        case .tracker: return "memo_list_tracker".localized
        }
    }

    var identifier: String {
        switch self {
        case .monthly: return MonthlyCalendarPaperView.className
        case .weekly: return WeeklyCalendarView.className
        case .daily: return DailyPaperView.className
        case .cornell: return CornellPaperView.className
        case .muji: return MujiPaperView.className
        case .grid: return GridPaperView.className
        case .quartet: return QuartetPaperView.className
        case .tracker: return MonthlyTrackerPaperView.className
        }
    }
}
