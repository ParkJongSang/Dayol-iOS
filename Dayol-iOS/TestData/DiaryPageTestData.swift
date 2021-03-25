//
//  DiaryPageTestData.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/22.
//

import Foundation
import RxSwift

// MARK: - 다이어리 한 개당 내부에 표현될 데이터를 테스트하기위해 작성한 코드입니다.

// 다이어리 한 개의 내부 데이터에 대한 테스트 모델
struct DiaryInnerModel {

    // 다이어리 내부 다양한 종류의 메모에 대한 테스트 모델
    struct PaperModel {
        let id: Int
        let paperStyle: PaperStyle
        let paperType: PaperType
        // TODO: - 속지 추가 스펙이 있어서 [DrawModel] 로 변경되어야 할 것 같습니다.
        var drawModelList: DrawModel
    }

    let diaryID: Int
    var paperList: [PaperModel]

}

class DiaryPageTestData {
    static let shared = DiaryPageTestData()
    static let testDrawModel = DrawModel(lines: [], stickers: [], labels: [])

    var diaryList: [DiaryInnerModel] = [
        DiaryInnerModel(diaryID: 0,
                        paperList: [
                            DiaryInnerModel.PaperModel(id: 0,
                                                       paperStyle: .vertical,
                                                       paperType: .daily(date: Date()),
                                                       drawModelList: testDrawModel),
                            DiaryInnerModel.PaperModel(id: 1,
                                                       paperStyle: .vertical,
                                                       paperType: .cornell,
                                                       drawModelList: testDrawModel),
                            DiaryInnerModel.PaperModel(id: 2,
                                                       paperStyle: .vertical,
                                                       paperType: .grid,
                                                       drawModelList: testDrawModel),
                            DiaryInnerModel.PaperModel(id: 3,
                                                       paperStyle: .vertical,
                                                       paperType: .monthly,
                                                       drawModelList: testDrawModel),
                            DiaryInnerModel.PaperModel(id: 4,
                                                       paperStyle: .vertical,
                                                       paperType: .weekly,
                                                       drawModelList: testDrawModel),
                            DiaryInnerModel.PaperModel(id: 5,
                                                       paperStyle: .vertical,
                                                       paperType: .four,
                                                       drawModelList: testDrawModel),
                            DiaryInnerModel.PaperModel(id: 6,
                                                       paperStyle: .vertical,
                                                       paperType: .tracker,
                                                       drawModelList: testDrawModel)
                        ])
    ]

    lazy var diaryListSubject = BehaviorSubject<[DiaryInnerModel]>(value: diaryList)

    func addDiary(_ diary: DiaryInnerModel) {
        diaryList.append(diary)
        diaryListSubject.onNext(diaryList)
    }

    func deleteDiary(_ diary: DiaryInnerModel) {
        guard let index = diaryList.firstIndex(where: { $0.diaryID == diary.diaryID }) else { return }
        diaryList.remove(at: index)
        diaryListSubject.onNext(diaryList)
    }

    func deleteAll() {
        diaryList = []
        diaryListSubject.onNext(diaryList)
    }
}
