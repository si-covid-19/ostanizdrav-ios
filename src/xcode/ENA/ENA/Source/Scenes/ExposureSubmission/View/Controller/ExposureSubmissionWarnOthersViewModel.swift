//
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

struct ExposureSubmissionWarnOthersViewModel {

	// MARK: - Properties

	private let dismissCompletion: (() -> Void)?
	private let countries: [Country]
	private let acknowledgementString: NSAttributedString = {
		let boldText = AppStrings.ExposureSubmissionWarnOthers.acknowledgement_1_1
		let normalText = AppStrings.ExposureSubmissionWarnOthers.acknowledgement_1_2
		let string = NSMutableAttributedString(string: "\(boldText)\n\n\(normalText)")

		// highlighted text
		let attributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.preferredFont(forTextStyle: .headline)
		]
		string.addAttributes(attributes, range: NSRange(location: 0, length: boldText.count))

		return string
	}()

	// MARK: - Init

	init(supportedCountries: [Country], completion: (() -> Void)?) {
		countries = supportedCountries.sortedByLocalizedName
		dismissCompletion = completion
	}

	// MARK: - Internal

	var dynamicTableViewModel: DynamicTableViewModel {
		var model = DynamicTableViewModel([])

		// Andere Warnen
		model.add(
			.section(
				header: .image(
					UIImage(named: "Illu_Submission_AndereWarnen"),
					accessibilityLabel: AppStrings.ExposureSubmissionWarnOthers.accImageDescription,
					accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionWarnOthers.accImageDescription,
					height: 250
				),
				cells: [
					.title2(
						text: AppStrings.ExposureSubmissionWarnOthers.sectionTitle,
						accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionWarnOthers.sectionTitle
					),
					.body(
						text: AppStrings.ExposureSubmissionWarnOthers.description,
						accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionWarnOthers.description
					),
					.space(height: 12)
				]
			)
		)

		// 'Flags'
		model.add(
			.section(separators: .all, cells: [
				.countries(countries: countries, accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionWarnOthers.countryList),
				.space(height: 8)
			])
		)

		// Ihr Einverständnis
		model.add(
			.section(cells: [
				.legal(
					title: NSAttributedString(string: AppStrings.ExposureSubmissionWarnOthers.acknowledgementTitle),
					description: NSAttributedString(string: AppStrings.ExposureSubmissionWarnOthers.acknowledgementBody),
					textBlocks: [
						acknowledgementString,
						NSAttributedString(string: AppStrings.ExposureSubmissionWarnOthers.acknowledgement_footer)
					],
					accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionWarnOthers.acknowledgementTitle
				),
				.bulletPoint(text: AppStrings.ExposureSubmissionWarnOthers.consent_bullet1, alignment: .legal),
				.bulletPoint(text: AppStrings.ExposureSubmissionWarnOthers.consent_bullet2, alignment: .legal),
				.bulletPoint(text: AppStrings.ExposureSubmissionWarnOthers.consent_bullet3, alignment: .legal),
				.bulletPoint(text: AppStrings.ExposureSubmissionWarnOthers.consent_bullet4, alignment: .legal),
				.bulletPoint(text: AppStrings.ExposureSubmissionWarnOthers.consent_bullet5, alignment: .legal),
				.space(height: 16)
			])
		)

		// Button: detailed information
		model.add(
			.section(separators: .all, cells: [
				.body(
					text: AppStrings.AutomaticSharingConsent.dataProcessingDetailInfo,
					style: DynamicCell.TextCellStyle.label,
					accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionWarnOthers.dataProcessingDetailInfo,
					accessibilityTraits: UIAccessibilityTraits.link,
					action: .push(
						htmlModel: AppInformationModel.privacyModel,
						withTitle: AppStrings.AppInformation.privacyTitle,
						completion: dismissCompletion
					),
					configure: { _, cell, _ in
						cell.accessoryType = .disclosureIndicator
						cell.selectionStyle = .default
					}),
				.space(height: 12)
			])
		)

		return model
	}
}

extension DynamicCell {

	/// A `DynamicLegalCell` to display a list of acknowledgements the user is informed about.
	/// - Parameters:
	///   - title: The title/header for the legal foo.
	///   - description: Optional description text.
	///   - textBlocks: A list of strings to be shown.
	///   - accessibilityIdentifier: Optional, but highly recommended, accessibility identifier.
	///   - configure: Optional custom cell configuration
	/// - Returns: A `DynamicCell` to display legal texts
	static func legal(
		title: NSAttributedString,
		description: NSAttributedString?,
		textBlocks: [NSAttributedString],
		accessibilityIdentifier: String? = nil,
		configure: CellConfigurator? = nil
	) -> Self {
		.identifier(ExposureSubmissionWarnOthersViewController.ReuseIdentifiers.acknowledgement) { viewController, cell, indexPath in
			guard let cell = cell as? DynamicLegalCell else {
				fatalError("could not initialize cell of type `DynamicLegalCell`")
			}
			cell.configure(title: title, description: description, textBlocks: textBlocks, accessibilityIdentifier: accessibilityIdentifier)
			configure?(viewController, cell, indexPath)
		}
	}
}
