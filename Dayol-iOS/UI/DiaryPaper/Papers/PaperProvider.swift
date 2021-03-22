//
//  PaperProvider.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/23.
//

import UIKit

final class PaperProvider {
    static func create(type: PaperType, style: PaperStyle) -> BasePaper {
        let paper: BasePaper
        switch type {
        case .muji:
            let viewModel = PaperViewModel(drawModel: DrawModel())
            paper = MujiPaper(viewModel: viewModel, paperStyle: style)
        case .cornell:
            let viewModel = PaperViewModel(drawModel: DrawModel())
            paper = CornellPaper(viewModel: viewModel, paperStyle: style)
        case .four:
            let viewModel = PaperViewModel(drawModel: DrawModel())
            paper = FourPaper(viewModel: viewModel, paperStyle: style)
        case .grid:
            let viewModel = PaperViewModel(drawModel: DrawModel())
            paper = GridPaper(viewModel: viewModel, paperStyle: style)
        case .tracker:
            let viewModel = PaperViewModel(drawModel: DrawModel())
            paper = MujiPaper(viewModel: viewModel, paperStyle: style)
        case .daily(date: let date):
            let viewModel = DailyPaperViewModel(date: Date(), drawModel: DrawModel())
            paper = DailyPaper(viewModel: viewModel, paperStyle: style)
        case .weekly:
            let viewModel = WeeklyCalendarViewModel()
            paper = WeeklyCalendarView(viewModel: viewModel, paperStyle: style)
        case .monthly:
            let viewModel = MonthlyCalendarViewModel()
            paper = MonthlyCalendarView(viewModel: viewModel, paperStyle: style)
        }
        
        return paper
    }
}
