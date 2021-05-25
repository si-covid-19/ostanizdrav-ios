////
// 🦠 Corona-Warn-App
//

import Foundation

protocol PrivacyPreservingAccessControl {
	func getPPACToken(_ completion: @escaping (Result<PPACToken, PPACError>) -> Void)
	#if !RELEASE
	func generateNewAPIToken() -> TimestampedToken
	#endif
}

class PPACService: PrivacyPreservingAccessControl {

	// MARK: - Init

	init(
		store: Store,
		deviceCheck: DeviceCheckable
	) {
		self.store = store
		self.deviceCheck = deviceCheck
	}

	// MARK: - Protocol PrivacyPreservingAccessControl

	func getPPACToken(_ completion: @escaping (Result<PPACToken, PPACError>) -> Void) {

		// check if time isn't incorrect
		if store.deviceTimeCheckResult == .incorrect {
			Log.error("device time is incorrect", log: .ppac)
			completion(.failure(PPACError.timeIncorrect))
			return
		}

		// check if time isn't unknown
		if store.deviceTimeCheckResult == .assumedCorrect {
			Log.error("device time is unverified", log: .ppac)
			completion(.failure(PPACError.timeUnverified))
			return
		}

		// check if device supports DeviceCheck
		guard deviceCheck.isSupported else {
			Log.error("device token not supported", log: .ppac)
			completion(.failure(PPACError.deviceNotSupported))
			return
		}

		deviceCheck.deviceToken(apiToken.token, completion: completion)
	}

	#if !RELEASE
	// needed to make it possible to get called from the developer menu
	func generateNewAPIToken() -> TimestampedToken {
		return generateAndStoreFreshAPIToken()
	}
	#endif

	// MARK: - Private

	private let deviceCheck: DeviceCheckable
	private let store: Store

	/// will return the current API Token and create a new one if needed
	private var apiToken: TimestampedToken {
		let today = Date()
		/// check if we alread have a token and if it was created in this month / year
		guard let storedToken = store.ppacApiToken,
			  storedToken.timestamp.isEqual(to: today, toGranularity: .month),
			  storedToken.timestamp.isEqual(to: today, toGranularity: .year)
		else {
			return generateAndStoreFreshAPIToken()
		}
		return storedToken
	}

	/// generate a new API Toke and store it
	private func generateAndStoreFreshAPIToken() -> TimestampedToken {
		let uuid = UUID().uuidString
		let utcDate = Date()
		let token = TimestampedToken(token: uuid, timestamp: utcDate)
		store.ppacApiToken = token
		return token
	}

}
