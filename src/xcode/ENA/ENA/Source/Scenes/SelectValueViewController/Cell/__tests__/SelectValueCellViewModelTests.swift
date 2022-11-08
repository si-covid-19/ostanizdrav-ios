////
// 🦠 Corona-Warn-App
//

import XCTest
@testable import ENA

class SelectValueCellViewModelTests: CWATestCase {


	func testGIVEN_CellViewModel_WHEN_getText_THEN_isUnchanged() {
		// GIVEN
		let cellViewModel = SelectValueCellViewModel(text: "test value", isSelected: true, cellIconType: .checkmark)

		// WHEN
		let text = cellViewModel.text

		// THEN
		XCTAssertEqual("test value", text)
	}

	func testGIVEN_SelectedCellViewModel_WHEN_getImage_THEN_isCheckmark() {
		// GIVEN
		let cellViewModel = SelectValueCellViewModel(text: "test value", isSelected: true, cellIconType: .checkmark)

		// WHEN
		let image = cellViewModel.image

		// THEN
		XCTAssertEqual(UIImage(imageLiteralResourceName: "Icons_Checkmark"), image)
	}

	func testGIVEN_UnselectedCellViewModel_WHEN_getImage_THEN_isCheckmark() {
		// GIVEN
		let cellViewModel = SelectValueCellViewModel(text: "test value", isSelected: false, cellIconType: .checkmark)

		// WHEN
		let image = cellViewModel.image

		// THEN
		XCTAssertNil(image)
	}

}
