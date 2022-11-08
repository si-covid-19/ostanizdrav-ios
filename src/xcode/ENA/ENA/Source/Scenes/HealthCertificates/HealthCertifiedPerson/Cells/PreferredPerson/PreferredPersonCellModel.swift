////
// 🦠 Corona-Warn-App
//

import Foundation
import OpenCombine

final class PreferredPersonCellModel {

	// MARK: - Init

	init(
		healthCertifiedPerson: HealthCertifiedPerson
	) {
		self.healthCertifiedPerson = healthCertifiedPerson

		healthCertifiedPerson.$isPreferredPerson
			.sink { [weak self] in
				self?.isPreferredPerson = $0
			}
			.store(in: &subscriptions)
	}

	// MARK: - Internal

	var name: String? {
		healthCertifiedPerson.name?.fullName
	}

	var dateOfBirth: String? {
		healthCertifiedPerson.dateOfBirth
			.flatMap {
				DCCDateStringFormatter.localizedFormattedString(from: $0)
			}
			.flatMap {
				String(format: AppStrings.HealthCertificate.Person.PreferredPerson.dateOfBirth, $0)
			}
	}

	var description: String? {
		guard let name = name else {
			return nil
		}

		return String(format: AppStrings.HealthCertificate.Person.PreferredPerson.description, name)
	}

	@DidSetPublished var isPreferredPerson: Bool = false

	func setAsPreferredPerson(_ newValue: Bool) {
		healthCertifiedPerson.isPreferredPerson = newValue
	}

	// MARK: - Private

	let healthCertifiedPerson: HealthCertifiedPerson

	private var subscriptions = Set<AnyCancellable>()

}
