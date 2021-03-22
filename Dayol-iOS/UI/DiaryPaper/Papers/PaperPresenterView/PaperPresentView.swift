//
//  PaperPresentView.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/26.
//

import UIKit
import Combine

class PaperPresentView: UIView {
    
    // MARK: - Properties
    
    typealias PaperModel = DiaryInnerModel.PaperModel
    private let paper: PaperModel
    private let numberOfPapers: Int
   
    var scaleForFit: CGFloat = 0.0 {
        didSet {
            transform = CGAffineTransform(scaleX: scaleForFit, y: scaleForFit)
        }
    }
    
    // MARK: - UI
    
     let paperContentView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0.0
        
        return stackView
    }()
    
    private let drawingContentView: DrawingContentView = {
        let view = DrawingContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let stickerContentView: StickerContentView = {
        let view = StickerContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    init(paper: PaperModel, count: Int = 1) {
        self.paper = paper
        self.numberOfPapers = count
        super.init(frame: .zero)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init
    
    private func initView() {
        setupPaperBorder()
        
        addSubview(paperContentView)
        addSubViewPinEdge(drawingContentView)
        addSubViewPinEdge(stickerContentView)
        
        setupPapers()
        
        setupConstraint()
    }
    
    private func setupConstraint(){
        NSLayoutConstraint.activate([
            paperContentView.topAnchor.constraint(equalTo: topAnchor),
            paperContentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            paperContentView.widthAnchor.constraint(equalToConstant: style.size.width),
            paperContentView.heightAnchor.constraint(equalTo: heightAnchor),
            
            paperContentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            paperContentView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupPapers() {
        for _ in 0..<numberOfPapers {
            let paperView = PaperProvider.create(type: paper.paperType, style: paper.paperStyle)
            paperContentView.addArrangedSubview(paperView)
        }
    }
    
    private func setupPaperBorder() {
        layer.borderWidth = 1
        layer.borderColor = CommonPaperDesign.borderColor.cgColor
    }
}

extension PaperPresentView {
    var style: PaperStyle { paper.paperStyle }
    var height: CGFloat { paper.paperStyle.size.height * CGFloat(numberOfPapers) }
    
    func addPage() {
        let paperView = PaperProvider.create(type: paper.paperType, style: paper.paperStyle)
        paperContentView.addArrangedSubview(paperView)
    }
}
