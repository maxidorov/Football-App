//
//  RegistrationViewController.swift
//  FootballApp
//
//  Created by Андрей on 09.12.2021.
//

import Foundation
import UIKit

class AppColors {
    static let lightGreyColor = UIColor(red: 0.498, green: 0.502, blue: 0.514, alpha: 0.3)
    static let darkGreyColor = UIColor(red: 0.498, green: 0.502, blue: 0.514, alpha: 1)
}

final class RegistrationViewController: UIViewController {
    private enum Constants {
        // UI Constants
        static let standardElementHeight: CGFloat = 50
        static let standardIndent: CGFloat = 20
        static let inpViewIndent: CGFloat = 100
        static let separatorHeight: CGFloat = 1
    }
    
    private lazy var logo = UIImage(named: "logo")
    private lazy var logoView = UIImageView(image: logo)
    private lazy var signInButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColors.darkGreyColor
        button.layer.cornerRadius = 16
        button.setTitle("Log in", for: .normal)
        button.addTarget(self, action: #selector(loginButtonHover), for: .touchDown)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
                
        return button
    }()
    
    private lazy var signInLabel : UILabel = {
        let text = "Don’t have an account? Create account"
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Create account")
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15), range: range)
    
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor =  AppColors.darkGreyColor

        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.createAccountTapped(gesture:))))
        
        return label
    }()
    
    func makeTextField(placeholder: String) -> UITextField {
        let emailText = UITextField()
        emailText.font = UIFont.systemFont(ofSize: 17)
        emailText.placeholder = placeholder

        return emailText
    }
    
    private lazy var emailTextField = makeTextField(placeholder: "Email")
    
    private lazy var passwordTextField = makeTextField(placeholder: "Password")
    
    private lazy var separators = (0...1).map { _ -> UIView in
        let separator = UIView()
        separator.backgroundColor = AppColors.lightGreyColor
        return separator
    }
    
    private lazy var inpView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
            
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(signInLabel)
        view.addSubview(signInButton)
        
        view.addSubview(inpView)
        
        inpView.addSubviews(emailTextField,
                            separators[0],
                            passwordTextField,
                            separators[1])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutSignInLabel()
        layoutSignInButton()
        layoutInpView()
    }
    
    private func layoutSignInLabel() {
        signInLabel.frame = CGRect(
            x: 0, y: view.safeAreaLayoutGuide.layoutFrame.size.height
                - Constants.standardIndent,
            width: signInLabel.intrinsicContentSize.width,
            height: signInLabel.intrinsicContentSize.height
        )
        
        signInLabel.center.x = view.center.x
    }
    
    private func layoutSignInButton() {
        signInButton.frame = CGRect(
            x: 0, y: signInLabel.frame.minY
                - Constants.standardIndent
                - Constants.standardElementHeight,
            width: view.safeAreaLayoutGuide.layoutFrame.size.width
                - Constants.standardIndent * 2,
            height: Constants.standardElementHeight
        )
        
        signInButton.center.x = view.center.x
    }
    
    private func layoutInpView() {
        inpView.frame = CGRect(
            x: 0, y: 0,
            width: view.safeAreaLayoutGuide.layoutFrame.size.width
                - Constants.standardIndent * 2,
            height: Constants.standardElementHeight * 2 + Constants.separatorHeight * 2
        )
        
        inpView.center.y = view.center.y - Constants.inpViewIndent
        inpView.center.x = view.center.x
        
        emailTextField.frame = CGRect(
            x: 0, y: 0,
            width: inpView.frame.width,
            height: Constants.standardElementHeight
        )
        
        separators[0].frame = CGRect(
            x: 0,
            y: emailTextField.frame.maxY,
            width: inpView.frame.width, height: 1)
        
        passwordTextField.frame = CGRect(
            x: 0,
            y: separators[0].frame.maxY,
            width: inpView.frame.width,
            height: Constants.standardElementHeight)
        
        separators[1].frame = CGRect(
            x: 0,
            y: passwordTextField.frame.maxY,
            width: inpView.frame.width, height: 1)
    }
    
    @objc private func loginButtonPressed() {
        signInButton.backgroundColor = AppColors.darkGreyColor
        
        // MARK:- Logging in logic
    }
    
    @objc private func loginButtonHover() {
        signInButton.backgroundColor = AppColors.lightGreyColor
    }
    
    @objc private func createAccountTapped(gesture: UITapGestureRecognizer) -> Void {
        let text = "Don’t have an account?  Create account"
        let range = (text as NSString).range(of: "Create account")
        
        if gesture.didTapAttributedTextInLabel(label: signInLabel, inRange: range) {
            print("Tapped create account")
            // MARK:- Go to registration ViewController
        } else {
            print("Tapped other")
        }
    }
}

private extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
            // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: CGSize.zero)
            let textStorage = NSTextStorage(attributedString: label.attributedText!)

            // Configure layoutManager and textStorage
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)

            // Configure textContainer
            textContainer.lineFragmentPadding = 0.0
            textContainer.lineBreakMode = label.lineBreakMode
            textContainer.maximumNumberOfLines = label.numberOfLines
            let labelSize = label.bounds.size
            textContainer.size = labelSize

            // Find the tapped character location and compare it to the specified range
            let locationOfTouchInLabel = self.location(in: label)
            let textBoundingBox = layoutManager.usedRect(for: textContainer)

            let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

            let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
            let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            return NSLocationInRange(indexOfCharacter, targetRange)
        }
}