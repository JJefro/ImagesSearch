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

    private let mediaCollectionView = MediaCollectionsView(builder: DetailsMediaContentCellSizeBuilder()).apply {
        $0.isHiddenShareButton = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        setupConstraints()
    }

    func setupMediaContents(mediaContents: [MediaContentModel], selected: MediaContentModel, quality: MediaQuality) {
        viewModel.setupMediaContents(contents: mediaContents, selectedMedia: selected, quality: quality)
    }

    func updateMediaQuality(quality: MediaQuality) {
        mediaCollectionView.mediaQuality = quality
        selectedMediaView.updateMediaQuality(quality: quality)
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
        addSubview(selectedMediaView)
        addSubview(relatedLabel)
        addSubview(mediaCollectionView)
        setupConstraints()
    }

    func setupConstraints() {
        setSelectedMediaViewConstraints()
        setRelatedLabelConstraints()
        setMediaCollectionsViewConstraints()
    }

    func configure() {
        backgroundColor = R.color.searchMediaViewBG()
    }

    func setSelectedMediaViewConstraints() {
        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft:
            selectedMediaView.snp.remakeConstraints {
                $0.leading.top.bottom.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(2)
            }
        default:
            selectedMediaView.snp.remakeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalToSuperview().dividedBy(1.7)
            }
        }
    }

    func setRelatedLabelConstraints() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
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

    func setMediaCollectionsViewConstraints() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
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
