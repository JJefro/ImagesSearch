//
//  CustomTextField.swift
//  textFields!
//
//  Created by Jevgenijs Jefrosinins on 22/09/2021.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {
    
    var minOfCharactersRule = UILabel()
    var minOfDigitsRule = UILabel()
    var minOfLowercaseCharRule = UILabel()
    var minOfUppercaseCharRule = UILabel()
    
    var progressView = UIProgressView()
    
    private var progressLineHeight = 7
    private var progressLineCornerRadius: CGFloat = 10
    private var validationRulesTextSize: CGFloat = 13
    private var stepInPercentageTerms: Float = 0.25 /// Execution of one rule as a percentage
    
    /// When progress has changed, we change progress line length and progressTintColor with animation
    private var progress: Float = 0 {
        didSet {
            let rules = [isMinOfCharRuleDone, isMinOfDigitsRuleDone, isMinOfLowercaseCharRuleDone, isMinOfUppercaseCharRuleDone]
            let completedRules = rules.filter { $0 == true } .count
            progress = Float(completedRules) * stepInPercentageTerms
            
            UIView.animate(withDuration: 0.9) {
                self.progressView.setProgress(self.progress, animated: true)
                self.updateProgressViewTintColor()
            }
        }
    }
    
    // MARK: - Validation Rules Settings
    var hasValidationRules: Bool = false {
        didSet {
            if hasValidationRules {
                makeValidationLabelsConstraints()
                addProgressView()
            }
        }
    }
    
    var isMinOfCharRuleDone: Bool = false {
        didSet {
            if isMinOfCharRuleDone {
                minOfCharactersRule.textColor = R.color.textFieldsColors.tfGreen()
                minOfCharactersRule.text = "✓" + R.string.localizable.textFields_minOfCharactersRule()
                progress += 1
            } else {
                minOfCharactersRule.textColor = R.color.textFieldsColors.tfTextColor()
                minOfCharactersRule.text = "-" + R.string.localizable.textFields_minOfCharactersRule()
                progress -= 1
            }
        }
    }
    
    var isMinOfDigitsRuleDone: Bool = false {
        didSet {
            if isMinOfDigitsRuleDone {
                minOfDigitsRule.textColor = R.color.textFieldsColors.tfGreen()
                minOfDigitsRule.text = "✓" + R.string.localizable.textFields_minOfDigitsRule()
                progress += 1
            } else {
                minOfDigitsRule.textColor = R.color.textFieldsColors.tfTextColor()
                minOfDigitsRule.text = "-" + R.string.localizable.textFields_minOfDigitsRule()
                progress -= 1
            }
        }
    }
    
    var isMinOfLowercaseCharRuleDone: Bool = false {
        didSet {
            if isMinOfLowercaseCharRuleDone {
                minOfLowercaseCharRule.textColor = R.color.textFieldsColors.tfGreen()
                minOfLowercaseCharRule.text = "✓" + R.string.localizable.textFields_minOfLowercaseCharRule()
                progress += 1
            } else {
                minOfLowercaseCharRule.textColor = R.color.textFieldsColors.tfTextColor()
                minOfLowercaseCharRule.text = "-" + R.string.localizable.textFields_minOfLowercaseCharRule()
                progress -= 1
            }
        }
    }
    
    var isMinOfUppercaseCharRuleDone: Bool = false {
        didSet {
            if isMinOfUppercaseCharRuleDone {
                minOfUppercaseCharRule.textColor = R.color.textFieldsColors.tfGreen()
                minOfUppercaseCharRule.text = "✓" + R.string.localizable.textFields_minOfUppercaseCharRule()
                progress += 1
            } else {
                minOfUppercaseCharRule.textColor = R.color.textFieldsColors.tfTextColor()
                minOfUppercaseCharRule.text = "-" + R.string.localizable.textFields_minOfUppercaseCharRule()
                progress -= 1
            }
        }
    }
    
    var isLimited: Bool = false {
        didSet {
            self.layer.borderColor = isLimited ?
            R.color.textFieldsColors.tfRed()!.cgColor : R.color.textFieldsColors.tfBlue()!.cgColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = !isSelected ?
            R.color.textFieldsColors.tfGray()?.cgColor : R.color.textFieldsColors.tfBlue()!.cgColor
        }
    }
    
    override var borderStyle: UITextField.BorderStyle {
        didSet {
            if borderStyle != .none {
                layer.borderWidth = 1
                layer.cornerRadius = 10
                layer.borderColor = R.color.textFieldsColors.tfGray()?.cgColor
                clipsToBounds = true
            }
        }
    }
    
    func setupImage(image: UIImage?, position: Position, size: CGSize, padding: CGFloat, tintColor: UIColor?) {
        guard let image = image else { return }
        let resizedImage = image.resize(to: size).withRenderingMode(.alwaysTemplate)
        
        let imageView = UIImageView(frame: CGRect(x: padding,
                                                  y: 0,
                                                  width: size.width,
                                                  height: size.height))
        imageView.tintColor = tintColor
        imageView.image = resizedImage
        
        let imageContainerView = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: size.width + padding * 1.5,
                                                      height: size.height))
        imageContainerView.addSubview(imageView)
        
        switch position {
        case .right:
            rightView = imageContainerView
            rightViewMode = .always
        case .left:
            leftView  = imageContainerView
            leftViewMode = .always
        }
    }
}

