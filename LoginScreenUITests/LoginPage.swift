//
//  LoginPage.swift
//  LoginScreenUITests
//
//  Created by Sahil ChowKekar on 8/24/26.
//

import XCTest

final class LoginPage {

    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Elements

    private var emailField: XCUIElement {
        app.textFields["emailField"]
    }

    private var passwordField: XCUIElement {
        app.secureTextFields["passwordField"]
    }

    private var loginButton: XCUIElement {
        app.buttons["loginButton"]
    }

    // MARK: - Validation Messages

    var emptyEmailValidationMessage: XCUIElement {
        app.staticTexts["Please enter your email."]
    }

    var invalidEmailValidationMessage: XCUIElement {
        app.staticTexts["Please enter a valid email."]
    }

    var loginSuccessMessage: XCUIElement {
        app.staticTexts["Login Successful!"]
    }

    // MARK: - Actions

    func enterEmail(_ email: String) {
        XCTAssertTrue(
            emailField.waitForExistence(timeout: 2),
            "Email field was not found."
        )

        emailField.tap()
        emailField.typeText(email)
    }

    func enterPassword(_ password: String) {
        XCTAssertTrue(
            passwordField.waitForExistence(timeout: 2),
            "Password field was not found."
        )

        passwordField.tap()
        passwordField.typeText(password)
    }

    func tapLogin() {
        XCTAssertTrue(
            loginButton.waitForExistence(timeout: 2),
            "Login button was not found."
        )

        loginButton.tap()
    }

    func login(email: String, password: String) {
        enterEmail(email)
        enterPassword(password)
        tapLogin()
    }
}
