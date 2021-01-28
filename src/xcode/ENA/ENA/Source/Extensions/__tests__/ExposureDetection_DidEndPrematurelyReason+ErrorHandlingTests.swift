//
// 🦠 Corona-Warn-App
//

import XCTest
@testable import ENA
import ExposureNotification

final class ExposureDetection_DidEndPrematurelyReason_ErrorHandlingTests: XCTestCase {

	private typealias Reason = ExposureDetection.DidEndPrematurelyReason

    func testNonExposureWindowReasonsShouldNotReturnAnAlert() {
		let root = UIViewController()

		XCTAssertNil(Reason.noDaysAndHours.errorAlertController(rootController: root))
		XCTAssertNil(Reason.noExposureManager.errorAlertController(rootController: root))
		XCTAssertNil(Reason.noDaysAndHours.errorAlertController(rootController: root))
		XCTAssertNil(Reason.noExposureConfiguration.errorAlertController(rootController: root))
		XCTAssertNil(Reason.unableToWriteDiagnosisKeys.errorAlertController(rootController: root))
	}
	
	func testNoSummaryErrorCreatesAlert() {
		let root = UIViewController()

		XCTAssertNotNil(
			Reason.noExposureWindows(ENError(.apiMisuse)).errorAlertController(rootController: root)
		)
	}
	
	func testWrongDeviceTimeErrorAlert() {
		let root = UIViewController()

		XCTAssertNotNil(
			Reason.wrongDeviceTime.errorAlertController(rootController: root)
		)
	}

	// MARK: - Special ENError handling tests
	
	func testErrorDescription() {
		XCTAssertTrue(
			Reason.noExposureWindows(ENError(.apiMisuse)).errorDescription?.contains("EN Code: 10") == true
		)
	}

	func testError_ENError_Unsupported() {
		let root = UIViewController()
		let alert = Reason.noExposureWindows(ENError(.unsupported)).errorAlertController(rootController: root)

		XCTAssertEqual(alert?.message, AppStrings.Common.enError5Description)
		XCTAssertEqual(alert?.actions.count, 2)
		XCTAssertEqual(alert?.actions[0].title, AppStrings.Common.alertActionOk)
		XCTAssertEqual(alert?.actions[1].title, AppStrings.Common.errorAlertActionMoreInfo)
	}

	func testError_ENError_Internal() {
		let root = UIViewController()
		let alert = Reason.noExposureWindows(ENError(.internal)).errorAlertController(rootController: root)

		XCTAssertEqual(alert?.message, AppStrings.Common.enError11Description)
		XCTAssertEqual(alert?.actions.count, 2)
		XCTAssertEqual(alert?.actions[0].title, AppStrings.Common.alertActionOk)
		XCTAssertEqual(alert?.actions[1].title, AppStrings.Common.errorAlertActionMoreInfo)
	}

	func testError_ENError_RateLimit() {
		let root = UIViewController()
		let alert = Reason.noExposureWindows(ENError(.rateLimited)).errorAlertController(rootController: root)

		XCTAssertEqual(alert?.message, AppStrings.Common.enError13Description)
		XCTAssertEqual(alert?.actions.count, 2)
		XCTAssertEqual(alert?.actions[0].title, AppStrings.Common.alertActionOk)
		XCTAssertEqual(alert?.actions[1].title, AppStrings.Common.errorAlertActionMoreInfo)
	}

	// MARK: - ENError FAQ URL mapping tests

	func testENError_Unsupported_FAQURL() {
		XCTAssertEqual(ENError(.unsupported).faqURL, URL(string: AppStrings.Links.appFaqENError5))
	}

	func testENError_Internal_FAQURL() {
		XCTAssertEqual(ENError(.internal).faqURL, URL(string: AppStrings.Links.appFaqENError11))
	}

	func testENError_RateLimited_FAQURL() {
		XCTAssertEqual(ENError(.rateLimited).faqURL, URL(string: AppStrings.Links.appFaqENError13))
	}
}
