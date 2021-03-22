//
//  WeeklyCalendarView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/02/01.
//

import UIKit
import RxSwift
import RxCocoa

private enum Design {
    static func headerHeight(style: PaperStyle) -> CGFloat {
        switch style {
        case .vertical: return 125
        case .horizontal: return 81
        }
    }
}

class WeeklyCalendarView: BasePaper {
    private var dayModel: [WeeklyCalendarDataModel]?
    private let disposeBag = DisposeBag()
    
    private let headerView: MonthlyCalendarHeaderView = {
        let header = MonthlyCalendarHeaderView(month: .january)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        return header
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionView()
    }
    
    override func initView() {
        super.initView()
        setupCollectionView()
        
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
    
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.collectionViewLayout = layout
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeeklyCalendarViewCell.self, forCellWithReuseIdentifier: WeeklyCalendarViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    
    
    private func bind() {
        guard let viewModel = self.viewModel as? WeeklyCalendarViewModel else { return }
        
        viewModel.dateModel(date: Date())
            .subscribe(onNext: {[weak self] models in
                guard let month = models[safe: 1]?.month else { return }
                self?.headerView.month = month
                self?.dayModel = models
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCollectionView() {
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - CollectionView Delegate

extension WeeklyCalendarView: UICollectionViewDelegate {
    
}

// MARK: - CollectionView DataSource

extension WeeklyCalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = dayModel?[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCalendarViewCell.identifier, for: indexPath) as? WeeklyCalendarViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(model: model)
        if model.isFirst {
            cell.setFirstCell(true)
        }
        
        return cell
    }
}

// MARK: - CollectionView FlowLayout

extension WeeklyCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 4)
    }
}
