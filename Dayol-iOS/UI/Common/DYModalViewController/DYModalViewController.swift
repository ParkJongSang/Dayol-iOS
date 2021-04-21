//
//  DYModalViewController.swift
//  Dayol-iOS
//
//  Created by 주성민 on 2021/01/05.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func presentCustomModal(_ viewController: DYModalViewController, completion: (() -> Void)? = nil) {
        present(viewController, animated: false, completion: completion)
    }
}

private enum Design {
    static let cornerRadius: CGFloat = 15.0
    static let headerAreaHeight: CGFloat = 56.0
    static let downButtonRightMargin: CGFloat = 20.0
    static let defaultBGColor = UIColor.white
    static let downButton = Assets.Image.Modal.down
}

class DYModalViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private var lastMoved: CGFloat = .greatestFiniteMagnitude

    // MARK: - DYModalConfiguration

    private let configure: DYModalConfiguration
    var containerViewHeight: CGFloat {
        let modalHeight = configure.modalStyle.contentHeight
        let bottomSafeAreaInset = view.safeAreaInsets.bottom
        let totalHeight = bottomSafeAreaInset + modalHeight
        if totalHeight > view.bounds.height {
            return view.bounds.height
        }

        return totalHeight
    }
    var dimColor: UIColor {
        configure.dimStyle.color
    }

    // MARK: - Default Private UI

    private var contentViewBottomConstraint = NSLayoutConstraint()
    private var contentViewHeightConstraint = NSLayoutConstraint()
    private let dimView = UIView()
    private let containerView = UIView()
    private let headerArea = UIView()
    private let contentArea = UIView()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    // MARK: - Custom  Public UI

    var titleView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            setTitleView()
        }
    }

    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            setContentView()
        }
    }

    // MARK: - Error for develop CustomModalViewController

    override var modalTransitionStyle: UIModalTransitionStyle {
        didSet {
            fatalError("do not change CustomModalViewController modalTransitionStyle")
        }
    }
    override var modalPresentationStyle: UIModalPresentationStyle {
        didSet {
            fatalError("do not change CustomModalViewController modalPresentationStyle")
        }
    }

    // MARK: - Init

    convenience init() {
        let defualtConfigure = DYModalConfiguration()
        self.init(configure: defualtConfigure)
    }

    convenience init(
        configure: DYModalConfiguration = DYModalConfiguration(),
        title: String,
        hasDownButton: Bool = false,
        dismissCompletion: (() -> Void)? = nil
    ) {
        self.init(configure: configure)
        setupTitleLabel(title)
        setupRightDownButton(completion: dismissCompletion)
    }

    init(configure: DYModalConfiguration) {
        self.configure = configure
        super.init(nibName: nil, bundle: nil)
        super.modalTransitionStyle = .crossDissolve
        super.modalPresentationStyle = .overCurrentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        setupGestureRecognizer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentContentView(animated: animated)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissContentView(animated: flag) {
            super.dismiss(animated: false, completion: completion)
        }
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        let previousHeight = contentViewBottomConstraint.constant

        if previousHeight != containerViewHeight {
            contentViewBottomConstraint.constant = containerViewHeight
            contentViewHeightConstraint.constant = containerViewHeight
        }
    }

}

// MARK: - Modal Animation

extension DYModalViewController {

    private func presentContentView(animated: Bool) {
        // 이 전까지 적용된 constraint를 선 반영 후 present 시작
        view.layoutIfNeeded()

        let animationBlock = { [weak self] in
            self?.dimView.alpha = 1
            self?.contentViewBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }

        guard animated else {
            animationBlock()
            return
        }

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut, .preferredFramesPerSecond60]
        ) {
            animationBlock()
        }
    }

    private func dismissContentView(animated: Bool, completion: (() -> Void)? = nil) {
        let animationBlock = { [weak self] in
            guard let self = self else { return }
            self.dimView.alpha = 0
            self.contentViewBottomConstraint.constant = self.containerViewHeight
            self.view.layoutIfNeeded()
        }

        guard animated else {
            animationBlock()
            completion?()
            return
        }

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut]
        ) {
            animationBlock()
        } completion: { _ in
            completion?()
        }
    }

}

// MARK: - Gesture

extension DYModalViewController {

    @objc func didTap(recog: UIGestureRecognizer) {
        dismiss(animated: true)
    }

    @objc func didPan(recog: UIPanGestureRecognizer) {
        switch recog.state {
        case .changed:
            panningContentView(recog)
        case .ended, .cancelled, .failed:
            finishPanning(recog)
        default: break
        }
    }

