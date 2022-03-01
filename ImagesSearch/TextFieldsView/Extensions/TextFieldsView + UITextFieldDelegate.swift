//
//  TextFieldsView + UITextFieldDelegate.swift
//  CurrencyConverter
//
//  Created by Jevgenijs Jefrosinins on 30/11/2021.
//

import UIKit

extension TextFieldView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isSelected = false
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSelected = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isSelected = false
        guard let text = textField.text else {return}
        if fieldSettings == .link {
            if let url = model.checkUrlValidation(input: text) {
                openLink(url)
            }
        }
    }

    @objc func textFieldEditingChanged(_ textField: CustomTextField) {
        guard let text = textField.text else {return}
        switch fieldSettings {
        case .onlyNumbers:
            textField.text = model.handleTextFieldInput(text: text)
        case .inputLimit:
            txtField.attributedText =  model.changeTextColor(text: text)
        case .onlyCharacters:
            if !model.isSeparatorAdded, text.count == model.separatorIndex {
                txtField.text!.append(model.separator)
            }
        default: break
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {fatalError()}
        let textLength = text.count + string.count - range.length
        guard let textRange = Range(range, in: text) else {return false}
        let currentText = text.replacingCharacters(in: textRange, with: string)

        model.replacementString = string

        switch fieldSettings {
        case .noDigits:
            return model.ignoreDigits(replacementString: string)
        case .onlyLetters:
            return model.allowOnlyLetters(replacementString: string)
        case .onlyNumbers:
            return model.allowOnlyNumbers(replacementString: string, text: text)
        case .inputLimit:
            inputLimitScore.text = String(model.updateLimitInput(length: textLength))
            updateLimitedInputFieldColor()
        case .onlyCharacters:
            return model.isAllowedChar(text: text + string, replacementString: string)
        case .link:
            txtField.autocapitalizationType = .none
            if txtField.text!.isEmpty {
                txtField.text!.append("https://")
            }
        case .validationRules:
            txtField.isMinOfCharRuleDone =
            model.hasRequiredQuantityOfCharacters(charCount: textLength)

            txtField.isMinOfDigitsRuleDone =
            model.isContainsDigit(text: currentText)

            txtField.isMinOfLowercaseCharRuleDone =
            model.isContainsLowercase(text: currentText)

            txtField.isMinOfUppercaseCharRuleDone =
            model.isContainsUppercase(text: currentText)
        }
        return true
    }
}
