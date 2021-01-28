//
// 🦠 Corona-Warn-App
//

import ExposureNotification
import Foundation

/// Describes how to interfact with the backend.
protocol Client {
	// MARK: Types

	typealias Failure = URLSession.Response.Failure
	typealias KeySubmissionResponse = (Result<Void, Error>) -> Void
	typealias AvailableDaysCompletionHandler = (Result<[String], Failure>) -> Void
	typealias AvailableHoursCompletionHandler = (Result<[Int], Failure>) -> Void
	typealias RegistrationHandler = (Result<String, Failure>) -> Void
	typealias TestResultHandler = (Result<Int, Failure>) -> Void
	typealias TANHandler = (Result<String, Failure>) -> Void
	typealias DayCompletionHandler = (Result<PackageDownloadResponse, Failure>) -> Void
	typealias HourCompletionHandler = (Result<PackageDownloadResponse, Failure>) -> Void
	typealias CountryFetchCompletion = (Result<[Country], Failure>) -> Void

	// MARK: Interacting with a Client

	/// Determines days that can be downloaded.
	///
	/// - Parameters:
	///   - country: Country code
	///   - completion: completion callback which includes the list of available days
	func availableDays(
		forCountry country: String,
		completion: @escaping AvailableDaysCompletionHandler
	)

	/// Fetches the keys for a given day and country code
	/// - Parameters:
	///   - day: The day that the keys belong to
	///   - country: It should be country code, like DE stands for Germany
	///   - completion: Once the request is done, the completion is called.
	func fetchDay(
		_ day: String,
		forCountry country: String,
		completion: @escaping DayCompletionHandler
	)

	// MARK: Getting the Configuration

	/// Gets the registration token
	func getRegistrationToken(
		forKey key: String,
		withType type: String,
		isFake: Bool,
		completion completeWith: @escaping RegistrationHandler
	)

	// getTestResultForDevice
	func getTestResult(
		forDevice registrationToken: String,
		isFake: Bool,
		completion completeWith: @escaping TestResultHandler
	)

	// getTANForDevice
	func getTANForExposureSubmit(
		forDevice registrationToken: String,
		isFake: Bool,
		completion completeWith: @escaping TANHandler
	)

	// MARK: Submit keys

	/// Submits exposure keys to the backend. This makes the local information available to the world so that the risk of others can be calculated on their local devices.
	/// - Parameters:
	///   - payload: A set of properties to provide during the submission process
	///   - isFake: flag to indicate a fake request
	///   - completion: the completion handler of the submission call
	func submit(
		payload: CountrySubmissionPayload,
		isFake: Bool,
		completion: @escaping KeySubmissionResponse
	)
}

enum SubmissionError: Error {
	case other(Error)
	case invalidPayloadOrHeaders
	case invalidTan
	case serverError(Int)
	case requestCouldNotBeBuilt
	case simpleError(String)
}

extension SubmissionError: LocalizedError {
	var localizedDescription: String {
		switch self {
		case let .serverError(code):
			return "\(AppStrings.ExposureSubmissionError.other)\(code)\(AppStrings.ExposureSubmissionError.otherend)"
		case .invalidPayloadOrHeaders:
			return "Received an invalid payload or headers."
		case .invalidTan:
			return AppStrings.ExposureSubmissionError.invalidTan
		case .requestCouldNotBeBuilt:
			return "The submission request could not be built correctly."
		case let .simpleError(errorString):
			return errorString
		case let .other(error):
			return error.localizedDescription
		}
	}
}

/// A container for a downloaded `SAPDownloadedPackage` and its corresponding `ETag`, if given.
struct PackageDownloadResponse {
	let package: SAPDownloadedPackage

	/// The response ETag
	///
	/// This is used to identify and revoke packages.
	let etag: String?
}

/// Combined model for a submit keys request
struct CountrySubmissionPayload {

	/// The exposure keys to submit
	let exposureKeys: [SAP_External_Exposurenotification_TemporaryExposureKey]

	/// the list of countries to check for any exposures
	let visitedCountries: [Country]

	/// a transaction number
	let tan: String
}

struct DaysResult {
	let errors: [Client.Failure]
	let bucketsByDay: [String: PackageDownloadResponse]
}

struct HoursResult {
	let errors: [Client.Failure]
	let bucketsByHour: [Int: PackageDownloadResponse]
	let day: String
}

struct FetchedDaysAndHours {
	let hours: HoursResult
	let days: DaysResult
	var allKeyPackages: [PackageDownloadResponse] {
		Array(hours.bucketsByHour.values) + Array(days.bucketsByDay.values)
	}
}

extension Client {
	typealias FetchDaysCompletionHandler = (DaysResult) -> Void
	typealias FetchHoursCompletionHandler = (HoursResult) -> Void

	/// Fetch the keys with the given days and country code
	func fetchDays(
			_ days: [String],
			forCountry country: String,
			completion completeWith: @escaping FetchDaysCompletionHandler
	) {
		var errors = [Client.Failure]()
		var buckets = [String: PackageDownloadResponse]()

		let group = DispatchGroup()
		for day in days {
			group.enter()

			fetchDay(day, forCountry: country) { result in
				switch result {
				case let .success(bucket):
					buckets[day] = bucket
				case let .failure(error):
					errors.append(error)
				}
				group.leave()
			}
		}

		group.notify(queue: .main) {
			completeWith(
				DaysResult(
					errors: errors,
					bucketsByDay: buckets
				)
			)
		}
	}

}
