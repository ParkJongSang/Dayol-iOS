//
//  DiaryPaperViewerModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/08.
//

import Foundation
import RxSwift

class DiaryPaperViewerModel {
    /// DiaryPageTestData는 DB라고 생각할 것
    /// DB에 요청할 파라미터는 추후 논의 일단은 void로 둠(init)
    
    let testDrawModel = DiaryPageTestData.testDrawModel
    var innerModels: [DiaryInnerModel] = DiaryPageTestData.shared.diaryList
    let innerModelsSubject = DiaryPageTestData.shared.diaryListSubject
    let diaryTitle = BehaviorSubject<String>(value: "")

    init(coverModel: DiaryCoverModel) {
        diaryTitle.onNext(coverModel.title)
    }
    
    @discardableResult
    func add(diary: DiaryInnerModel) -> Observable<DiaryInnerModel> {
        DiaryPageTestData.shared.addDiary(diary)
        
        return Observable.just(diary)
    }
    
    @discardableResult
    func delete(diary: DiaryInnerModel) -> Observable<DiaryInnerModel> {
        DiaryPageTestData.shared.deleteDiary(diary)
        
        return Observable.just(diary)
    }
    
    func deleteAll() {
        DiaryPageTestData.shared.deleteAll()
    }

}
