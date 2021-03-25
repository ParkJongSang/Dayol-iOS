//
//  StickerModalCollectionView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit

private enum Design {
    static let cellSize: CGSize = CGSize(width: 50, height: 50)
    static let cellSpace: CGFloat = 20.0
    static let collectionViewInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 22.5, bottom: 20, right: 22.5)
}

class StickerModalCollectionView: UIView {
    // MARK: - UI Components
    
    private var models: [UIImage?]? = DYTestData.shared.stickerList
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Design.cellSpace
        layout.itemSize = Design.cellSize
        layout.sectionInset = Design.collectionViewInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .brown
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initView() {
        addSubViewPinEdge(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StickerModalCollectionViewCell.self, forCellWithReuseIdentifier: StickerModalCollectionViewCell.identifier)
    }
}

extension StickerModalCollectionView {
    var representiveStickers: [UIImage?]? {
        get {
            return models
        }
        set {
            models = newValue
        }
    }
}

extension StickerModalCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension StickerModalCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let itemCount = models?.count else { return 0 }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerModalCollectionViewCell.identifier, for: indexPath) as? StickerModalCollectionViewCell else { return UICollectionViewCell() }
        guard let stickerImage = models?[safe: indexPath.item] else { return UICollectionViewCell() }
        cell.configure(image: stickerImage)
        
        return cell
    }
}
