//
//  DiaryListTestData.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/08.
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

class DYTestData {
    static let shared = DYTestData()
    static let testDrawModel = DrawModel(lines: [], stickers: [], labels: [])
    
    lazy var diaryListSubject = BehaviorSubject<[DiaryCoverModel]>(value: diaryList)
    lazy var deletedPageListSubject = BehaviorSubject<[DeletedPageCellModel]>(value: deletedPageList)
    lazy var pageListSubject = BehaviorSubject<[DiaryInnerModel]>(value: pageList)
    
    var diaryList: [DiaryCoverModel] = [
        DiaryCoverModel(color: .DYRed, title: "1번 다이어리", totalPage: 3, password: "1234"),
        DiaryCoverModel(color: .DYBlue, title: "2번 다이어리", totalPage: 2, password: "1234"),
        DiaryCoverModel(color: .DYGreen, title: "3번 다이어리", totalPage: 5, password: "1234"),
        DiaryCoverModel(color: .DYRed, title: "1번 다이어리", totalPage: 3, password: "1234"),
        DiaryCoverModel(color: .DYBlue, title: "2번 다이어리", totalPage: 2, password: "1234"),
        DiaryCoverModel(color: .DYGreen, title: "3번 다이어리", totalPage: 5, password: "1234")
    ]
    
    var deletedPageList: [DeletedPageCellModel] = [
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .cornell,
                             diaryName: "1번 다이어리",
                             deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .daily(date: Date()),
                             diaryName: "2번 다이어리",
                             deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .cornell,
                             diaryName: "3번 다이어리",
                             deletedDate: Date()),
        DeletedPageCellModel(thumbnailImageName: "image",
                             paperType: .daily(date: Date()),
                             diaryName: "4번 다이어리",
                             deletedDate: Date())
    ]
    
    

    var pageList: [DiaryInnerModel] = [
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
    
    var stickerList: [UIImage?] = [
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
        UIImage(named: "testSticker1"),
        UIImage(named: "testSticker2"),
        UIImage(named: "testSticker3"),
        UIImage(named: "testSticker4"),
    ]
   
    
    @discardableResult
    func create(diary: DiaryCoverModel) -> Observable<DiaryCoverModel> {
        diaryList.append(diary)
        diaryListSubject.onNext(diaryList)
        
        return Observable.just(diary)
    }

    func addDeletedPage(_ page: DeletedPageCellModel) {
        deletedPageList.append(page)
        pageListSubject.onNext(pageList)
    }

    func deleteDeletedPage(_ page: DeletedPageCellModel) {
        // TODO: - 임시로 다이어리 이름으로 비교하지만 추후에 데이터 연동 필요
        guard let index = deletedPageList.firstIndex(where: { $0.diaryName == page.diaryName }) else { return }
        pageList.remove(at: index)
        pageListSubject.onNext(pageList)
    }

    func deleteAllPage() {
        pageList = []
        pageListSubject.onNext(pageList)
    }
    
    func deleteAllDeletedPage() {
        deletedPageList = []
        deletedPageListSubject.onNext(deletedPageList)
    }
    
    func addDiary(_ diary: DiaryInnerModel) {
        pageList.append(diary)
        diaryListSubject.onNext(diaryList)
    }
    
    func reorderPage(from sourceIndex: Int, to destinationIndex: Int) {
        guard var paperList = pageList[safe: 0]?.paperList else { return }
        guard let source = paperList[safe: sourceIndex] else { return }
        
        if sourceIndex > destinationIndex {
            paperList.remove(at: sourceIndex)
            paperList.insert(source, at: destinationIndex)
        } else {
            paperList.insert(source, at: destinationIndex + 1)
            paperList.remove(at: sourceIndex)
        }
        pageList[0].paperList = paperList
        pageListSubject.onNext(pageList)
    }
    
    func addPage(_ model: DiaryInnerModel.PaperModel) {
        guard var paperList = pageList[safe: 0]?.paperList else { return }
        
        paperList.append(model)
        pageList[0].paperList = paperList
        pageListSubject.onNext(pageList)
    }

    func deleteDiary(_ diary: DiaryInnerModel) {
        guard let index = pageList.firstIndex(where: { $0.diaryID == diary.diaryID }) else { return }
        diaryList.remove(at: index)
        diaryListSubject.onNext(diaryList)
    }

    func deleteAllDiary() {
        diaryList = []
        diaryListSubject.onNext(diaryList)
    }
    
}
