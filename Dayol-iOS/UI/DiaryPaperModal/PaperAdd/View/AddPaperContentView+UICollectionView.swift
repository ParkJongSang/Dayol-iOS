//
//  AddPaperContentView+UICollectionView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/13.
//

import UIKit

private enum Design {
    static let titleViewHeight: CGFloat = 65.0
    static let itemSpacing: CGFloat = 43.0
    static let lineSpacing: CGFloat = 29.0
    static let minimumSideInset: CGFloat = 36.0
    static let bottomSideInset: CGFloat = 31.0
}

extension AddPaperContentView {

    func reloadData() {
        collectionView.collectionViewLayout = getCollectionViewLayout(width: bounds.width)
        collectionView.reloadData()
        collectionView.scrollRectToVisible(
            CGRect(x: 0, y: 0, width: bounds.width, height: 1),
            animated: false
        )
    }

    func layoutCollectionView(width: CGFloat) {
        let sectionInset = calcCollectionViewInset(width: width)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = sectionInset
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func getCollectionViewLayout(width: CGFloat) -> UICollectionViewFlowLayout {
        typealias CellSize = AddPaperCell.Size
        let layout = UICollectionViewFlowLayout()
        let insets = calcCollectionViewInset(width: width)
        let itmeSize = currentTabType == .vertical ? CellSize.portrait : CellSize.landscape
        layout.sectionInset = insets
        layout.scrollDirection = .vertical
        layout.itemSize = itmeSize
        layout.minimumInteritemSpacing = Design.itemSpacing
        layout.minimumLineSpacing = Design.lineSpacing

        return layout
    }

    private func calcCollectionViewInset(width: CGFloat) -> UIEdgeInsets {
        typealias CellSize = AddPaperCell.Size
        let itmeSize = currentTabType == .vertical ? CellSize.portrait : CellSize.landscape

        let fourItemContentWidth = 4.0 * itmeSize.width + 3.0 * Design.itemSpacing
        let treeItemContentWidth = 3.0 * itmeSize.width + 2.0 * Design.itemSpacing
        let twoItemContentWidth = 2.0 * itmeSize.width + 1.0 * Design.itemSpacing

        let shouldHaveFourItemsMoreOrEqual = fourItemContentWidth + Design.minimumSideInset * 2 < width
        let shouldHaveThreeItemsMoreOrEqual = treeItemContentWidth + Design.minimumSideInset * 2 < width

        let currentContentWidth: CGFloat
        if shouldHaveFourItemsMoreOrEqual {
            currentContentWidth = fourItemContentWidth
        } else if shouldHaveThreeItemsMoreOrEqual {
            currentContentWidth = treeItemContentWidth
        } else {
            currentContentWidth = twoItemContentWidth
        }

        let totalSideWidth = width - (currentContentWidth)
        let sideInset = totalSideWidth / 2

        return UIEdgeInsets(top: 0,
                            left: sideInset,
                            bottom: Design.bottomSideInset,
                            right: sideInset)
    }

}

extension AddPaperContentView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.papers[currentTabType]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPaperCell.identifier, for: indexPath)

        guard
            let viewModel = viewModel.cellModel(indexPath, paperStyle: currentTabType),
            let diaryListCell = cell as? AddPaperCell
        else {
            return cell
        }
        diaryListCell.viewModel = viewModel

        return diaryListCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: AddPaperHeaderReusableView.className, for: indexPath)
            if let addPaperHeaderView = headerView as? AddPaperHeaderReusableView {
                addPaperHeaderView.updateTitleLabel(tabType: currentTabType)
            }
            return headerView
        default:
            // 헤더 뷰 밖에 사용하지 않음
            return UICollectionReusableView()
        }
    }

}

extension AddPaperContentView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellModel = viewModel.cellModel(indexPath, paperStyle: currentTabType) else { return }
        viewModel.selectCell(model: cellModel)
    }

}

extension AddPaperContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = Design.titleViewHeight
        return CGSize(width: width, height: height)
    }
}