    private func panningContentView(_ recog: UIPanGestureRecognizer) {
        let location = recog.translation(in: containerView)
        if lastMoved < .greatestFiniteMagnitude {
            let bottomMargin = contentViewBottomConstraint.constant - (lastMoved - location.y)
            lastMoved = location.y
            updateContentViewBottomMargin(bottomMargin)
        } else {
            lastMoved = location.y
        }
    }

    private func finishPanning(_ recog: UIPanGestureRecognizer) {

        defer {
            lastMoved = .greatestFiniteMagnitude
        }

        let velocity = recog.velocity(in: recog.view)
        let threshold: CGFloat = 80

        let isFastVelocity = (velocity.y > threshold && contentViewBottomConstraint.constant > threshold)
        let isLowHeight = (velocity.y > 0 && contentViewBottomConstraint.constant > containerViewHeight / 3)
        let isEndPhase = recog.state == .ended
        
        if isEndPhase && (isFastVelocity || isLowHeight) {
            dismiss(animated: true)
            return
        }

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut, .preferredFramesPerSecond60]
        ) { [weak self] in
            self?.updateContentViewBottomMargin(0)
            self?.view.layoutIfNeeded()
        }
    }

    private func updateContentViewBottomMargin(_ bottomMargin: CGFloat) {
        let calcedMargin = bottomMargin < 0 ? 0 : bottomMargin
        contentViewBottomConstraint.constant = calcedMargin
    }

}

// MARK: - Set Content

extension DYModalViewController {

    private func setTitleView() {
        guard let titleView = titleView else { return }

        titleView.translatesAutoresizingMaskIntoConstraints = false
        headerArea.addSubview(titleView)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: headerArea.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: headerArea.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: headerArea.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: headerArea.bottomAnchor)
        ])
    }

    private func setContentView() {
        guard let contentView = contentView else { return }

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentArea.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentArea.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor)
        ])
    }

}

// MARK: - Setup

extension DYModalViewController {

    private func setupSubviews() {
        dimView.alpha = 0
        dimView.backgroundColor = dimColor
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)

        containerView.backgroundColor = Design.defaultBGColor
        containerView.layer.cornerRadius = Design.cornerRadius
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        headerArea.translatesAutoresizingMaskIntoConstraints = false
        contentArea.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerArea)
        containerView.addSubview(contentArea)
    }

    private func setupConstraints() {
        contentViewBottomConstraint = NSLayoutConstraint(item: containerView,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: containerViewHeight)
        contentViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerViewHeight)

        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: dimView.bottomAnchor, constant: -Design.cornerRadius),
            containerView.leadingAnchor.constraint(equalTo: dimView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: dimView.trailingAnchor),
            contentViewHeightConstraint,
            contentViewBottomConstraint,

            headerArea.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerArea.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerArea.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerArea.heightAnchor.constraint(equalToConstant: Design.headerAreaHeight),

            contentArea.topAnchor.constraint(equalTo: headerArea.bottomAnchor),
            contentArea.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentArea.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentArea.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTap(recog:)))
        dimView.addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(didPan(recog:)))
        containerView.addGestureRecognizer(panGestureRecognizer)
    }

}

// MARK: - Common Modal Type

extension DYModalViewController {

    private func setupTitleLabel(_ title: String) {
        let attributedString = NSAttributedString.build(text: title,
                                                        font: .boldSystemFont(ofSize: 18),
                                                        align: .center,
                                                        letterSpacing: -0.7,
                                                        foregroundColor: .gray900)
        titleLabel.attributedText = attributedString
        headerArea.addSubview(titleLabel)

        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .gray400
        headerArea.addSubview(lineView)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: headerArea.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerArea.centerXAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1.0),
            lineView.leadingAnchor.constraint(equalTo: headerArea.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: headerArea.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: headerArea.bottomAnchor)
        ])
    }

    private func setupRightDownButton(completion: (() -> Void)? = nil) {
        let downButton = UIButton()
        downButton.setImage(Design.downButton, for: .normal)
        downButton.translatesAutoresizingMaskIntoConstraints = false
        downButton.rx.tap
            .bind { [weak self] in
                completion?()
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        headerArea.addSubview(downButton)

        NSLayoutConstraint.activate([
            downButton.centerYAnchor.constraint(equalTo: headerArea.centerYAnchor),
            downButton.rightAnchor.constraint(equalTo: headerArea.rightAnchor,
                                              constant: -Design.downButtonRightMargin)
        ])
    }

}
