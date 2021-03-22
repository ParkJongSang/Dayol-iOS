//
//  MonthlyCalendarView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/01/25.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static func headerHeight(style: PaperStyle) -> CGFloat {
        switch style {
        case .vertical:
            return 125
        case .horizontal:
            return 81
        }
    }
}

class MonthlyCalendarView: BasePaper {
    private var containerViewLeft = NSLayoutConstraint()
    private var containerViewRight = NSLayoutConstraint()
    private let disposeBag = DisposeBag()
    
    private let headerView: MonthlyCalendarHeaderView = {
        let header = MonthlyCalendarHeaderView(month: .january)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        return header
    }()
    
    private let collectionView: MonthlyCalendarCollectionView = {
        let collectionView = MonthlyCalendarCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func initView() {
        super.initView()
        
        sizeDefinitionView.addSubview(headerView)
        sizeDefinitionView.addSubview(collectionView)
        setupConstraints()
        
        bind()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: sizeDefinitionView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: sizeDefinitionView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: sizeDefinitionView.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Design.headerHeight(style: paperStyle)),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: sizeDefinitionView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: sizeDefinitionView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: sizeDefinitionView.bottomAnchor)
        ])
    }
    
    private func bind() {
        guard let viewModel = self.viewModel as? MonthlyCalendarViewModel else { return }
        viewModel.dateModel(date: Date())
            .subscribe(onNext: { [weak self] dateModel in
                guard let self = self else { return }
                let _ = dateModel.month
                let days = dateModel.days
                self.collectionView.days = days
            })
            .disposed(by: disposeBag)
    }
}
