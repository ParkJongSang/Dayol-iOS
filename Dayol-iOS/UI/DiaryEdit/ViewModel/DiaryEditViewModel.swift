//
//  DiaryEditViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/08.
//

import Foundation
import RxSwift
import RxCocoa

class DiaryEditViewModel {
    let diaryColors: [DiaryCoverColor] = DiaryCoverColor.allCases
    let diaryInitalTitle: String = "새 다이어리"
    
    func createDiaryInfo(model: DiaryCoverModel) {
        DYTestData.shared.create(diary: model)
    }
}
