//
//  DetailsView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 20/04/2022.
//

import UIKit

class DetailsView: UIView {

    var onSelectedMediaViewStateChanges: ((SelectedMediaView.State) -> Void)?

    // MARK: - Views Configurations
    private let viewModel = DetailsViewModel()
    private let selectedMediaView = SelectedMediaView()
    private let relatedLabel = UILabel().apply {
        $0.font = R.font.openSansSemiBold(size: 18)
        $0.textAlignment = .left
        $0.textColor = R.color.textColor()
        $0.text = R.string.localizable.searchMediaView_relatedLabel_text()
    }

    private let mediaCollectionView = MediaCollectionsView().apply {
        $0.isHiddenShareButton = true
        $0.setupCellsCount(
            onIphone: CellSettings(
                landscapeOrientation: CellSettings.CellsCount(
                    countPerScreen: 3, countInRow: 2),
                portraitOrientation: CellSettings.CellsCount(
                    countPerScreen: 2, countInRow: 2)),

            onIpad: CellSettings(
                landscapeOrientation: CellSettings.CellsCount(
                    countPerScreen: 4, countInRow: 3),
                portraitOrientation: CellSettings.CellsCount(
                    countPerScreen: 2, countInRow: 3))
        )
    }

    init() {
        super.init(frame: .zero)
        addViews()
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        addViews()
    }

    func setupMediaContents(mediaContents: [MediaContentModel], selected: MediaContentModel, quality: MediaQuality) {
        viewModel.setupMediaContents(contents: mediaContents, selectedMedia: selected, quality: quality)
    }

    func updateMediaQuality(quality: MediaQuality) {
        mediaCollectionView.mediaQuality = quality
        selectedMediaView.updateMediaQuality(quality: quality)
    }

    func showDetailsView(isShown: Bool) {
        UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve]) { [weak self] in
            self?.isHidden = !isShown
        }
    }
}

// MARK: - Bind Elements
private extension DetailsView {
    func bind() {
        bindSelectedMediaView()
        bindViewModel()
        bindMediaCollectionsView()
    }

    func bindSelectedMediaView() {
        selectedMediaView.onStateChanges = { [weak self] state in
            self?.onSelectedMediaViewStateChanges?(state)
        }
    }

    func bindViewModel() {
        viewModel.onStateChanges = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .onUpdateMediaContents(let mediaContents, let selectedMedia, let quality):
                self.mediaCollectionView.mediaContents = mediaContents
                self.mediaCollectionView.mediaQuality = quality
                self.selectedMediaView.setupMedia(content: selectedMedia, quality: quality)
            }
        }
    }

    func bindMediaCollectionsView() {
        mediaCollectionView.onCellTap = { [weak self] (mediaContents, selectedMedia, quality) in
            self?.setupMediaContents(
                mediaContents: mediaContents,
                selected: selectedMedia,
                quality: quality)
        }
    }
}

// MARK: - Add Views and Configurations
private extension DetailsView {
    func addViews() {
        addSelectedMediaView()
        addRelatedLabel()
        addMediaCollectionsView()
    }

    func configure() {
        backgroundColor = R.color.searchMediaViewBG()
    }

    func addSelectedMediaView() {
        if !subviews.contains(selectedMediaView) {
            addSubview(selectedMediaView)
        }
        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft:
            selectedMediaView.snp.remakeConstraints {
                $0.leading.top.bottom.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(2)
            }
        default:
            selectedMediaView.snp.remakeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalToSuperview().dividedBy(1.8)
            }
        }
    }

    func addRelatedLabel() {
        if !subviews.contains(relatedLabel) {
            addSubview(relatedLabel)
        }
        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft:
            relatedLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalTo(selectedMediaView.snp.trailing).inset(-16)
            }
        default:
            relatedLabel.snp.remakeConstraints {
                $0.top.equalTo(selectedMediaView.snp.bottom).inset(-16)
                $0.leading.equalToSuperview().inset(16)
            }
        }
    }

    func addMediaCollectionsView() {
        if !subviews.contains(mediaCollectionView) {
            addSubview(mediaCollectionView)
        }
        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft:
            mediaCollectionView.snp.remakeConstraints {
                $0.top.equalTo(relatedLabel.snp.bottom)
                $0.leading.equalTo(selectedMediaView.snp.trailing).inset(-16)
                $0.trailing.equalTo(safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
            }
        default:
            mediaCollectionView.snp.remakeConstraints {
                $0.top.equalTo(relatedLabel.snp.bottom)
                $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
                $0.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - Preview Provider
#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct DetailsViewRepresentation: UIViewRepresentable {
    func makeUIView(context: Context) -> DetailsView {
        return DetailsView()
    }

    func updateUIView(_ uiView: DetailsView, context: Context) {}
}

@available(iOS 13, *)
struct DetailsViewRepresentablePreview: PreviewProvider {
    static var previews: some View {
        Group {
            SelectedMediaViewRepresentation()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
#endif
