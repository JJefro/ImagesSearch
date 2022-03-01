//
//  TextFieldsModel.swift
//  textFields!
//
//  Created by Jevgenijs Jefrosinins on 22/09/2021.
//

import UIKit

class TextFieldModel {

    // MARK: - noDigitsField
    func ignoreDigits(replacementString string: String) -> Bool {
        return string.isEmpty || !string.contains(where: { $0.isNumber })
    }

    // MARK: - onlyLettersField
    func allowOnlyLetters(replacementString string: String) -> Bool {
        return string.isEmpty || string.contains(where: { $0.isLetter })
    }

    // MARK: - onlyNumbersField
    var replacementString = String()

    func allowOnlyNumbers(replacementString string: String, text: String) -> Bool {
        if string.contains(where: { $0.isPunctuation }) {

        }
        if text.contains(".") {
            return string.isEmpty || string.contains(where: { $0.isNumber })
        }
        return string.isEmpty || string.contains(where: { $0.isNumber }) || string.contains(where: { $0 == "." }) || string.contains(where: { $0 == "," })
    }

    func handleTextFieldInput(text: String) -> String {
        var currentText = text
        
        if replacementString.contains(where: { $0.isPunctuation }) {
            currentText.removeAll(where: { $0.isPunctuation })
            currentText.append(".")
        }

        let startIndex = currentText.startIndex
        if currentText.first == "." {
            currentText.insert("0", at: startIndex)
        }
        if currentText.first == "0", !currentText.contains("."), !replacementString.isEmpty {
            currentText.insert(".", at: currentText.index(after: startIndex))
        }
        return currentText
    }

    // MARK: - inputLimitField
    var inputLimit = 10

    func updateLimitInput(length: Int) -> Int {
        inputLimit = 10 - length
        return inputLimit
    }

    func changeTextColor(text: String) -> NSMutableAttributedString {
        let rangeOfExtraText = NSRange(location: 10, length: text.utf16.count - 10)
        let string = NSAttributedString(string: text)
        let attributedString = NSMutableAttributedString(attributedString: string)
        if inputLimit < 0 {
            attributedString.addAttribute(.foregroundColor, value: R.color.textFieldsColors.tfRed()!, range: rangeOfExtraText)
            attributedString.addAttribute(.foregroundColor, value: R.color.textFieldsColors.tfTextColor()!, range: NSRange(location: 0, length: 10))
        }
        return attributedString
    }

    // MARK: - onlyCharactersField
    let separator = "-"
    let separatorIndex = 5
    var isSeparatorAdded = false
    private let maxOfCharacters = 11

    func isAllowedChar(text: String, replacementString string: String) -> Bool {
        var regex = String()
        let format = "SELF MATCHES %@"
        if text.count <= separatorIndex {
            regex = "[a-zA-Z]{1,5}"
            isSeparatorAdded = false
        } else if text.count <= maxOfCharacters {
            regex = "[a-zA-Z]{5}-[0-9]{0,5}"
            isSeparatorAdded = true
        }
        return string.isEmpty || NSPredicate(format: format, regex).evaluate(with: text)
    }

    // MARK: - linkField
    func checkUrlValidation(input: String) -> String? {
        var url = String()
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let detector = dataDetector {
            let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
            for match in matches {
                guard let range = Range(match.range, in: input) else {continue}
                url = String(input[range])
            }
            return url
        }
        return nil
    }

    // MARK: - validationRulesField
    private let requiredQuantity = 8

    func hasRequiredQuantityOfCharacters(charCount: Int) -> Bool {
        return charCount >= requiredQuantity
    }

    func isContainsDigit(text: String) -> Bool {
        return text.contains(where: { $0.isNumber })
    }

    func isContainsLowercase(text: String) -> Bool {
        return text.contains(where: { $0.isLowercase })
    }

    func isContainsUppercase(text: String) -> Bool {
        return text.contains(where: { $0.isUppercase })
    }
}
