//
//  AddPaperContentViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/12.
//

import Foundation

class AddPaperContentViewModel {
    private(set) var papers: [PaperStyle: [PaperModalModel.AddPaperCellModel]]
    private(set) var selectedPaper: PaperModalModel.AddPaperCellModel?
    
    init() {
        papers = [:]

        PaperStyle.allCases.forEach { orientation in
            papers[orientation] = PaperType.allCases.map {
                PaperModalModel.AddPaperCellModel(paperStyle: orientation, paperType: $0)
            }
        }
    }
    
    func selectCell(model cell: PaperModalModel.AddPaperCellModel) {
        selectedPaper = cell
    }
    
    func addPaper() {
        guard let model = selectedPaper else { return }
        
        // TODO: confirm id login
        let paperModel = DiaryInnerModel.PaperModel(
            id: 999,
            paperStyle:model.paperStyle,
            paperType: model.paperType,
            drawModelList: DrawModel()
        )
        
        DYTestData.shared.addPage(paperModel)
    }
}

extension AddPaperContentViewModel {
    func cellModel(_ indexPath: IndexPath, paperStyle: PaperStyle) -> PaperModalModel.AddPaperCellModel? {

        guard let cellModel = papers[paperStyle]?[safe: indexPath.row] else {
            return nil
        }
        return cellModel
    }
}
