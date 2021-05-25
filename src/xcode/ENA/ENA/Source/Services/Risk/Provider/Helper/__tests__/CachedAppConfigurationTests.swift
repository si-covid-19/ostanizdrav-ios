//
// 🦠 Corona-Warn-App
//

import XCTest
import OpenCombine
@testable import ENA

final class CachedAppConfigurationTests: XCTestCase {

	func testCachedRequests() {
		var subscriptions = Set<AnyCancellable>()

		let fetchedFromClientExpectation = expectation(description: "configuration fetched from client")
		// we trigger a config fetch twice but expect only one http request (plus one cached result)
		fetchedFromClientExpectation.expectedFulfillmentCount = 1
		fetchedFromClientExpectation.assertForOverFulfill = true

		let store = MockTestStore()
		XCTAssertNil(store.appConfigMetadata)

		let client = CachingHTTPClientMock(store: store)
		let expectedConfig = SAP_Internal_V2_ApplicationConfigurationIOS()
		client.onFetchAppConfiguration = { _, completeWith in
			let config = AppConfigurationFetchingResponse(expectedConfig, "etag")
			completeWith((.success(config), nil))
			fetchedFromClientExpectation.fulfill()
		}

		let cache = CachedAppConfiguration(client: client, store: store)

		let completionExpectation = expectation(description: "app configuration completion called")
		completionExpectation.expectedFulfillmentCount = 2
		wait(for: [fetchedFromClientExpectation], timeout: .medium)

		cache.appConfiguration()
			.sink { config in
				XCTAssertEqual(config, expectedConfig)
				completionExpectation.fulfill()
			}
			.store(in: &subscriptions)

		XCTAssertNotNil(store.appConfigMetadata)

		// Should not trigger another call (expectation) to the actual client or a new risk calculation
		// Remember: `expectedFulfillmentCount = 1`
		cache.appConfiguration()
			.sink { config in
				XCTAssertEqual(config, expectedConfig)
				completionExpectation.fulfill()
			}
			.store(in: &subscriptions)

		wait(for: [completionExpectation], timeout: .medium)
	}

	func testCacheSupportedCountries() throws {
		let fetchedFromClientExpectation = expectation(description: "configuration fetched from client")

		let store = MockTestStore()
		var config = SAP_Internal_V2_ApplicationConfigurationIOS()
		config.supportedCountries = ["DE", "ES", "FR", "IT", "IE", "DK"]

		let client = CachingHTTPClientMock(store: store)
		client.onFetchAppConfiguration = { _, completeWith in
			let config = AppConfigurationFetchingResponse(config, "etag")
			completeWith((.success(config), nil))
			fetchedFromClientExpectation.fulfill()
		}

		let gotValue = expectation(description: "got countries list")

		let cache = CachedAppConfiguration(client: client, store: store)
		wait(for: [fetchedFromClientExpectation], timeout: .medium)

		let subscription = cache
				.supportedCountries()
				.sink { countries in
					XCTAssertEqual(countries.count, 6)
					gotValue.fulfill()
				}

		wait(for: [gotValue], timeout: .medium)

		subscription.cancel()
	}
	
	func testClientMetadata_isUpdated_everytime_appconfiguration_isFetched() {
		let mockStore = MockTestStore()
		Analytics.setupMock(store: mockStore)
		mockStore.isPrivacyPreservingAnalyticsConsentGiven = true
		XCTAssertNil(mockStore.clientMetadata, "Client metadata should be initially nil")
		let client = CachingHTTPClientMock(store: mockStore)
		let cache = CachedAppConfiguration(client: client, store: mockStore)
		let expectationClientMetadata = expectation(description: "ClientMetadata")
		// AppVersion
		let appVersionParts = Bundle.main.appVersion.split(separator: ".")
		guard appVersionParts.count == 3,
			  let majorAppVersion = Int(appVersionParts[0]),
			  let minorAppVersion = Int(appVersionParts[1]),
			  let patchAppVersion = Int((appVersionParts[2])) else {
			return
		}
		let expectedAppVersion = Version(major: majorAppVersion, minor: minorAppVersion, patch: patchAppVersion)
		// iOSVersion
		let expectediosVersion = Version(
			major: ProcessInfo().operatingSystemVersion.majorVersion,
			minor: ProcessInfo().operatingSystemVersion.minorVersion,
			patch: ProcessInfo().operatingSystemVersion.patchVersion
		)
		// eTag
		let expectedETag = "fake"
		let configuration = cache.appConfiguration(forceFetch: true).sink { _ in
			expectationClientMetadata.fulfill()
		}
		waitForExpectations(timeout: .medium) { _ in
			XCTAssertNotNil(configuration, "configuration is not nil")
			XCTAssertNotNil(mockStore.clientMetadata, "Client metadata should be filled after fetching")
			XCTAssertEqual(expectedAppVersion, mockStore.clientMetadata?.cwaVersion, "appVersion not equal clientMetaData appVersion")
			XCTAssertEqual(expectediosVersion, mockStore.clientMetadata?.iosVersion, "iosVersion not equal clientMetaData iosVersion")
			XCTAssertEqual(expectedETag, mockStore.clientMetadata?.eTag, "eTag not equal clientMetaData eTag")
		}
	}

