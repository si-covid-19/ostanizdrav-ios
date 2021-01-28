//
// 🦠 Corona-Warn-App
//

import XCTest
import ExposureNotification

class ENAUITests_01_Home: XCTestCase {
	var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		setupSnapshot(app)
		app.setDefaults()
		app.launchArguments.append(contentsOf: ["-isOnboarded", "YES"])
		app.launchArguments.append(contentsOf: ["-setCurrentOnboardingVersion", "YES"])
		app.launchArguments.append(contentsOf: ["-userNeedsToBeInformedAboutHowRiskDetectionWorks", "NO"])
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func test_0010_HomeFlow_medium() throws {
		app.setPreferredContentSizeCategory(accessibililty: .normal, size: .M)
		app.launch()

		// only run if home screen is present
		XCTAssertTrue(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: .medium))

		app.swipeUp()
		// assert cells
		XCTAssertTrue(app.cells["AppStrings.Home.infoCardShareTitle"].waitForExistence(timeout: .medium))
		XCTAssertTrue(app.cells["AppStrings.Home.infoCardAboutTitle"].waitForExistence(timeout: .medium))
		XCTAssertTrue(app.cells["AppStrings.Home.appInformationCardTitle"].waitForExistence(timeout: .medium))
		XCTAssertTrue(app.cells["AppStrings.Home.settingsCardTitle"].waitForExistence(timeout: .medium))
		// snapshot("ScreenShot_\(#function)")
	}

	func test_0011_HomeFlow_extrasmall() throws {
		app.setPreferredContentSizeCategory(accessibililty: .normal, size: .XS)
		app.launch()

		// only run if home screen is present
		XCTAssertTrue(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: .medium))

		app.swipeUp()
		// assert cells
		XCTAssertTrue(app.cells["AppStrings.Home.infoCardShareTitle"].waitForExistence(timeout: .medium))
		XCTAssertTrue(app.cells["AppStrings.Home.infoCardAboutTitle"].waitForExistence(timeout: .short))
		XCTAssertTrue(app.cells["AppStrings.Home.appInformationCardTitle"].waitForExistence(timeout: .short))
		XCTAssertTrue(app.cells["AppStrings.Home.settingsCardTitle"].waitForExistence(timeout: .short))
		// snapshot("ScreenShot_\(#function)")
	}

	func test_0013_HomeFlow_extralarge() throws {
		app.setPreferredContentSizeCategory(accessibililty: .accessibility, size: .XL)
		app.launch()

		// only run if home screen is present
		XCTAssertTrue(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: .medium))

		app.swipeUp()
		app.swipeUp()
		// assert cells
		XCTAssertTrue(app.cells["AppStrings.Home.infoCardShareTitle"].waitForExistence(timeout: .medium))
		XCTAssertTrue(app.cells["AppStrings.Home.infoCardAboutTitle"].waitForExistence(timeout: .short))
		app.swipeUp()
		XCTAssertTrue(app.cells["AppStrings.Home.appInformationCardTitle"].waitForExistence(timeout: .medium))
		XCTAssertTrue(app.cells["AppStrings.Home.settingsCardTitle"].waitForExistence(timeout: .short))
		// snapshot("ScreenShot_\(#function)")
	}
	
	func test_screenshot_homescreen_riskCardHigh() throws {
		var screenshotCounter = 0
		let riskLevel = "high"
		let numberOfDaysWithHighRisk = 1
		app.setPreferredContentSizeCategory(accessibililty: .accessibility, size: .XS)
		app.launchArguments.append(contentsOf: ["-riskLevel", riskLevel])
		app.launch()
		
		XCTAssert(app.buttons["RiskLevelCollectionViewCell.topContainer"].waitForExistence(timeout: .medium))
		XCTAssert(app.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .short))

		// Red risk card title "Erhöhtes Risiko" – the localized text is used as accessibility identifier
		// see HomeRiskLevelCellConfigurator.setupAccessibility()
		XCTAssert(app.buttons[AccessibilityLabels.localized(AppStrings.Home.riskCardHighTitle)].waitForExistence(timeout: .short))
		
		// find an element with localized text "Begegnungen an einem Tag mit erhöhtem Risiko"
		let highRiskTitle = String(format: AccessibilityLabels.localized(AppStrings.Home.riskCardHighNumberContactsItemTitle), numberOfDaysWithHighRisk)
		XCTAssert(app.staticTexts[highRiskTitle].waitForExistence(timeout: .short))
		
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: .short))
		snapshot("homescreenrisk_level_\(riskLevel)_\(String(format: "%04d", (screenshotCounter.inc() )))")
		app.swipeUp()
		snapshot("homescreenrisk_level_\(riskLevel)_\(String(format: "%04d", (screenshotCounter.inc() )))")
	}
	
	func test_screenshot_homescreen_riskCardLow() throws {
		var screenshotCounter = 0
		let riskLevel = "low"
		let numberOfDaysWithLowRisk = 0
		app.setPreferredContentSizeCategory(accessibililty: .accessibility, size: .XS)
		app.launchArguments.append(contentsOf: ["-riskLevel", riskLevel])
		app.launch()
		
		XCTAssert(app.buttons["RiskLevelCollectionViewCell.topContainer"].waitForExistence(timeout: .medium))
		XCTAssert(app.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .short))
		
		// Green risk card title "Niedriges Risiko" – the localized text is used as accessibility identifier
		// see HomeRiskLevelCellConfigurator.setupAccessibility()
		XCTAssertNotNil(app.buttons[AccessibilityLabels.localized(AppStrings.Home.riskCardLowTitle)].waitForExistence(timeout: .short))
		
		// find an element with localized text "Keine Risiko-Begegnungen"
		let lowRiskTitle = String(format: AccessibilityLabels.localized(AppStrings.Home.riskCardLowNumberContactsItemTitle), numberOfDaysWithLowRisk)
		XCTAssert(app.staticTexts[lowRiskTitle].waitForExistence(timeout: .short))
		
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: .short))
		snapshot("homescreenrisk_level_\(riskLevel)_\(String(format: "%04d", (screenshotCounter.inc() )))")
		app.swipeUp()
		snapshot("homescreenrisk_level_\(riskLevel)_\(String(format: "%04d", (screenshotCounter.inc() )))")
	}
	
	func test_screenshot_homescreen_riskCardInactive() throws {
		var screenshotCounter = 0
		let riskLevel = "inactive"
		app.setPreferredContentSizeCategory(accessibililty: .accessibility, size: .XS)
		app.launchArguments.append(contentsOf: ["-riskLevel", riskLevel])
		app.launch()

		XCTAssert(app.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .short))

		// Inactive risk card title "Risiko-Ermittlung gestoppt" – the localized text is used as accessibility identifier
		XCTAssert(app.buttons[AccessibilityLabels.localized(AppStrings.Home.riskCardInactiveNoCalculationPossibleTitle)].waitForExistence(timeout: .short))
		
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: .short))
		snapshot("homescreenrisk_level_\(riskLevel)_\(String(format: "%04d", (screenshotCounter.inc() )))")
		app.swipeUp()
		snapshot("homescreenrisk_level_\(riskLevel)_\(String(format: "%04d", (screenshotCounter.inc() )))")
		
	}

	// MARK: - Risk states with active Exposure Logging

	func test_screenshot_homescreen_riskCardHigh_activeExposureLogging() throws {
		var screenshotCounter = 0
		let riskLevel = "high"
		app.setPreferredContentSizeCategory(accessibililty: .accessibility, size: .XS)
		app.launchArguments.append(contentsOf: ["-riskLevel", riskLevel])
		app.launchArguments.append(contentsOf: ["-isOnboarded", "YES"])
		app.launchArguments.append(contentsOf: ["-ENStatus", ENStatus.active.stringValue])
		app.launch()

		XCTAssert(app.buttons["RiskLevelCollectionViewCell.topContainer"].waitForExistence(timeout: .medium))
		XCTAssert(app.buttons["AppStrings.Home.submitCardButton"].waitForExistence(timeout: .short))

		snapshot("homescreenrisk_level_\(riskLevel)_noExposureLogging_\(String(format: "%04d", (screenshotCounter.inc() )))")
		app.swipeUp()
		snapshot("homescreenrisk_level_\(riskLevel)_noExposureLogging_\(String(format: "%04d", (screenshotCounter.inc() )))")
	}
}
