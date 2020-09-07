// Corona-Warn-App
//
// SAP SE and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import UIKit

class ExposureSubmissionIntroViewController: DynamicTableViewController, ENANavigationControllerWithFooterChild {

	// MARK: - Attributes.

	private(set) weak var coordinator: ExposureSubmissionCoordinating?

	// MARK: - Initializers.

	init?(coder: NSCoder, coordinator: ExposureSubmissionCoordinating) {
		super.init(coder: coder)
		self.coordinator = coordinator
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View lifecycle methods.

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationFooterItem?.primaryButtonTitle = AppStrings.ExposureSubmission.continueText

		setupView()
		setupBackButton()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		footerView?.primaryButton?.accessibilityIdentifier = AccessibilityIdentifiers.ExposureSubmission.continueText
	}

	// MARK: - Setup helpers.

	private func setupView() {
		setupTitle()
		setupTableView()
	}

	private func setupTitle() {
		navigationItem.largeTitleDisplayMode = .always
		title = AppStrings.ExposureSubmissionIntroduction.title
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UINib(nibName: String(describing: ExposureSubmissionStepCell.self), bundle: nil), forCellReuseIdentifier: CustomCellReuseIdentifiers.stepCell.rawValue)
		dynamicTableViewModel = .intro
	}

	// MARK: - ENANavigationControllerWithFooterChild methods.

	func navigationController(_ navigationController: ENANavigationControllerWithFooter, didTapPrimaryButton button: UIButton) {
		coordinator?.showOverviewScreen()
	}
}

private extension DynamicTableViewModel {
	static let intro = DynamicTableViewModel([
		.navigationSubtitle(text: AppStrings.ExposureSubmissionIntroduction.subTitle,
							accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionIntroduction.subTitle),
		.section(
			header: .image(
				UIImage(named: "Illu_Submission_Funktion1"),
				accessibilityLabel: AppStrings.ExposureSubmissionIntroduction.accImageDescription,
				accessibilityIdentifier: AccessibilityIdentifiers.General.image,
				height: 200
			),
			separators: false,
			cells: [
				.headline(text: AppStrings.ExposureSubmissionIntroduction.usage01,
						  accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionIntroduction.usage01),
				.body(text: AppStrings.ExposureSubmissionIntroduction.usage02,
					  accessibilityIdentifier: AccessibilityIdentifiers.ExposureSubmissionIntroduction.usage02),
				ExposureSubmissionDynamicCell.stepCell(bulletPoint: AppStrings.ExposureSubmissionIntroduction.listItem1)
			]
		)
	])
}

private extension ExposureSubmissionIntroViewController {
	enum CustomCellReuseIdentifiers: String, TableViewCellReuseIdentifiers {
		case stepCell
	}
}
