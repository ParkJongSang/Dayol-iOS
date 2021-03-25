//
//  StickerModalCollectionViewCell.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/26.
//

import UIKit

class StickerModalCollectionViewCell: UICollectionViewCell {
    static let identifier = "\(StickerModalCollectionViewCell.self)"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        contentView.addSubViewPinEdge(imageView)
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }

}
