//
//  LoginScreenUITests.swift
//  LoginScreenUITests
//
//  Created by Sahil ChowKekar on 8/20/26.
//

import XCTest

final class LoginScreenUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // Keep the form visible above the keyboard while tests enter text.
        XCUIDevice.shared.orientation = .portrait

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testEmptyEmailShowsValidationMessage() throws {
        let app = XCUIApplication()
        app.launch()

        // Act: tap Login without entering any information.
        app.buttons["loginButton"].tap()

        // Assert: verify the message the user sees.
        XCTAssertTrue(app.staticTexts["Please enter your email."].exists)
    }

    @MainActor
    func testInvalidEmailShowsValidationMessage() throws {
        let app = XCUIApplication()
        app.launch()

        // Act: enter an invalid email address and submit it.
        enterText("not-an-email", into: app.textFields["emailField"])
        app.buttons["loginButton"].tap()

        // Assert: this confirms validation stopped the login.
        XCTAssertTrue(app.staticTexts["Please enter a valid email."].exists)
    }

    @MainActor
    func testValidCredentialsNavigateToHomeScreen() throws {
        let app = XCUIApplication()
        app.launch()

        // Act: fill in valid values and log in.
        enterText("student@example.com", into: app.textFields["emailField"])
        enterText("password123", into: app.secureTextFields["passwordField"])
        app.buttons["loginButton"].tap()

        // Assert: the destination view confirms navigation succeeded.
        XCTAssertTrue(app.staticTexts["Login Successful!"].waitForExistence(timeout: 2))
    }

    /// Waits for a form field, taps it, and then enters text.
    private func enterText(_ text: String, into field: XCUIElement) {
        XCTAssertTrue(field.waitForExistence(timeout: 2), "The form field was not found.")
        field.tap()
        field.typeText(text)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
