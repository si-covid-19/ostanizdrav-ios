////
// 🦠 Corona-Warn-App
//

import Foundation
import HealthCertificateToolkit

extension VaccinationEntry {

	var isLastDoseInASeriesOrBooster: Bool {
		doseNumber >= totalSeriesOfDoses
	}

	var localVaccinationDate: Date? {
		return ISO8601DateFormatter.justLocalDateFormatter.date(from: dateOfVaccination)
	}

	var doseNumberAndTotalSeriesOfDoses: String {
		"\(doseNumber) of \(totalSeriesOfDoses)"
	}
	
	// swiftlint:disable:next cyclomatic_complexity
	func title(for keyPath: PartialKeyPath<VaccinationEntry>) -> String? {
		switch keyPath {
		case \VaccinationEntry.diseaseOrAgentTargeted:
			return "Ciljna bolezen ali povzročitelj"
		case \VaccinationEntry.vaccineOrProphylaxis:
			return "Vrsta cepiva"
		case \VaccinationEntry.vaccineMedicinalProduct:
			return "Cepivo"
		case \VaccinationEntry.marketingAuthorizationHolder:
			return "Proizvajalec"
		case \VaccinationEntry.doseNumber:
			return "Številka odmerka"
		case \VaccinationEntry.totalSeriesOfDoses:
			return "Število odmerkov"
		case \VaccinationEntry.doseNumberAndTotalSeriesOfDoses:
			return "Število cepljenj"
		case \VaccinationEntry.dateOfVaccination:
			return "Datum cepljenja (YYYY-MM-DD)"
		case \VaccinationEntry.countryOfVaccination:
			return "Država cepljenja"
		case \VaccinationEntry.certificateIssuer:
			return "Izdajatelj potrdila"
		case \VaccinationEntry.uniqueCertificateIdentifier:
			return "Enolična oznaka potrdila"
		default:
			return nil
		}
	}

	// swiftlint:disable:next cyclomatic_complexity
	func formattedValue(for keyPath: PartialKeyPath<VaccinationEntry>, valueSets: SAP_Internal_Dgc_ValueSets?) -> String? {
		switch keyPath {
		case \VaccinationEntry.diseaseOrAgentTargeted:
			return valueSets?
				.valueSet(for: .diseaseOrAgentTargeted)?
				.displayText(forKey: diseaseOrAgentTargeted) ?? diseaseOrAgentTargeted
		case \VaccinationEntry.vaccineOrProphylaxis:
			return valueSets?
				.valueSet(for: .vaccineOrProphylaxis)?
				.displayText(forKey: vaccineOrProphylaxis) ?? vaccineOrProphylaxis
		case \VaccinationEntry.vaccineMedicinalProduct:
			return valueSets?
				.valueSet(for: .vaccineMedicinalProduct)?
				.displayText(forKey: vaccineMedicinalProduct) ?? vaccineMedicinalProduct
		case \VaccinationEntry.marketingAuthorizationHolder:
			return valueSets?
				.valueSet(for: .marketingAuthorizationHolder)?
				.displayText(forKey: marketingAuthorizationHolder) ?? marketingAuthorizationHolder
		case \VaccinationEntry.doseNumber:
			return String(doseNumber)
		case \VaccinationEntry.totalSeriesOfDoses:
			return String(totalSeriesOfDoses)
		case \VaccinationEntry.doseNumberAndTotalSeriesOfDoses:
			return doseNumberAndTotalSeriesOfDoses
		case \VaccinationEntry.dateOfVaccination:
			return DCCDateStringFormatter.formattedString(from: dateOfVaccination)
		case \VaccinationEntry.countryOfVaccination:
			return Country(countryCode: countryOfVaccination)?.localizedName ?? countryOfVaccination
		case \VaccinationEntry.certificateIssuer:
			return certificateIssuer
		case \VaccinationEntry.uniqueCertificateIdentifier:
			return uniqueCertificateIdentifier
		default:
			return nil
		}
	}

}
