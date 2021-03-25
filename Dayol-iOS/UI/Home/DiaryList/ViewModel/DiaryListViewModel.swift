//
//  DiaryViewModel.swift
//  Dayol-iOS
//
//  Created by Sungmin on 2020/12/21.
//

import RxSwift

class DiaryListViewModel {
    private let disposeBag = DisposeBag()
    enum DiaryListEvent {
        case fetch(isEmpty: Bool)
        case insert(index: Int)
        case delete(index: Int)
        case update(index: Int)
    }

    private(set) var diaryList: [DiaryCoverModel] = []
    var diaryEvent = ReplaySubject<DiaryListEvent>.createUnbounded()

    init() {
        bind()
    }
    
    private func bind() {
        // TODO: Login For Test. Please, remove this code after DB determined
        DYTestData.shared.diaryListSubject
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.diaryList = model
                let isEmpty = (self.diaryList.count == 0)
                self.diaryEvent.onNext(.fetch(isEmpty: isEmpty))
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Fetch

extension DiaryListViewModel {

    // TODO: - 실 데이터와 연동
    private func getMockData() {

    }

}

// MARK: - Diary List

extension DiaryListViewModel {

    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard let sourceModel = diaryList[safe: sourceIndex] else {
            // 로거 추가 필요
            debugPrint("[DiaryList] wrong move index")
            return
        }

        if sourceIndex > destinationIndex {
            diaryList.remove(at: sourceIndex)
            diaryList.insert(sourceModel, at: destinationIndex)
        } else {
            diaryList.insert(sourceModel, at: destinationIndex + 1)
            diaryList.remove(at: sourceIndex)
        }
    }

}
