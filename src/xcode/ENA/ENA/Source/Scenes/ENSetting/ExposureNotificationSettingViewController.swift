//
// 🦠 Corona-Warn-App
//

import ExposureNotification
import UIKit

protocol ExposureNotificationSettingViewControllerDelegate: AnyObject {
	typealias Completion = (ExposureNotificationError?) -> Void

	func exposureNotificationSettingViewController(
		_ controller: ExposureNotificationSettingViewController,
		setExposureManagerEnabled enabled: Bool,
		then completion: @escaping Completion
	)
}

final class ExposureNotificationSettingViewController: UITableViewController {
	private weak var delegate: ExposureNotificationSettingViewControllerDelegate?

	private var lastActionCell: ActionCell?

	let model = ENSettingModel(content: [.banner, .actionCell, .euTracingCell, .actionDetailCell, .descriptionCell])
	let store: Store
	let appConfigurationProvider: AppConfigurationProviding
	var enState: ENStateHandler.State

	init?(
		coder: NSCoder,
		initialEnState: ENStateHandler.State,
		store: Store,
		appConfigurationProvider: AppConfigurationProviding,
		delegate: ExposureNotificationSettingViewControllerDelegate
	) {
		self.delegate = delegate
		self.store = store
		self.appConfigurationProvider = appConfigurationProvider
		enState = initialEnState
		super.init(coder: coder)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .always
		setUIText()
		tableView.sectionFooterHeight = 0.0
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	private func setExposureManagerEnabled(
		_ enabled: Bool,
		then completion: @escaping ExposureNotificationSettingViewControllerDelegate.Completion
	) {
		delegate?.exposureNotificationSettingViewController(
			self,
			setExposureManagerEnabled: enabled,
			then: completion
		)
	}
}

extension ExposureNotificationSettingViewController {
	private func setUIText() {
		title = AppStrings.ExposureNotificationSetting.title
	}

	private func handleEnableError(_ error: ExposureNotificationError, alert: Bool) {
		let openSettingsAction = UIAlertAction(title: AppStrings.Common.alertActionOpenSettings, style: .default, handler: { _ in
			if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
				UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.open(settingsUrl, completionHandler: nil)
			}
		})
		var errorMessage = ""
		switch error {
		case .exposureNotificationAuthorization:
			errorMessage = AppStrings.ExposureNotificationError.enAuthorizationError
		case .exposureNotificationRequired:
			errorMessage = AppStrings.ExposureNotificationError.enActivationRequiredError
		case .exposureNotificationUnavailable:
			errorMessage = AppStrings.ExposureNotificationError.enUnavailableError
		case .unknown(let message):
			errorMessage = AppStrings.ExposureNotificationError.enUnknownError + message
		case .apiMisuse:
			errorMessage = AppStrings.ExposureNotificationError.apiMisuse
		}
		if alert {
			alertError(message: errorMessage, title: AppStrings.ExposureNotificationError.generalErrorTitle, optInActions: [openSettingsAction])
		}
		Log.error(error.localizedDescription + " with message: " + errorMessage, log: .ui)
		if let mySceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
			mySceneDelegate.requestUpdatedExposureState()
		}
		tableView.reloadData()
	}

	private func handleErrorIfNeed(_ error: ExposureNotificationError?) {
		if let error = error {
			handleEnableError(error, alert: true)
		} else {
			tableView.reloadData()
		}
	}

	private func silentErrorIfNeed(_ error: ExposureNotificationError?) {
		if let error = error {
			handleEnableError(error, alert: false)
		} else {
			tableView.reloadData()
		}
	}

	private func askConsentToUser() {
		let alert = UIAlertController(
			title: AppStrings.Onboarding.onboardingInfo_enableLoggingOfContactsPage_panelTitle,
			message: AppStrings.Onboarding.onboardingInfo_enableLoggingOfContactsPage_panelBody,
			preferredStyle: .alert
		)
		let completionHandler: (UIAlertAction) -> Void = { action in
			switch action.style {
			case .default:
				self.persistForDPP(accepted: true)
				self.setExposureManagerEnabled(true, then: self.silentErrorIfNeed)
			case .cancel, .destructive:
				self.lastActionCell?.configure(for: self.enState, delegate: self)
				self.tableView.reloadData()
			@unknown default:
				fatalError("Not all cases of actions covered when handling the bluetooth")
			}
		}
		alert.addAction(UIAlertAction(title: AppStrings.ExposureNotificationSetting.privacyConsentActivateAction, style: .default, handler: { action in completionHandler(action) }))
		alert.addAction(UIAlertAction(title: AppStrings.ExposureNotificationSetting.privacyConsentDismissAction, style: .cancel, handler: { action in completionHandler(action) }))
		self.present(alert, animated: true, completion: nil)
	}

	func persistForDPP(accepted: Bool) {
		self.store.exposureActivationConsentAccept = accepted
		self.store.exposureActivationConsentAcceptTimestamp = Int64(Date().timeIntervalSince1970)
	}
}

extension ExposureNotificationSettingViewController {

