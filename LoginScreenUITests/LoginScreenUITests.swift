//
//  LoginScreenUITests.swift
//  LoginScreenUITests
//
//  Created by Sahil ChowKekar on 8/20/26.
//

import XCTest

final class LoginScreenUITests: XCTestCase {

    private var app: XCUIApplication!
    private var loginPage: LoginPage!

    override func setUpWithError() throws {
        continueAfterFailure = false

        XCUIDevice.shared.orientation = .portrait

        app = XCUIApplication()
        app.launch()

        loginPage = LoginPage(app: app)
    }

    override func tearDownWithError() throws {
        app = nil
        loginPage = nil
    }

    @MainActor
    func testEmptyEmailShowsValidationMessage() throws {

        // Act
        loginPage.tapLogin()

        // Assert
        XCTAssertTrue(
            loginPage.emptyEmailValidationMessage.waitForExistence(timeout: 5),
            "Expected email validation message was not displayed."
        )
    }

    @MainActor
    func testInvalidEmailShowsValidationMessage() throws {

        // Act
        loginPage.enterEmail("not-an-email")
        loginPage.tapLogin()

        // Assert
        XCTAssertTrue(
            loginPage.invalidEmailValidationMessage.waitForExistence(timeout: 2)
        )
    }

    @MainActor
    func testValidCredentialsNavigateToHomeScreen() throws {

        // Act
        loginPage.login(
            email: "student@example.com",
            password: "password123"
        )

        // Assert
        XCTAssertTrue(
            loginPage.loginSuccessMessage.waitForExistence(timeout: 2)
        )
    }

    @MainActor
    func testLaunchPerformance() throws {

        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
