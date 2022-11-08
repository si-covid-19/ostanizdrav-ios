////
// 🦠 Corona-Warn-App
//

import XCTest
@testable import ENA
import OpenCombine

class CheckInTimeModelTests: CWATestCase {

	func testGIVEN_CheckInTimeModel_WHEN_DateChanges_THEN_InitialPublisherSubmit() {
		// GIVEN
		var subscriptions = Set<AnyCancellable>()
		let now = Date(timeIntervalSince1970: 1616074184)
		let cellModel = CheckInTimeModel("myType", minDate: Date(), maxDate: Date(), date: now, hasTopSeparator: false, isPickerVisible: false)

		// WHEN
		let dateChangeExpectation = expectation(description: "date did change")
		cellModel.$date.sink { update in
			XCTAssertEqual(now, update)
			dateChangeExpectation.fulfill()
		}
		.store(in: &subscriptions)

		// THEN
		XCTAssertEqual(cellModel.type, "myType")
		XCTAssertFalse(cellModel.hasTopSeparator)
		wait(for: [dateChangeExpectation], timeout: .medium)
	}

}