	func testCacheEmptySupportedCountries() throws {
		let fetchedFromClientExpectation = expectation(description: "configuration fetched from client")

		let store = MockTestStore()
		var config = SAP_Internal_V2_ApplicationConfigurationIOS()
		config.supportedCountries = []

		let client = CachingHTTPClientMock(store: store)
		client.onFetchAppConfiguration = { _, completeWith in
			let config = AppConfigurationFetchingResponse(config, "etag")
			completeWith((.success(config), nil))
			fetchedFromClientExpectation.fulfill()
		}

		let gotValue = expectation(description: "got countries list")

		let cache = CachedAppConfiguration(client: client, store: store)
		wait(for: [fetchedFromClientExpectation], timeout: .medium)

		let subscription = cache
			.supportedCountries()
			.sink { countries in
				XCTAssertEqual(countries.count, 1)
				XCTAssertEqual(countries.first, .defaultCountry())
				gotValue.fulfill()
			}

		wait(for: [gotValue], timeout: .medium)

		subscription.cancel()
	}

	func testGIVEN_CachedAppConfigration_WHEN_FetchAppConfigIsCalledMultipleTimes_THEN_FetchIsCalledOnce() {
		// GIVEN
		let fetchedFromClientExpectation = expectation(description: "configuration fetched from client only once")
		fetchedFromClientExpectation.expectedFulfillmentCount = 1

		let store = MockTestStore()
		XCTAssertNil(store.appConfigMetadata)

		let client = CachingHTTPClientMock(store: store)
		let expectedConfig = SAP_Internal_V2_ApplicationConfigurationIOS()

		client.onFetchAppConfiguration = { _, completeWith in
			sleep(2) // network
			let config = AppConfigurationFetchingResponse(expectedConfig, "etag")
			completeWith((.success(config), nil))
			fetchedFromClientExpectation.fulfill()
		}

		// WHEN
		// Initilize the `CachedAppConfiguration` will trigger `fetchAppConfiguration`.
		_ = CachedAppConfiguration(client: client, store: store)
		_ = CachedAppConfiguration(client: client, store: store)
		_ = CachedAppConfiguration(client: client, store: store)
		_ = CachedAppConfiguration(client: client, store: store)
		_ = CachedAppConfiguration(client: client, store: store)
		_ = CachedAppConfiguration(client: client, store: store)

		waitForExpectations(timeout: .medium)
		XCTAssertNotNil(store.appConfigMetadata)
	}

	func testMultipleRequestsForSupportedCountries() throws {
		let store = MockTestStore()
		var config = CachingHTTPClientMock.staticAppConfig
		config.supportedCountries = ["DE", "ES", "FR", "IT", "IE", "DK"]

		let httpRequest = expectation(description: "server request")
		let gotValue = expectation(description: "got countries list")
		gotValue.expectedFulfillmentCount = 3

		let client = CachingHTTPClientMock(store: store)
		client.onFetchAppConfiguration = { _, completeWith in
			let config = AppConfigurationFetchingResponse(config, "etag")
			completeWith((.success(config), nil))
			httpRequest.fulfill()
		}

		var subscriptions = [AnyCancellable]()
		for _ in 0..<gotValue.expectedFulfillmentCount {
			let cache = CachedAppConfiguration(client: client, store: store)
			cache
				.supportedCountries()
				.sink { countries in
					XCTAssertEqual(countries.count, 6)
					gotValue.fulfill()
				}
				.store(in: &subscriptions)
		}

		waitForExpectations(timeout: .medium)
	}
}

extension Int {

	/// A date n seconds ago
	var secondsAgo: Date? {
		let components = DateComponents(second: -(self))
		return Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
	}

}
