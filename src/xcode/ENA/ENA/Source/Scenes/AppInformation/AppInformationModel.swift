//
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

enum AppInformationModel {
	
	static let aboutModel = DynamicTableViewModel([
		.section(
			header: .image(UIImage(named: "Illu_AppInfo_UeberApp"),
						   accessibilityLabel: AppStrings.AppInformation.aboutImageDescription,
						   accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.aboutImageDescription,
						   height: 230),
			cells: [
				.title2(text: AppStrings.AppInformation.aboutTitle,
						accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.aboutTitle),
				.headline(text: AppStrings.AppInformation.aboutDescription,
						  accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.aboutDescription),
				.subheadline(text: AppStrings.AppInformation.aboutText,
							 accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.aboutText),
				.link(placeholder: AppStrings.AppInformation.aboutLinkText, link: AppStrings.AppInformation.aboutLink, font: .subheadline, style: .subheadline, accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.aboutLinkText)
			]
		)
	])

	static let contactModel = DynamicTableViewModel([
		.section(
			header: .image(UIImage(named: "Illu_Appinfo_Kontakt"),
						   accessibilityLabel: AppStrings.AppInformation.contactImageDescription,
						   accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactImageDescription,
						   height: 230),
			cells: [
				.title2(text: AppStrings.AppInformation.contactTitle,
						accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactTitle),
				.body(text: [AppStrings.AppInformation.contactDescription, AppStrings.Common.tessRelayDescription].joined(separator: ""),
					  accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactDescription),
				.link(placeholder: AppStrings.AppInformation.contactHotlineText, link: "mailto:\(AppStrings.AppInformation.contactHotlineNumber)", font: .title2, style: .title2,
						accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactHotlineText),
				.title2(text: AppStrings.AppInformation.contactHotlineTitle,
						  accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactHotlineTitle),
				.body(text: AppStrings.AppInformation.contactHotlineDescription,
						  accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactHotlineDescription),
				.phone(text: AppStrings.AppInformation.contactHotlineText1, number: AppStrings.AppInformation.contactHotlineNumber1,
					   accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactHotlineText1),
				.footnote(text: AppStrings.AppInformation.contactHotlineTerms,
						  accessibilityIdentifier: AccessibilityIdentifiers.AppInformation.contactHotlineTerms)
			]
		)
	])

	static let privacyModel = HtmlInfoModel(
		title: AppStrings.AppInformation.privacyTitle,
		titleAccessabliltyIdentfier: AccessibilityIdentifiers.AppInformation.privacyTitle,
		image: UIImage(named: "Illu_Appinfo_Datenschutz"),
		imageAccessabliltyIdentfier: AccessibilityIdentifiers.AppInformation.privacyImageDescription,
		imageAccessabliltyLabel: AppStrings.AppInformation.privacyImageDescription,
		urlResourceName: "privacy-policy"
	)

	static let termsModel = HtmlInfoModel(
		title: AppStrings.AppInformation.termsTitle,
		titleAccessabliltyIdentfier: AccessibilityIdentifiers.AppInformation.termsTitle,
		image: UIImage(named: "Illu_Appinfo_Nutzungsbedingungen"),
		imageAccessabliltyIdentfier: AccessibilityIdentifiers.AppInformation.termsImageDescription,
		imageAccessabliltyLabel: AppStrings.AppInformation.termsImageDescription,
		urlResourceName: "usage"
	)
}

private func isGerman() -> Bool {
	return Bundle.main.preferredLocalizations.first == "sl"
}
