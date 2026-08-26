const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const { remote } = require("webdriverio");

async function runTest() {
    if (!process.env.SIMULATOR_UDID) {
        throw new Error("SIMULATOR_UDID environment variable is not set");
    }

    const appPath = path.resolve(
        "build/Build/Products/Debug-iphonesimulator/LoginScreen.app"
    );

    if (!fs.existsSync(appPath)) {
        throw new Error(`App not found: ${appPath}`);
    }

    console.log(`Using simulator: ${process.env.SIMULATOR_UDID}`);
    console.log(`Using app: ${appPath}`);

    const driver = await remote({
        hostname: "127.0.0.1",
        port: 4723,
        path: "/",

        // Allow enough time for the first XCUITest/WDA startup.
        connectionRetryTimeout: 360000,
        connectionRetryCount: 1,

        capabilities: {
            platformName: "iOS",
            "appium:automationName": "XCUITest",

            "appium:deviceName":
                process.env.IOS_DEVICE_NAME || "iPhone 17",

            "appium:platformVersion":
                process.env.IOS_VERSION || "26.2",

            "appium:udid": process.env.SIMULATOR_UDID,

            "appium:simulatorStartupTimeout": 300000,

            "appium:wdaLaunchTimeout": 300000,
            "appium:wdaConnectionTimeout": 300000,

            "appium:wdaStartupRetries": 4,
            "appium:wdaStartupRetryInterval": 20000,

            // Reuse WDA when possible instead of reinstalling it.
            "appium:useNewWDA": false,

            // Keep enabled while debugging CI/WDA startup.
            "appium:showXcodeLog": true,

            "appium:isHeadless": process.env.CI === "true",

            "appium:app": appPath,
            "appium:noReset": false,
        },
    });

    try {
        console.log("Appium session started");

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

        // Verify success message.
        const success = await driver.$("~loginSuccessMessage");

        await success.waitForDisplayed({
            timeout: 5000,
        });

        const actualMessage = await success.getText();

        assert.equal(
            actualMessage,
            "Login Successful!",
            `Expected success message but received: "${actualMessage}"`
        );

        console.log("Login test passed");
    } catch (error) {
        console.error("Login test failed:", error);

        try {
            await driver.saveScreenshot("./artifacts/login-failure.png");
            console.log("Failure screenshot saved");
        } catch (screenshotError) {
            console.error(
                "Could not save failure screenshot:",
                screenshotError
            );
        }

        throw error;
    } finally {
        await driver.deleteSession();
    }
}

runTest().catch((error) => {
    console.error(error);
    process.exit(1);
});