//
//  DiaryPaperViewController.swift
//  Dayol-iOS
//
//  Created by 박종상 on 2021/03/10.
//

import UIKit
import Combine

class DiaryPaperViewController: UIViewController {
    let index: Int
    let paper: PaperPresentView
    let scaleSubject = PassthroughSubject<CGFloat, Error>()
    
    private var cancellable = [AnyCancellable]()
    private var paperHeight = NSLayoutConstraint()
    
    private var scaleVariable: CGFloat {
        if isPadDevice {
            switch Orientation.currentState {
            case .portrait:
                switch paper.style {
                case .vertical:
                    return scrollView.frame.height / paper.style.size.height
                case .horizontal:
                    return scrollView.frame.width / paper.style.size.width
                }
            case .landscape:
                switch paper.style {
                case .vertical:
                    return scrollView.frame.height / paper.style.size.height
                case .horizontal:
                    return scrollView.frame.width / paper.style.size.width
                }
            default: return 0.0
            }
        } else {
            return scrollView.frame.width / paper.style.size.width
        }
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    init(index: Int, paper: PaperPresentView) {
        self.index = index
        self.paper = paper
        self.paper.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        initView()
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        scaleSubject.send(scaleVariable)
        super.viewDidLayoutSubviews()
    }
    
    private func initView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        view.addSubViewPinEdge(scrollView)
        scrollView.addSubViewPinEdge(paper)
        view.backgroundColor = UIColor(decimalRed: 246, green: 248, blue: 250)
        setupConstraint()
        
        combine()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            paper.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func combine() {
        let scaleCombine = scaleSubject.sink { error in
            // do Something
        } receiveValue: { [weak self] value in
            guard let self = self else { return }
            self.paper.scaleForFit = value
        }

        cancellable.append(scaleCombine)
    }
}

extension DiaryPaperViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return paper
    }
}
