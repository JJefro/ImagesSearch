//
//  ResuableCustomTextFieldView.swift
//  textFields!
//
//  Created by Jevgenijs Jefrosinins on 20/09/2021.
//

import UIKit
import SnapKit
import SafariServices

class TextFieldView: UIView {

    @IBOutlet weak var txtFieldTitle: UILabel!
    @IBOutlet weak var inputLimitScore: UILabel!
    @IBOutlet weak var txtField: CustomTextField!

    let nibName = "TextFieldView"
    var contentView: UIView?
    var model = TextFieldModel()

    var fieldSettings: TextFieldsSettings = .onlyNumbers {
        didSet {
            makeFieldSettings()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        txtField.delegate = self
        txtField.returnKeyType = .done
        txtField.addTarget(self, action: #selector(TextFieldView.textFieldEditingChanged(_:)), for: .editingChanged)
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    private func makeFieldSettings() {
        switch fieldSettings {
        case .noDigits:
            txtFieldTitle.text = fieldSettings.title
            txtField.placeholder = fieldSettings.placeholder
            txtField.autocorrectionType = .no
            txtField.keyboardType = .alphabet
            inputLimitScore.isHidden = true
        case .onlyLetters:
            txtFieldTitle.text = fieldSettings.title
            txtField.placeholder = fieldSettings.placeholder
            txtField.autocorrectionType = .no
            inputLimitScore.isHidden = true
        case .onlyNumbers:
            txtFieldTitle.isHidden = true
            txtFieldTitle.text = fieldSettings.title
            txtField.placeholder = fieldSettings.placeholder
            txtField.autocorrectionType = .no
            txtField.keyboardType = .decimalPad
            inputLimitScore.isHidden = true
        case .inputLimit:
            txtFieldTitle.text = fieldSettings.title
            txtField.placeholder = fieldSettings.placeholder
            inputLimitScore.text = String(model.inputLimit)
        case .onlyCharacters:
            txtFieldTitle.text = fieldSettings.title
            txtField.placeholder = fieldSettings.placeholder
            inputLimitScore.isHidden = true
        case .link:
            txtFieldTitle.text = fieldSettings.title
            txtField.placeholder = fieldSettings.placeholder
            txtField.keyboardType = .URL
            inputLimitScore.isHidden = true
        case .validationRules:
            txtFieldTitle.text = fieldSettings.title
            txtField.placeholder = fieldSettings.placeholder
            inputLimitScore.isHidden = true
            txtField.isSecureTextEntry = true
            txtField.hasValidationRules = true
        case .searchField:
            txtFieldTitle.isHidden = true
            inputLimitScore.isHidden = true
            txtField.placeholder = fieldSettings.placeholder
        }
    }

    func updateLimitedInputFieldColor() {
        if model.inputLimit < 0 {
            txtField.isLimited = true
            inputLimitScore.textColor = R.color.textFieldsColors.tfRed()
        } else {
            txtField.isLimited = false
            inputLimitScore.textColor = R.color.textFieldsColors.tfTextColor()
            txtField.textColor = R.color.textFieldsColors.tfTextColor()
        }
    }
    
    func openLink(_ stringURL: String) {
        guard let url = URL(string: stringURL) else { return }
        let safariVC = SFSafariViewController(url: url)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let viewController = appDelegate.window?.rootViewController else { fatalError("Unable to connect to rootViewController") }

        viewController.present(safariVC, animated: true, completion: nil)
    }
}
