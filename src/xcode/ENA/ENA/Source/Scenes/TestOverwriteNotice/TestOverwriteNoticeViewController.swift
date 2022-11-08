////
// 🦠 Corona-Warn-App
//

import UIKit

class TestOverwriteNoticeViewController: DynamicTableViewController, DismissHandling, FooterViewHandling {

	// MARK: - Init

	init(
		testType: CoronaTestType,
		didTapPrimaryButton: @escaping () -> Void,
		didTapCloseButton: @escaping () -> Void
	) {
		self.viewModel = TestOverwriteNoticeViewModel(testType)
		self.didTapPrimaryButton = didTapPrimaryButton
		self.didTapCloseButton = didTapCloseButton
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = dismissHandlingCloseBarButton
		navigationItem.title = viewModel.title
		navigationController?.navigationBar.prefersLargeTitles = true

		setupTableView()
	}

	// MARK: - DismissHandling

	func wasAttemptedToBeDismissed() {
		didTapCloseButton()
	}

	// MARK: - Protocol FooterViewHandling

	func didTapFooterViewButton(_ type: FooterViewModel.ButtonType) {
		guard type == .primary else {
			return
		}
		didTapPrimaryButton()
	}

	// MARK: - Public

	// MARK: - Internal

	// MARK: - Private

	private let viewModel: TestOverwriteNoticeViewModel
	private let didTapPrimaryButton: () -> Void
	private let didTapCloseButton: () -> Void

	private func setupTableView() {
		tableView.separatorStyle = .none
		tableView.allowsSelection = false
		tableView.backgroundColor = .enaColor(for: .background)
		dynamicTableViewModel = viewModel.dynamicTableViewModel
	}

}
