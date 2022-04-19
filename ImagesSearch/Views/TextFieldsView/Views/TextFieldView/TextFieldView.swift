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
    
    private let nibName = "TextFieldView"
    private var viewModel = TextFieldViewModel()
    private var textFieldStyle: TextFieldStyle?

    var onTextFieldReturnKeyTap: ((String?) -> Void)?
    
    init(style: TextFieldStyle) {
        super.init(frame: .zero)
        self.textFieldStyle = style
        
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        
        commonInit()
        makeFieldSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(textFieldBackgroundColor: UIColor?, viewBackgroundColor: UIColor?, font: UIFont?) {
        txtField.backgroundColor = textFieldBackgroundColor
        
        txtField.font = font
        txtFieldTitle.font = font
        inputLimitScore.font = font
    }
    
    private func commonInit() {
        txtField.delegate = self
        txtField.returnKeyType = .done
        txtField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

// MARK: - CustomTextField Settings
private extension TextFieldView {

    func makeFieldSettings() {
        guard let fieldStyle = textFieldStyle else { return }
        txtFieldTitle.text = fieldStyle.title
        txtField.placeholder = fieldStyle.placeholder
        inputLimitScore.isHidden = fieldStyle == .inputLimit ? false : true
        
        switch fieldStyle {
        case .noDigits:
            txtField.autocorrectionType = .no
            txtField.keyboardType = .alphabet
        case .onlyLetters:
            txtField.autocorrectionType = .no
        case .onlyNumbers:
            txtFieldTitle.isHidden = true
            txtField.autocorrectionType = .no
            txtField.keyboardType = .decimalPad
        case .inputLimit:
            inputLimitScore.text = String(viewModel.inputLimit)
        case .link:
            txtField.autocapitalizationType = .none
            txtField.keyboardType = .URL
        case .validationRules:
            txtField.isSecureTextEntry = true
            txtField.hasValidationRules = true
        case .searchField:
            txtFieldTitle.isHidden = true
            txtField.borderStyle = .none
            txtField.returnKeyType = .search
            txtField.setupImage(image: R.image.magnifyingglass(),
                                position: .left,
                                size: CGSize(width: 20,
                                             height: 20),
                                padding: 15,
                                tintColor: R.color.textFieldsColors.tfTextColor())
        default: break
        }
    }
}

// MARK: - TextFieldView Methods
private extension TextFieldView {
    func updateLimitedInputFieldColor() {
        if viewModel.inputLimit < 0 {
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

// MARK: - UITextField Delegate Methods
extension TextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isSelected = false
        onTextFieldReturnKeyTap?(textField.text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSelected = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSelected = false
        guard let text = textField.text else { return }
        if textFieldStyle == .link {
            if let url = viewModel.checkUrlValidation(input: text) {
                openLink(url)
            }
        }
    }
    
    @objc func textFieldEditingChanged(_ textField: CustomTextField) {
        guard let text = textField.text else { return }
        switch textFieldStyle {
        case .onlyNumbers:
            textField.text = viewModel.handleTextFieldInput(text: text)
        case .inputLimit:
            txtField.attributedText =  viewModel.changeTextColor(text: text)
        case .onlyCharacters:
            if !viewModel.isSeparatorAdded, text.count == viewModel.separatorIndex {
                txtField.text!.append(viewModel.separator)
            }
        default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {fatalError()}
        let textLength = text.count + string.count - range.length
        guard let textRange = Range(range, in: text) else { return false }
        let currentText = text.replacingCharacters(in: textRange, with: string)
        
        viewModel.replacementString = string
        
        switch textFieldStyle {
        case .noDigits:
            return viewModel.ignoreDigits(replacementString: string)
        case .onlyLetters:
            return viewModel.allowOnlyLetters(replacementString: string)
        case .onlyNumbers:
            return viewModel.allowOnlyNumbers(replacementString: string, text: text)
        case .inputLimit:
            inputLimitScore.text = viewModel.updateLimitInput(length: textLength)
            updateLimitedInputFieldColor()
        case .onlyCharacters:
            return viewModel.isAllowedChar(text: text + string, replacementString: string)
        case .link:
            if txtField.text!.isEmpty {
                txtField.text!.append("https://")
            }
        case .validationRules:
            txtField.isMinOfCharRuleDone =
            viewModel.hasRequiredQuantityOfCharacters(charCount: textLength)
            
            txtField.isMinOfDigitsRuleDone =
            viewModel.isContainsDigit(text: currentText)
            
            txtField.isMinOfLowercaseCharRuleDone =
            viewModel.isContainsLowercase(text: currentText)
            
            txtField.isMinOfUppercaseCharRuleDone =
            viewModel.isContainsUppercase(text: currentText)
        default: break
        }
        return true
    }
}
