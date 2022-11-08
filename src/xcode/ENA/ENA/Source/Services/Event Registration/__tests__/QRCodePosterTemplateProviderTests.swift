//
// 🦠 Corona-Warn-App
//

import XCTest
import OpenCombine
@testable import ENA

class QRCodePosterTemplateProviderTests: CWATestCase {

	private var subscriptions = [AnyCancellable]()
	
	func testFetchStaticQRCodePosterTemplate() {
		let fetchedFromClientExpectation = expectation(description: "Static QR code poster template fetched from client")
		fetchedFromClientExpectation.expectedFulfillmentCount = 1

		let store = MockTestStore()
		XCTAssertNil(store.qrCodePosterTemplateMetadata)

		let client = CachingHTTPClientMock()
		client.fetchQRCodePosterTemplateData(etag: "fake") { result in
			switch result {
			case .success(let response):
				XCTAssertNotNil(response.eTag)
				XCTAssertNotNil(response.qrCodePosterTemplate)
				XCTAssertNotNil(response.qrCodePosterTemplate.template)
			case .failure(let error):
				XCTFail(error.localizedDescription)
			}
			fetchedFromClientExpectation.fulfill()
		}

		waitForExpectations(timeout: .medium)
	}

	func testQRCodePosterTemplateProviding() throws {
		let valueReceived = expectation(description: "Value received")
		valueReceived.expectedFulfillmentCount = 1

		let store = MockTestStore()
		let client = CachingHTTPClientMock()
		let provider = QRCodePosterTemplateProvider(client: client, store: store)
		provider.latestQRCodePosterTemplate()
			.sink(receiveCompletion: { result in
				switch result {
				case .finished:
					break
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
			}, receiveValue: { qrCodePosterTemplate in
				XCTAssertNotNil(qrCodePosterTemplate)
				XCTAssertNotNil(qrCodePosterTemplate.template)
				valueReceived.fulfill()
			})
			.store(in: &subscriptions)

		waitForExpectations(timeout: .medium)
	}
	
	func testQRCodePosterTemplateProvidingHTTPErrors() throws {
		let defaultTemplateReceived = expectation(description: "Default template received")

		let store = MockTestStore()
		let client = CachingHTTPClientMock()
		client.onFetchQRCodePosterTemplateData = { _, completeWith in
			// fake a broken backend
			let error = URLSessionError.serverError(503)
			completeWith(.failure(error))
		}

		let provider = QRCodePosterTemplateProvider(client: client, store: store)
		provider.latestQRCodePosterTemplate()
			.sink(receiveCompletion: { result in
				switch result {
				case .finished:
					break
				case .failure:
					XCTFail("Did not expect an error")
				}
			}, receiveValue: { qrCodePosterTemplate in
				XCTAssertNotNil(qrCodePosterTemplate)
				XCTAssertNotNil(qrCodePosterTemplate.template)
				defaultTemplateReceived.fulfill()
			})
			.store(in: &subscriptions)

		waitForExpectations(timeout: .medium)
	}

	func testQRCodePosterTemplateProvidingHttp304() throws {
		let checkpoint = expectation(description: "Value received")
		checkpoint.expectedFulfillmentCount = 2

		let store = MockTestStore()
		store.qrCodePosterTemplateMetadata = QRCodePosterTemplateMetadata(
			lastQRCodePosterTemplateETag: "fake",
			lastQRCodePosterTemplateFetchDate: try XCTUnwrap(301.secondsAgo),
			qrCodePosterTemplate: CachingHTTPClientMock.staticQRCodeTemplate)
		
		// Fake, backend returns HTTP 304
		let client = CachingHTTPClientMock()
		client.onFetchQRCodePosterTemplateData = { _, completeWith in
			let error = URLSessionError.notModified
			completeWith(.failure(error))
			checkpoint.fulfill()
		}

		let provider = QRCodePosterTemplateProvider(client: client, store: store)
		provider.latestQRCodePosterTemplate()
			.sink(receiveCompletion: { result in
				switch result {
				case .finished:
					break
				case .failure(let error):
					XCTFail("Expected a no error, got: \(error)")
				}
			}, receiveValue: { qrCodePosterTemplate in
				XCTAssertNotNil(qrCodePosterTemplate)
				XCTAssertNotNil(qrCodePosterTemplate.template)
				checkpoint.fulfill()
			})
			.store(in: &subscriptions)

		waitForExpectations(timeout: .medium)
	}
	
	func testQRCodePosterTemplateProvidingInvalidCacheState() throws {
		let defaultTemplateReceived = expectation(description: "Default template received")
		defaultTemplateReceived.expectedFulfillmentCount = 2

		let store = MockTestStore()

		let client = CachingHTTPClientMock()
		client.onFetchQRCodePosterTemplateData = { _, completeWith in
			let error = URLSessionError.notModified
			completeWith(.failure(error))
			defaultTemplateReceived.fulfill()
		}

		let provider = QRCodePosterTemplateProvider(client: client, store: store)
		provider.latestQRCodePosterTemplate()
			.sink(receiveCompletion: { result in
				switch result {
				case .finished:
					break
				case .failure:
					XCTFail("Did not expect an error")
				}
			}, receiveValue: { qrCodePosterTemplate in
				XCTAssertNotNil(qrCodePosterTemplate)
				XCTAssertNotNil(qrCodePosterTemplate.template)
				defaultTemplateReceived.fulfill()
			})
			.store(in: &subscriptions)

		waitForExpectations(timeout: .medium)
	}
}
