////
// 🦠 Corona-Warn-App
//

import Foundation
import HealthCertificateToolkit

extension TestEntry {

	static let pcrTypeString = "LP6464-4"
	static let antigenTypeString = "LP217198-3"

	var sampleCollectionDate: Date? {
		let iso8601FormatterWithFractionalSeconds = ISO8601DateFormatter()
		iso8601FormatterWithFractionalSeconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

		return iso8601FormatterWithFractionalSeconds.date(from: dateTimeOfSampleCollection) ??
			ISO8601DateFormatter().date(from: dateTimeOfSampleCollection)
	}

	var coronaTestType: CoronaTestType? {
		switch typeOfTest {
		case Self.pcrTypeString:
			return .pcr
		case Self.antigenTypeString:
			return .antigen
		default:
			return nil
		}
	}

	// swiftlint:disable:next cyclomatic_complexity
	func title(for keyPath: PartialKeyPath<TestEntry>) -> String? {
		switch keyPath {
		case \TestEntry.diseaseOrAgentTargeted:
			return "Ciljna bolezen ali povzročitelj"
		case \TestEntry.typeOfTest:
			return "Vrsta testa"
		case \TestEntry.naaTestName:
			return "Ime testa"
		case \TestEntry.ratTestName:
			return "Proizvajalec testa"
		case \TestEntry.sampleCollectionDate:
			return "Datum in čas odvzema testnega vzorca"
		case \TestEntry.testResult:
			return "Rezultat testa"
		case \TestEntry.testCenter:
			return "Testni center ali kraj izvedbe testa"
		case \TestEntry.countryOfTest:
			return "Država testiranja"
		case \TestEntry.certificateIssuer:
			return "Izdajatelj potrdila"
		case \TestEntry.uniqueCertificateIdentifier:
			return "Enolična oznaka potrdila"
		default:
			return nil
		}
	}

	// swiftlint:disable:next cyclomatic_complexity
	func formattedValue(for keyPath: PartialKeyPath<TestEntry>, valueSets: SAP_Internal_Dgc_ValueSets?) -> String? {
		switch keyPath {
		case \TestEntry.diseaseOrAgentTargeted:
			return valueSets?
				.valueSet(for: .diseaseOrAgentTargeted)?
				.displayText(forKey: diseaseOrAgentTargeted) ?? diseaseOrAgentTargeted
		case \TestEntry.typeOfTest:
			return valueSets?
				.valueSet(for: .typeOfTest)?
				.displayText(forKey: typeOfTest) ?? typeOfTest
		case \TestEntry.naaTestName:
			return naaTestName
		case \TestEntry.ratTestName:
			return ratTestName.flatMap {
				valueSets?
					.valueSet(for: .rapidAntigenTestNameAndManufacturer)?
					.displayText(forKey: $0) ?? $0
			}
		case \TestEntry.sampleCollectionDate:
			let customDateFormatter = DateFormatter()
			customDateFormatter.dateFormat = "yyyy-MM-dd HH:mm 'UTC' x"
			// Dates for certificates are formatted in Gregorian calendar, even if the user setting is different
			customDateFormatter.calendar = .gregorian(with: Locale(identifier: "en_US_POSIX"))
			customDateFormatter.locale = Locale(identifier: "en_US_POSIX")
			return sampleCollectionDate.flatMap {
				customDateFormatter.string(from: $0)
			} ?? dateTimeOfSampleCollection
		case \TestEntry.testResult:
			return valueSets?
				.valueSet(for: .testResult)?
				.displayText(forKey: testResult) ?? testResult
		case \TestEntry.testCenter:
			return testCenter
		case \TestEntry.countryOfTest:
			return Country(countryCode: countryOfTest)?.localizedName ?? countryOfTest
		case \TestEntry.certificateIssuer:
			return certificateIssuer
		case \TestEntry.uniqueCertificateIdentifier:
			return uniqueCertificateIdentifier
		default:
			return nil
		}
	}

}
