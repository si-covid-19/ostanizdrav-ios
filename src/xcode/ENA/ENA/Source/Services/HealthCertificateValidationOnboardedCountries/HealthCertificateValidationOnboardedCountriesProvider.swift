////
// 🦠 Corona-Warn-App
//

import Foundation
import HealthCertificateToolkit

protocol HealthCertificateValidationOnboardedCountriesProviding {
	func onboardedCountries(
		completion: @escaping (Result<[Country], ValidationOnboardedCountriesError>) -> Void
	)
}

final class HealthCertificateValidationOnboardedCountriesProvider: HealthCertificateValidationOnboardedCountriesProviding {
	
	// MARK: - Init
	
	init(
		restService: RestServiceProviding
	) {
		self.restService = restService
	}
	
	// MARK: - Protocol HealthCertificateValidationOnboardedCountriesProviding
	
	func onboardedCountries(
		completion: @escaping (Result<[Country], ValidationOnboardedCountriesError>) -> Void
	) {
		let resource = ValidationOnboardedCountriesResource()
	
		restService.load(resource) { result in
			DispatchQueue.main.async {
				switch result {
				case let .success(validationOnboardedCountriesModel):
					completion(.success(validationOnboardedCountriesModel.countries))
				case let .failure(error):
					if case let .receivedResourceError(customError) = error {
						completion(.failure(customError))
					} else {
						Log.error("Unhandled error \(error.localizedDescription)", log: .vaccination)
						completion(.failure(.ONBOARDED_COUNTRIES_CLIENT_ERROR))
					}
				}
			}
		}
	}
	
	// MARK: - Private
	
	private let restService: RestServiceProviding
}
