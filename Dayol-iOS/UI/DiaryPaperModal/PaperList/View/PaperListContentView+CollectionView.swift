//
//  PaperListContentView+CollectionView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/02/02.
//

import RxSwift
import RxCocoa

private enum Design {
    static let collectionViewInset = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
    static let collectionViewSpacing: CGFloat = 28.0
}

extension PaperListContentView: UICollectionViewDataSource {

    var pepersCount: Int {
        return viewModel.papers.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pepersCount  + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == pepersCount  {
            // ' + ' 버튼이 있는 셀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaperListAddCell.identifier, for: indexPath)
            if let addCell = cell as? PaperListAddCell {
                addCell.addButton.rx.tap
                    .bind { [weak self] in
                        self?.didSelectAddCell.onNext(())
                    }
                    .disposed(by: disposeBag)
            }
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaperListCell.identifier, for: indexPath)

        if let paperListCell = cell as? PaperListCell {
            paperListCell.viewModel = viewModel.papers[safe: indexPath.row]
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        guard proposedIndexPath.row != pepersCount  else {
            return originalIndexPath
        }
        return proposedIndexPath
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row == pepersCount  ? false : true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }

}

extension PaperListContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem.onNext(indexPath.item)
    }
}

// MARK: - UICollectionView Reorder

extension PaperListContentView {
    @objc func didRecongizeLongPress(_ recog: UIGestureRecognizer) {
        guard viewModel.papers.count > 1 else { return }
        let point = recog.location(in: collectionView)
        switch recog.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: point) else {
                collectionView.cancelInteractiveMovement()
                return
            }
            isEditMode = true
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            guard isEditMode else { return }
            collectionView.updateInteractiveMovementTargetPosition(point)
        case .ended:
            guard isEditMode else { return }
            collectionView.endInteractiveMovement()
            isEditMode = false
        default:
            guard isEditMode else { return }
            collectionView.cancelInteractiveMovement()
            isEditMode = false
        }
    }
}
