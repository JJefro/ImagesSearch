//
//  SettingsView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 11/04/2022.
//

import UIKit
import SnapKit

class SettingsView: UIView {

    var onUpdateSettingsValue: ((MediaCategory?, MediaQuality?, MediaSource?) -> Void)?

    private let settingsViewWidth: CGFloat = 250
    private let animationDuration: CGFloat = 1

    // MARK: - Views Configurations
    private let settingsView = UIView().apply {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = R.color.searchMediaViewBG()
    }

    private let titleLabel = UILabel().apply {
        $0.text = R.string.localizable.settingsView_title()
        $0.font = R.font.openSansSemiBold(size: 17)
        $0.textColor = R.color.textColor()
    }

    private let separatorView = UIView().apply {
        $0.backgroundColor = R.color.searchViewBorderColor()
    }
    
    private let blurView = BlurView()
    private let settingsTableView = SettingsTableView()
    private var viewModel: SettingsViewModelProtocol

    var isShowSettingsView = false {
        didSet {
            animateSettingsView()
            if !isShowSettingsView {
                onUpdateSettingsValue?(
                    viewModel.currentMediaCategory,
                    viewModel.currentMediaQuality,
                    viewModel.currentMediaSource
                )
                viewModel.removeAllSettingsValues()
            }
        }
    }

    override init(frame: CGRect) {
        viewModel = SettingsViewModel()
        super.init(frame: frame)
        addViews()
        animateSettingsView()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSettings(data: [SettingsModel]) {
        settingsTableView.settingsObjects = data
    }
}

// MARK: - Private Methods
private extension SettingsView {
    func animateSettingsView() {
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: []) { [weak self] in
            guard let self = self else { return }
            if self.isShowSettingsView {
                self.blurView.isHidden = false
                self.isHidden = false
                self.settingsView.transform = CGAffineTransform(
                    translationX: -(self.settingsViewWidth * 2), y: 0
                )
            } else {
                self.blurView.isHidden = true
                self.settingsView.transform = .identity
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
            guard let self = self else { return }
            if !self.isShowSettingsView, self.blurView.isHidden == true {
                self.isHidden = true
            }
        }
    }

    @objc func handleSettingsViewRightSwipe(_ sender: UISwipeGestureRecognizer) {
        isShowSettingsView = false
    }
}

// MARK: - Bind Elements
private extension SettingsView {
    func bind() {
        settingsTableView.onUpdateSettingsValue = { [weak self] value in
            self?.viewModel.updateWithSettings(value: value)
        }
        addRightSwipeGesture(view: settingsView)
    }

    func addRightSwipeGesture(view: UIView) {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSettingsViewRightSwipe(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
}

// MARK: - Add Views and Configurations
private extension SettingsView {
    func addViews() {
        addBlurView()
        addSettingsView()
        addTitleLabel()
        addSeparatorView()
        addSettingsTableView()
    }

    func addBlurView() {
        addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func addSettingsView() {
        addSubview(settingsView)
        settingsView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(settingsViewWidth)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(settingsViewWidth * 2)
            $0.height.equalTo(snp.height)
        }
    }

    func addTitleLabel() {
        settingsView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(settingsView.snp.top).inset(10)
            $0.centerX.equalTo(settingsView.snp.centerX)
        }
    }

    func addSeparatorView() {
        settingsView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalTo(settingsView).inset(20)
            $0.height.equalTo(1)
        }
    }

    func addSettingsTableView() {
        settingsView.addSubview(settingsTableView)
        settingsTableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.equalTo(settingsView).inset(10)
            $0.bottom.equalTo(settingsView.snp.bottom)
        }
    }
}
