//
//  DiaryPaperViewerViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/08.
//

import Foundation
import RxSwift

class DiaryPaperViewerViewModel {
    private let model: DiaryPaperViewerModel
    private let coverModel: DiaryCoverModel
    
    var title: Observable<String> {
        return model.diaryTitle.asObservable()
    }
    
    var paperList: Observable<[DiaryInnerModel]> {
        return model.innerModelsSubject.asObservable()
    }
    
    var coverColor: UIColor {
        return coverModel.color.coverColor
    }
    
    init(coverModel: DiaryCoverModel) {
        self.coverModel = coverModel
        self.model = DiaryPaperViewerModel(coverModel: coverModel)
    }
}
