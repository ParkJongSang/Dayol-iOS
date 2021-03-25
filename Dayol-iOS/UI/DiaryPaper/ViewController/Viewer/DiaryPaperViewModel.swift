//
//  DiaryPaperViewModel.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/25.
//

import Foundation

class DiaryPaperViewModel {
    
    // MARK: - Properties
    
    typealias PaperModel = DiaryInnerModel.PaperModel
    let paper: PaperModel
    let numberOfPapers: Int
    
    init(paper: PaperModel, numberOfPapers: Int) {
        self.paper = paper
        self.numberOfPapers = numberOfPapers
    }
}
