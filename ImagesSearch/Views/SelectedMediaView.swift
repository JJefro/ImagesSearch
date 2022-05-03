//
//  SelectedMediaView.swift
//  ImagesSearch
//
//  Created by Jevgenijs Jefrosinins on 20/04/2022.
//

import UIKit

class SelectedMediaView: UIView {

    enum State {
        case onShareButtonTap(UIImage?)
        case onDownloadButtonTap(UIImage?)
        case onLicenseButtonTap
        case onZoomButtonTap(UIImage?)
    }

    var onStateChanges: ((State) -> Void)?

    // MARK: - Views Configurations
    private let contentView = UIView()
    private let scrollView = UIScrollView().apply {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let mediaImageView = UIImageView().apply {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let zoomButton = UIButton().apply {
        $0.isUserInteractionEnabled = true
        $0.setImage(R.image.plusMagnifyingglass()?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = R.color.shareButtonTintColor()
        $0.backgroundColor = R.color.shareButtonBG()
        $0.layer.cornerRadius = 3
    }

    private let contentVerticalStack = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 24
    }

    private let horizontalSubstack = UIStackView().apply {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 10
    }

    private let leftVerticalSubstack = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 15
        $0.alignment = .leading
    }

    private let licenseButton = UIButton().apply {
        let attrString = NSAttributedString(
            string: R.string.localizable.selectedMediaView_license_label(),
            attributes: [
                NSAttributedString.Key.font: R.font.openSansExtraBold(size: 14)!
            ])
        $0.setAttributedTitle(attrString, for: .normal)
        $0.setTitleColor(R.color.shareButtonTintColor(), for: .normal)
    }

    private let licenseDescriptionLabel = UILabel().apply {
        $0.font = R.font.openSansRegular(size: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = R.color.textColor()
        $0.text = R.string.localizable.selectedMediaView_license_description()
    }

    private let rightVerticalSubstack = UIStackView().apply {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 15
    }

    private let shareDescriptionLabel = UILabel().apply {
        $0.font = R.font.openSansRegular(size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = R.color.textColor()
        $0.text = R.string.localizable.selectedMediaView_share_description()
    }

    private let shareButton = ActionButton(type: .share)
    private let downloadButton = ActionButton(type: .download)
    private var placeHolderImage = UIImage()
    private let loadingView = LoadingView()

    private var mediaContent: (content: MediaContentModel, quality: MediaQuality)? {
        didSet {
            updateMedia()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addElements()
        configure()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupMedia(content: MediaContentModel, quality: MediaQuality) {
        self.mediaContent = (content, quality)
    }

    func updateMediaQuality(quality: MediaQuality) {
        self.mediaContent?.quality = quality
    }
}

// MARK: - Private Methods
private extension SelectedMediaView {
    @objc func shareButtonTapped(_ sender: UIButton) {
        onStateChanges?(.onShareButtonTap(mediaImageView.image))
    }

    @objc func downloadButtonTapped(_ sender: UIButton) {
        onStateChanges?(.onDownloadButtonTap(mediaImageView.image))
    }

    @objc func licenseButtonTapped(_ sender: UIButton) {
        onStateChanges?(.onLicenseButtonTap)
    }

    @objc func zoomButtonTapped(_ sender: UIButton) {
        onStateChanges?(.onZoomButtonTap(mediaImageView.image))
    }

     func updateMedia() {
        guard let mediaContent = mediaContent?.content else { return }
        loadingView.isHidden = false
        mediaImageView.sd_setImage(
            with: getRequiredImageURL(data: mediaContent),
            placeholderImage: placeHolderImage.sd_tintedImage(with: R.color.textColor()!)) { [weak self] (image, _, _, _) in
            guard let self = self else { return }
            if let image = image {
                self.mediaImageView.image = image
                self.loadingView.isHidden = true
            }
        }
    }

     func getRequiredImageURL(data: MediaContentModel) -> URL? {
        let imageURL: URL?
        guard let mediaQuality = mediaContent?.quality else { return nil }
        switch mediaQuality {
        case .small:
            imageURL = data.smallImageURL
        case .normal:
            imageURL = data.normalImageURL
        case .large:
            imageURL = data.largeImageURL
        }
        return imageURL
    }
}

// MARK: - Bind Elements
private extension SelectedMediaView {
    func bind() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
        licenseButton.addTarget(self, action: #selector(licenseButtonTapped(_:)), for: .touchUpInside)
        zoomButton.addTarget(self, action: #selector(zoomButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Add Views and Configurations
private extension SelectedMediaView {
    func configure() {
        backgroundColor = R.color.searchViewBG()
    }

    func addElements() {
        addScrollView()
        addContentView()
        addMediaImageView()
        addZoomButton()

        contentView.addSubview(contentVerticalStack)
        contentVerticalStack.snp.makeConstraints {
            $0.top.equalTo(mediaImageView.snp.bottom).inset(-18)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        contentVerticalStack.addArrangedSubviews(horizontalSubstack, downloadButton)
        downloadButton.snp.makeConstraints { $0.height.equalTo(52) }

        horizontalSubstack.addArrangedSubviews(leftVerticalSubstack, rightVerticalSubstack)
        leftVerticalSubstack.addArrangedSubviews(licenseButton, licenseDescriptionLabel)
        licenseButton.snp.makeConstraints { $0.height.equalTo(14) }

        rightVerticalSubstack.addArrangedSubviews(shareDescriptionLabel, shareButton)

        setPlaceholderImage()
        addLoadingView()
    }

    func addScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func addContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
    }

    func addMediaImageView() {
        contentView.addSubview(mediaImageView)
        mediaImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(mediaImageView.snp.width).dividedBy(1.8)
        }
    }

    func addZoomButton() {
        contentView.addSubview(zoomButton)
        zoomButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(mediaImageView).inset(16)
            $0.size.equalTo(32)
        }
    }

    func setPlaceholderImage() {
        let image = R.image.pixabayLogo()?.withRenderingMode(.alwaysTemplate)
        guard var image = image else { return }
        image = image.resize(to: mediaImageView.bounds.size)
        placeHolderImage = image
    }

    func addLoadingView() {
        mediaImageView.addSubview(loadingView)
        loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - Preview Provider
#if DEBUG
#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, *)
struct SelectedMediaViewRepresentation: UIViewRepresentable {
    func makeUIView(context: Context) -> SelectedMediaView {
        return SelectedMediaView()
    }

    func updateUIView(_ uiView: SelectedMediaView, context: Context) {}
}

@available(iOS 13, *)
struct SelectedMediaViewRepresentablePreview: PreviewProvider {
    static var previews: some View {
        Group {
            SelectedMediaViewRepresentation()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: .top)
        .preferredColorScheme(.dark)
    }
}
#endif
#endif
