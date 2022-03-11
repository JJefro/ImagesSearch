//
//  TextFieldsTests.swift
//  TextFieldsTests
//
//  Created by Jevgenijs Jefrosinins on 06/01/2022.
//

import XCTest
@testable import ImagesSearch

class TextFieldsTests: XCTestCase {

    var mut: TextFieldViewModel!

    override func setUpWithError() throws {
        mut = TextFieldViewModel()
    }

    override func tearDownWithError() throws {
        mut = nil
    }

    // MARK: - NoDigitsField
    func testNoDigitsField_IgnoreDigits() throws {
        let inputWithoutDigits = "asdfg)=!"
        let inputWithDigits = "123ADf3"
        XCTAssertTrue(mut.ignoreDigits(replacementString: inputWithoutDigits))
        XCTAssertFalse(mut.ignoreDigits(replacementString: inputWithDigits))
    }

    // MARK: - OnlyLettersField
    func testOnlyLettersField() throws {
        let forbiddenCharacter1 = "1"
        let forbiddenCharacter2 = "!"
        let allowedCharacter = "a"

        XCTAssertTrue(mut.allowOnlyLetters(replacementString: allowedCharacter))
        XCTAssertFalse(mut.allowOnlyLetters(replacementString: forbiddenCharacter1))
        XCTAssertFalse(mut.allowOnlyLetters(replacementString: forbiddenCharacter2))
    }

    // MARK: - OnlyNumbersField
    func testOnlyNumbersField_allowOnlyNumbersFunction() throws {
        let numberWithoutPoint = "123"
        let numberWithPoint = "12.543"

        let allowedCharacter = "1"

        let forbiddenCharacter1 = "#"
        let forbiddenCharacter2 = "A"

        XCTAssertTrue(mut.allowOnlyNumbers(replacementString: ".", text: numberWithoutPoint))
        XCTAssertFalse(mut.allowOnlyNumbers(replacementString: ".", text: numberWithPoint))

        XCTAssertFalse(mut.allowOnlyNumbers(replacementString: forbiddenCharacter1, text: numberWithPoint))
        XCTAssertFalse(mut.allowOnlyNumbers(replacementString: forbiddenCharacter2, text: numberWithPoint))

        XCTAssertTrue(mut.allowOnlyNumbers(replacementString: allowedCharacter, text: numberWithPoint))
    }

    // MARK: - OnlyCharactersField
    func testOnlyCharactersField_IsAllowedCharacters() throws {
        let allowedInput = "aSdRv-32145"
        let forbiddenInput = "12dA!-AsdfR"

        XCTAssertTrue(mut.isAllowedChar(text: allowedInput, replacementString: "0"))
        XCTAssertFalse(mut.isAllowedChar(text: forbiddenInput, replacementString: "0"))
    }

    // MARK: - LinkTextField
    func testLinkTextField_CheckURL_Validation() throws {
        let correctURL = "https://www.google.com"
        let invalidURL = "google"

        XCTAssertEqual(mut.checkUrlValidation(input: invalidURL), "")
        XCTAssertNotNil(mut.checkUrlValidation(input: correctURL))
    }

    // MARK: - ValidationRulesTextField
    func testValidationRulesTextField_IsMinOfCharactersRule() throws {
        let input1 = "1s3f5g6k8"
        let input2 = "abc"

        XCTAssertFalse(mut.hasRequiredQuantityOfCharacters(charCount: input2.count))
        XCTAssertTrue(mut.hasRequiredQuantityOfCharacters(charCount: input1.count))
    }

    func testValidationRulesTextField_IsContainsDigit_Rule() throws {
        let inputContainingDigit = "1test2"
        let inputWithoutDigits = "test"

        XCTAssertFalse(mut.isContainsDigit(text: inputWithoutDigits))
        XCTAssertTrue(mut.isContainsDigit(text: inputContainingDigit))
    }

    func testValidationRulesTextField_IsContainsLowercaseCharacters_Rule() throws {
        let inputContainingLowercaseChar = "aaa"
        let inputWithoutLowercaseChar = "A"

        XCTAssertFalse(mut.isContainsLowercase(text: inputWithoutLowercaseChar))
        XCTAssertTrue(mut.isContainsLowercase(text: inputContainingLowercaseChar))
    }

    func testValidationRulesTextField_IsContainsUppercaseCharacters_Rule() throws {
        let inputContainingUppercaseChar = "A"
        let inputWithoutUppercaseChar = "aaa"

        XCTAssertFalse(mut.isContainsUppercase(text: inputWithoutUppercaseChar))
        XCTAssertTrue(mut.isContainsUppercase(text: inputContainingUppercaseChar))
    }
}
