//
//  SearchMediaViewController.swift
//  ImagesSearch
//
//  Created by j.jefrosinins on 14/03/2022.
//

import UIKit

class SearchMediaViewController: UIViewController {
    
    private var viewModel: SearchMediaViewModelProtocol
    private var contentView: SearchMediaViewProtocol
    
    init(contentView: SearchMediaViewProtocol, viewModel: SearchMediaViewModelProtocol) {
        self.contentView = contentView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHideOnTappedAroundRecognizer()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInterfaceOrientationMask(orientation: .all)
        viewModel.searchMedia()
    }
}

private extension SearchMediaViewController {
    func bind() {
        viewModel.onStateChanges = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .onUpdateData(let data):
                self.contentView.setupSearchTextfieldText(text: self.viewModel.mediaData?.text)
                self.contentView.setTotalMediaContentLabel(text: data.totalMediaString)
                self.contentView.setupTagsCollectionView(tags: data.tags)
                self.contentView.setupMediaCollectionsView(mediaContents: data.mediaContents)
                
            case .onErrorOccured(let error):
                self.showErrorAlert(
                    title: R.string.localizable.errorAlert_title(),
                    message: error.localizedDescription
                )
            case .onShowLoadingView(let isLoading):
                self.contentView.setLoadingView(isLoading: isLoading)
            }
        }
    }
}
