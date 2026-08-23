const assert = require("node:assert/strict");
const path = require("node:path");
const { remote } = require("webdriverio");

async function runTest() {
    const driver = await remote({
        hostname: "127.0.0.1",
        port: 4723,
        path: "/",
        // The first XCUITest session can take several minutes while Appium builds WebDriverAgent.
        connectionRetryTimeout: 300000,
        capabilities: {
            platformName: "iOS",
            "appium:automationName": "XCUITest",
            "appium:deviceName": "iPhone 17",
            "appium:platformVersion": "26.2",
            "appium:udid": "434276BD-179D-4B90-B0E5-3C1DE56AC980",
            "appium:app": path.resolve(
                "build/Build/Products/Debug-iphonesimulator/LoginScreen.app"
            ),
            "appium:noReset": false,
        },
    });

    try {
        const email = await driver.$("~emailField");
        const password = await driver.$("~passwordField");
        const loginButton = await driver.$("~loginButton");

        // Enter email.
        await email.click();
        await email.setValue("student@example.com");

        // Enter password.
        await password.click();
        await password.setValue("password123");

        // Tap Login.
        await loginButton.click();

        // Wait for and verify the success message.
        const success = await driver.$("~loginSuccessMessage");
        await success.waitForDisplayed({ timeout: 5000 });
        assert.equal(await success.getText(), "Login Successful!");

        console.log("Login test passed");
    } finally {
        await driver.deleteSession();
    }
}

runTest().catch((error) => {
    console.error(error);
    process.exit(1);
});
