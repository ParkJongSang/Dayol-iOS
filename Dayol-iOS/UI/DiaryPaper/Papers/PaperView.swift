//
//  PaperView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/21.
//

import UIKit
import RxSwift

protocol PaperCreatable {
    var orientation: Paper.PaperOrientation { get }
    var collectionView: UICollectionView { get set }
}

class PaperView: UIView, PaperCreatable {
    var collectionView: UICollectionView
    let orientation: Paper.PaperOrientation

    init(orientation: Paper.PaperOrientation) {
        self.orientation = orientation
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
        
        super.init(frame: .zero)
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
