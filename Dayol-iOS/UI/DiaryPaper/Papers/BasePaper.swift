//
//  BasePaper.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/21.
//

import RxSwift

class BasePaper: UIView {  
    var viewModel: PaperViewModel
    var paperStyle: PaperStyle
    
    public let sizeDefinitionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    init(viewModel: PaperViewModel, paperStyle: PaperStyle) {
        self.viewModel = viewModel
        self.paperStyle = paperStyle
        super.init(frame: .zero)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initView() {
        addSubViewPinEdge(sizeDefinitionView)
        NSLayoutConstraint.activate([
            sizeDefinitionView.heightAnchor.constraint(equalToConstant: paperStyle.size.height)
        ])
    }
}