// MARK: - ProgressView Configurations
private extension CustomTextField {
    func updateProgressViewTintColor() {
        if progressView.progress <= 0.25 {
            progressView.progressTintColor = R.color.textFieldsColors.tfRed()
        } else if progressView.progress <= 0.75 {
            progressView.progressTintColor = R.color.textFieldsColors.tfOrange()
        } else {
            progressView.progressTintColor = R.color.textFieldsColors.tfGreen()
        }
    }
    
    func addProgressView() {
        progressView.trackTintColor = UIColor.clear
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = progressLineCornerRadius
        
        superview?.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.height.equalTo(progressLineHeight)
            make.bottom.leading.trailing.equalTo(self)
        }
    }
}

// MARK: - Validation Labels Constraints
private extension CustomTextField {
    func makeValidationLabelsConstraints() {
        let labelFont = R.font.openSansRegular(size: validationRulesTextSize)
        let leadingConstraints = 24
        let topConstraints = -21
        
        minOfCharactersRule.text = "-" + R.string.localizable.textFields_minOfCharactersRule()
        minOfCharactersRule.font = labelFont
        superview?.addSubview(minOfCharactersRule)
        minOfCharactersRule.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(topConstraints)
            make.leading.equalToSuperview().inset(leadingConstraints)
        }
        
        minOfDigitsRule.text = "-" + R.string.localizable.textFields_minOfDigitsRule()
        minOfDigitsRule.font = labelFont
        superview?.addSubview(minOfDigitsRule)
        minOfDigitsRule.snp.makeConstraints { make in
            make.bottom.equalTo(minOfCharactersRule).inset(topConstraints)
            make.leading.equalToSuperview().inset(leadingConstraints)
        }
        
        minOfLowercaseCharRule.text = "-" + R.string.localizable.textFields_minOfLowercaseCharRule()
        minOfLowercaseCharRule.font = labelFont
        superview?.addSubview(minOfLowercaseCharRule)
        minOfLowercaseCharRule.snp.makeConstraints { make in
            make.bottom.equalTo(minOfDigitsRule).inset(topConstraints)
            make.leading.equalToSuperview().inset(leadingConstraints)
        }
        
        minOfUppercaseCharRule.text = "-" + R.string.localizable.textFields_minOfUppercaseCharRule()
        minOfUppercaseCharRule.font = labelFont
        superview?.addSubview(minOfUppercaseCharRule)
        minOfUppercaseCharRule.snp.makeConstraints { make in
            make.bottom.equalTo(minOfLowercaseCharRule).inset(topConstraints)
            make.leading.equalToSuperview().inset(leadingConstraints)
        }
    }
}
