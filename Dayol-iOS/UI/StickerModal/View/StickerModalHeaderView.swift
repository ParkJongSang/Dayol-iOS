//
//  StickerModalHeaderView.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import UIKit
import Combine

private enum Design {
    static let cellSize: CGSize = CGSize(width: 44, height: 40)
    static let cellSpace: CGFloat = 14.0
    static let buttonSize: CGSize = CGSize(width: 55, height: 55)
    static let collectionViewInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    static let buttonImage = UIImage(named: "downwardArrowButton")
}

class StickerModalHeaderView: UIView {
    // MARK: - Properties
    
    let didTappedCloseButton = PassthroughSubject<Void, Error>()
    
    // MARK: - UI Components
    
    private var models: [UIImage?]? = DYTestData.shared.stickerList
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Design.cellSpace
        layout.itemSize = Design.cellSize
        layout.sectionInset = Design.collectionViewInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemPink
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Design.buttonImage, for: .normal)
        
        return button
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
        addSubview(collectionView)
        addSubview(closeButton)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StickerModalHeaderCell.self, forCellWithReuseIdentifier: StickerModalHeaderCell.identifier)
    
        closeButton.addTarget(self, action: #selector(tappedCloseButton(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: Design.buttonSize.width),
            closeButton.topAnchor.constraint(equalTo: topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    private func tappedCloseButton(_ sender: Any) {
        didTappedCloseButton.send(())
    }
}

extension StickerModalHeaderView {
    var stickers: [UIImage?]? {
        get {
            return models
        }
        set {
            models = newValue
        }
    }
}

extension StickerModalHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension StickerModalHeaderView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let itemCount = models?.count else { return 0 }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerModalHeaderCell.identifier, for: indexPath) as? StickerModalHeaderCell else { return UICollectionViewCell() }
        guard let stickerImage = models?[safe: indexPath.item] else { return UICollectionViewCell() }
        cell.configure(image: stickerImage)
        
        return cell
    }
}
