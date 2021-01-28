//
// 🦠 Corona-Warn-App
//

import Foundation
import XCTest
@testable import ENA

class DiaryDayEntryCellModelTest: XCTestCase {

	func testContactPersonUnselected() throws {
		let entry: DiaryEntry = .contactPerson(DiaryContactPerson(id: 0, name: "Nick Guendling", encounterId: nil))
		let viewModel = DiaryDayEntryCellModel(entry: entry)

		XCTAssertEqual(viewModel.image, UIImage(named: "Diary_Checkmark_Unselected"))
		XCTAssertEqual(viewModel.text, "Nick Guendling")
		XCTAssertEqual(viewModel.accessibilityTraits, .button)
	}

	func testContactPersonSelected() throws {
		let entry: DiaryEntry = .contactPerson(DiaryContactPerson(id: 0, name: "Marcus Scherer", encounterId: 0))
		let viewModel = DiaryDayEntryCellModel(entry: entry)

		XCTAssertEqual(viewModel.image, UIImage(named: "Diary_Checkmark_Selected"))
		XCTAssertEqual(viewModel.text, "Marcus Scherer")
		XCTAssertEqual(viewModel.accessibilityTraits, [.button, .selected])
	}

	func testLocationUnselected() throws {
		let entry: DiaryEntry = .location(DiaryLocation(id: 0, name: "Bakery", visitId: nil))
		let viewModel = DiaryDayEntryCellModel(entry: entry)

		XCTAssertEqual(viewModel.image, UIImage(named: "Diary_Checkmark_Unselected"))
		XCTAssertEqual(viewModel.text, "Bakery")
		XCTAssertEqual(viewModel.accessibilityTraits, .button)
	}

	func testLocationSelected() throws {
		let entry: DiaryEntry = .location(DiaryLocation(id: 0, name: "Supermarket", visitId: 0))
		let viewModel = DiaryDayEntryCellModel(entry: entry)

		XCTAssertEqual(viewModel.image, UIImage(named: "Diary_Checkmark_Selected"))
		XCTAssertEqual(viewModel.text, "Supermarket")
		XCTAssertEqual(viewModel.accessibilityTraits, [.button, .selected])
	}
	
}
