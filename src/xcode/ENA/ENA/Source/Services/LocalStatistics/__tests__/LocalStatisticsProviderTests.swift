//
// 🦠 Corona-Warn-App
//

import XCTest
import OpenCombine
@testable import ENA

class LocalStatisticsProviderTests: CWATestCase {
	
	func testFetchLocalStatistics() {
		let fetchedFromClientExpectation = expectation(description: "Local statistics fetched from client")
		fetchedFromClientExpectation.expectedFulfillmentCount = 1

		let store = MockTestStore()
		XCTAssertEqual(store.localStatistics, [])

		let client = CachingHTTPClientMock()
		client.fetchLocalStatistics(groupID: "1", eTag: "fake") { result in
			switch result {
			case .success(let response):
				XCTAssertNotNil(response.eTag)
				XCTAssertNotNil(response.timestamp)
				XCTAssertNotNil(response.localStatistics)
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			fetchedFromClientExpectation.fulfill()
		}

		waitForExpectations(timeout: .medium)
	}
	
	func testLocalStatisticsProvidingUpdateWithoutSelectedRegions() throws {
		let updateExpectation = expectation(description: "Update completion called")
		
		let store = MockTestStore()
		let client = CachingHTTPClientMock()
		let provider = LocalStatisticsProvider(client: client, store: store)

		provider.updateLocalStatistics { result in
			switch result {
			case .success(let localStatistics):
				XCTAssertNotNil(localStatistics)
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}

			updateExpectation.fulfill()
		}
		
		waitForExpectations(timeout: .short)
	}
	
	func testLocalStatisticsProvidingHTTPErrors() throws {
		let store = MockTestStore()
		store.selectedLocalStatisticsRegions.append(
			LocalStatisticsRegion(
				federalState: .badenWürttemberg,
				name: "Heidelberg",
				id: "1432",
				regionType: .administrativeUnit
			)
		)

		let client = CachingHTTPClientMock()
		let expectedError = URLSessionError.serverError(503)
		client.onFetchLocalStatistics = { _, completeWith in
			// fake a broken backend
			completeWith(.failure(expectedError))
		}
		
		let provider = LocalStatisticsProvider(client: client, store: store)

		let updateExpectation = expectation(description: "Update completion called")
		provider.updateLocalStatistics { result in
			switch result {
			case .success:
				XCTFail("Did not expect a success")
			case .failure(let error):
				XCTAssertEqual(error.localizedDescription, expectedError.errorDescription)
			}

			updateExpectation.fulfill()
		}

		waitForExpectations(timeout: .short)
	}
	
	func testLocalStatisticsProvidingHTTP304() throws {
		let valueNotChangedExpectation = expectation(description: "Value not changed")
		valueNotChangedExpectation.expectedFulfillmentCount = 2
		
		let store = MockTestStore()
		store.localStatistics.append(
			LocalStatisticsMetadata(
				groupID: "1",
				lastLocalStatisticsETag: "fake",
				lastLocalStatisticsFetchDate: try XCTUnwrap(301.secondsAgo),
				localStatistics: CachingHTTPClientMock.staticLocalStatistics
			)
		)

		store.selectedLocalStatisticsRegions.append(
			LocalStatisticsRegion(
				federalState: .badenWürttemberg,
				name: "Heidelberg",
				id: "1432",
				regionType: .administrativeUnit
			)
		)

		// Fake backend returns HTTP 304
		let client = CachingHTTPClientMock()
		client.onFetchLocalStatistics = { _, completeWith in
			let error = URLSessionError.notModified
			completeWith(.failure(error))
			valueNotChangedExpectation.fulfill()
		}
		
		let provider = LocalStatisticsProvider(client: client, store: store)
		provider.updateLocalStatistics { result in
			switch result {
			case .success(let value):
				XCTAssertNotNil(value)
				valueNotChangedExpectation.fulfill()
			case .failure(let error):
				XCTFail("Did not expect an error, got: \(error)")
			}
			
		}
		
		waitForExpectations(timeout: .medium)
	}
}
