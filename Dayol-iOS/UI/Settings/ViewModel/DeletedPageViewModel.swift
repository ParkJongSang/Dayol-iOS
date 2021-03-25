//
//  DeletedPageViewModel.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/14.
//

import RxSwift

class DeletedPageViewModel {

    enum DeletedPageEvent {
        case fetch(isEmpty: Bool)
        case deleteAll
    }

    private let disposeBag = DisposeBag()
    private(set) var pageList: [DeletedPageCellModel] = []
    let deletedPageEvent = ReplaySubject<DeletedPageEvent>.createUnbounded()

    init() {
        bindData()
    }

    func delete(at index: Int) {

    }

    func deleteAll() {
        DYTestData.shared.deleteAllDeletedPage()
        deletedPageEvent.onNext(.deleteAll)
    }

    func restore(at index: Int) {

    }

}

// MARK: - private extension

private extension DeletedPageViewModel {

    func bindData() {
        DYTestData.shared.deletedPageListSubject
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.pageList = model
                self.deletedPageEvent.onNext(.fetch(isEmpty: model.isEmpty))
            })
            .disposed(by: disposeBag)
    }

}
