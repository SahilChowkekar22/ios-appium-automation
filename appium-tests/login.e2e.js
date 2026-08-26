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
        // Let Appium's WDA retry settings control startup instead of repeating whole sessions.
        connectionRetryCount: 0,
        capabilities: {
            platformName: "iOS",
            "appium:automationName": "XCUITest",
            "appium:deviceName": process.env.IOS_DEVICE_NAME || "iPhone 17",
            "appium:platformVersion": process.env.IOS_VERSION || "26.2",
            "appium:udid": process.env.SIMULATOR_UDID,
            "appium:simulatorStartupTimeout": 300000,
            "appium:wdaLaunchTimeout": 300000,
            "appium:wdaConnectionTimeout": 300000,
            "appium:wdaStartupRetries": 4,
            "appium:wdaStartupRetryInterval": 20000,
            "appium:useNewWDA": true,
            "appium:isHeadless": process.env.CI === "true",
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