	override func numberOfSections(in _: UITableView) -> Int {
		model.content.count
	}

	override func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
		0
	}

	override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		switch model.content[section] {
		case .actionCell:
			if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
				return UITableView.automaticDimension
			}
			return 40
		default:
			return 0
		}
	}

	override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch model.content[section] {
		case .actionCell:
			return AppStrings.ExposureNotificationSetting.actionCellHeader
		default:
			return nil
		}
	}

	override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
		1
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let section = indexPath.section
		let content = model.content[section]

		guard content.cellType == .euTracingCell else { return }

		let vc = EUSettingsViewController(appConfigurationProvider: appConfigurationProvider)
		navigationController?.pushViewController(vc, animated: true)
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let section = indexPath.section
		let content = model.content[section]

		guard let cell = tableView.dequeueReusableCell(withIdentifier: content.cellType.rawValue, for: indexPath) as? ConfigurableENSettingCell else {
			return UITableViewCell()
		}

		switch content {
		case .banner:
			cell.configure(for: enState)
		case .actionCell:
			if let lastActionCell = lastActionCell {
				return lastActionCell
			}
			if let cell = cell as? ActionCell {
				cell.configure(for: enState, delegate: self)
				lastActionCell = cell
			}
		case .euTracingCell:
			return euTracingCell(for: indexPath, in: tableView)
		case .tracingCell, .actionDetailCell:
			switch enState {
			case .enabled, .disabled:
				return tracingCell(for: indexPath, in: tableView)
			case .bluetoothOff, .restricted, .notAuthorized, .unknown, .notActiveApp:
				(cell as? ActionCell)?.configure(for: enState, delegate: self)
			}
		case .descriptionCell:
			cell.configure(for: enState)
		}

		return cell
	}

	// MARK: - Private

	private func euTracingCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
		let dequeuedEUTracingCell = tableView.dequeueReusableCell(withIdentifier: ENSettingModel.Content.euTracingCell.cellType.rawValue, for: indexPath)
		guard let euTracingCell = dequeuedEUTracingCell as? EuTracingTableViewCell else {
			return UITableViewCell()
		}

		euTracingCell.configure()
		return euTracingCell
	}

	private func tracingCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
		let dequeuedTracingCell = tableView.dequeueReusableCell(withIdentifier: ENSettingModel.Content.tracingCell.cellType.rawValue, for: indexPath)
		guard let tracingCell = dequeuedTracingCell as? TracingHistoryTableViewCell else {
			return UITableViewCell()
		}

		let colorConfig: (UIColor, UIColor) = (self.enState == .enabled) ?
			(UIColor.enaColor(for: .tint), UIColor.enaColor(for: .hairline)) :
			(UIColor.enaColor(for: .textPrimary2), UIColor.enaColor(for: .hairline))
		let activeTracing = store.tracingStatusHistory.activeTracing()
		let text = [
			activeTracing.exposureDetectionActiveTracingSectionTextParagraph0,
			activeTracing.exposureDetectionActiveTracingSectionTextParagraph1]
			.joined(separator: "\n\n")

		let numberOfDaysWithActiveTracing = activeTracing.inDays
		let title = NSLocalizedString("ExposureDetection_ActiveTracingSection_Title", comment: "")
		let subtitle = NSLocalizedString("ExposureDetection_ActiveTracingSection_Subtitle", comment: "")

		tracingCell.configure(
			progress: CGFloat(numberOfDaysWithActiveTracing),
			title: title,
			subtitle: subtitle,
			text: text,
			colorConfigurationTuple: colorConfig
		)

		return tracingCell
	}

}

extension ExposureNotificationSettingViewController: ActionTableViewCellDelegate {
	func performAction(action: SettingAction) {
		switch action {
		case .enable(true):
			setExposureManagerEnabled(true, then: handleErrorIfNeed)
		case .enable(false):
			setExposureManagerEnabled(false, then: handleErrorIfNeed)
		case .askConsent:
			askConsentToUser()
		}
	}
}

extension ExposureNotificationSettingViewController {
	fileprivate enum ReusableCellIdentifier: String {
		case banner
		case actionCell
		case euTracingCell
		case tracingCell
		case actionDetailCell
		case descriptionCell
	}
}

private extension ENSettingModel.Content {
	var cellType: ExposureNotificationSettingViewController.ReusableCellIdentifier {
		switch self {
		case .banner:
			return .banner
		case .actionCell:
			return .actionCell
		case .euTracingCell:
			return .euTracingCell
		case .tracingCell:
			return .tracingCell
		case .actionDetailCell:
			return .actionDetailCell
		case .descriptionCell:
			return .descriptionCell
		}
	}
}

// MARK: ENStateHandler Updating
extension ExposureNotificationSettingViewController: ENStateHandlerUpdating {
	func updateEnState(_ enState: ENStateHandler.State) {
		Log.info("Get the new state: \(enState)", log: .api)
		self.enState = enState
		lastActionCell?.configure(for: enState, delegate: self)
		self.tableView.reloadData()
	}
}
