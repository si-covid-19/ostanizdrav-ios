////
// 🦠 Corona-Warn-App
//

import Foundation
import HealthCertificateToolkit

extension RecoveryEntry {

	var localCertificateValidityStartDate: Date? {
		return ISO8601DateFormatter.justLocalDateFormatter.date(from: certificateValidFrom)
	}

	var localCertificateValidityEndDate: Date? {
		return ISO8601DateFormatter.justLocalDateFormatter.date(from: certificateValidUntil)
	}

	func title(for keyPath: PartialKeyPath<RecoveryEntry>) -> String? {
		switch keyPath {
		case \RecoveryEntry.diseaseOrAgentTargeted:
			return "Ciljna bolezen ali povzročitelj"
		case \RecoveryEntry.dateOfFirstPositiveNAAResult:
			return "Datum prvega pozitivnega testa (YYYY-MM-DD)"
		case \RecoveryEntry.countryOfTest:
			return "Država testiranja"
		case \RecoveryEntry.certificateIssuer:
			return "Izdajatelj potrdila"
		case \RecoveryEntry.certificateValidFrom:
			return "Veljavnost od (YYYY-MM-DD)"
		case \RecoveryEntry.certificateValidUntil:
			return "Veljavnost do (YYYY-MM-DD)"
		case \RecoveryEntry.uniqueCertificateIdentifier:
			return "Enolična oznaka potrdila"
		default:
			return nil
		}
	}

	func formattedValue(for keyPath: PartialKeyPath<RecoveryEntry>, valueSets: SAP_Internal_Dgc_ValueSets?) -> String? {
		switch keyPath {
		case \RecoveryEntry.diseaseOrAgentTargeted:
			return valueSets?
				.valueSet(for: .diseaseOrAgentTargeted)?
				.displayText(forKey: diseaseOrAgentTargeted) ?? diseaseOrAgentTargeted
		case \RecoveryEntry.dateOfFirstPositiveNAAResult:
			return DCCDateStringFormatter.formattedString(from: dateOfFirstPositiveNAAResult)
		case \RecoveryEntry.countryOfTest:
			return Country(countryCode: countryOfTest)?.localizedName ?? countryOfTest
		case \RecoveryEntry.certificateIssuer:
			return certificateIssuer
		case \RecoveryEntry.certificateValidFrom:
			return certificateValidFrom
		case \RecoveryEntry.certificateValidUntil:
			return certificateValidUntil
		case \RecoveryEntry.uniqueCertificateIdentifier:
			return uniqueCertificateIdentifier
		default:
			return nil
		}
	}

}
