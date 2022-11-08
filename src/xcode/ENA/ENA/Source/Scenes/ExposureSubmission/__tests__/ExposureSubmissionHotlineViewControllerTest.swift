//
// 🦠 Corona-Warn-App
//

import XCTest
@testable import ENA

class ExposureSubmissionHotlineViewControllerTest: CWATestCase {

	func testSetupView() {
		let vc = ExposureSubmissionHotlineViewController(onPrimaryButtonTap: {}, dismiss: {})

		_ = vc.view
		XCTAssertNotNil(vc.tableView)
		XCTAssertEqual(vc.tableView.numberOfSections, 2)
		XCTAssertEqual(vc.tableView(vc.tableView, numberOfRowsInSection: 1), 8)
	}

}
