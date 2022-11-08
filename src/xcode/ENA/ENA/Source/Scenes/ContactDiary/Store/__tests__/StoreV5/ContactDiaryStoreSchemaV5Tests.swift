////
// 🦠 Corona-Warn-App
//

import XCTest
import FMDB
@testable import ENA

final class ContactDiaryStoreSchemaV5Tests: CWATestCase {

	func test_When_createIsCalled_Then_AllTablesAreCreated() {
		guard let databaseQueue = FMDatabaseQueue(path: "file::memory:") else {
			fatalError("Could not create FMDatabaseQueue.")
		}

		let schema = ContactDiaryStoreSchemaV5(databaseQueue: databaseQueue)

		let result = schema.create()

		if case let .failure(error) = result {
			XCTFail("Error not expected: \(error)")
		}

		databaseQueue.inDatabase { database in
			XCTAssertTrue(database.tableExists("ContactPerson"))
			XCTAssertTrue(database.tableExists("Location"))
			XCTAssertTrue(database.tableExists("ContactPersonEncounter"))
			XCTAssertTrue(database.tableExists("LocationVisit"))
			XCTAssertTrue(database.tableExists("CoronaTest"))

			XCTAssertEqual(database.userVersion, 5)
		}
	}
}
