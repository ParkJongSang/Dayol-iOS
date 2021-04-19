//
//  AddPaperModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/13.
//

import Foundation

enum PaperModalModel {
    struct AddPaperCellModel {
        let paperStyle: PaperStyle
        let paperType: PaperType
        
        var title: String {
            paperType.title
        }
        var thumbnailName: String {
            paperType.tumbNailImageName + "_\(paperStyle.rawValue)"
        }
    }

    struct PaperListCellModel {
        let id: Int
        let isStarred: Bool
        let paperStyle: PaperStyle
        let paperType: PaperType

        var title: String {
            paperType.title
        }
        // TODO: - 실제 썸네일 캡쳐 후 사용 시 모델 변경 필요
        var thumbnailName: String {
            return paperType.tumbNailImageName + "_\(paperStyle.rawValue)"
        }
    }
}

private extension PaperType {
    var tumbNailImageName: String {
        switch self {
        case .monthly: return "paper_add_monthly"
        case .weekly: return "paper_add_weekly"
        case .daily(_): return "paper_add_daily"
        case .cornell: return "paper_add_cornell"
        case .muji: return "paper_add_muji"
        case .grid: return "paper_add_grid"
        case .four: return "paper_add_four"
        case .tracker: return "paper_add_tracker"
        }
    }
}
