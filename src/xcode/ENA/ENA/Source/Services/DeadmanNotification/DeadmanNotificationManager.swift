//
// 🦠 Corona-Warn-App
//

import UserNotifications

protocol DeadmanNotificationManageable {
	func scheduleDeadmanNotificationIfNeeded()
	func resetDeadmanNotification()
}

struct DeadmanNotificationManager: DeadmanNotificationManageable {

	// MARK: - Init

	init(
		coronaTestService: CoronaTestService,
		userNotificationCenter: UserNotificationCenter = UNUserNotificationCenter.current()
	) {
		self.coronaTestService = coronaTestService
		self.userNotificationCenter = userNotificationCenter
	}

	// MARK: - Internal

	static let deadmanNotificationIdentifier = (Bundle.main.bundleIdentifier ?? "") + ".notifications.cwa-deadman"
	
	/// Schedules a local notification to fire 36 hours from now, if there isn´t a notification already scheduled
	func scheduleDeadmanNotificationIfNeeded() {
		guard !coronaTestService.hasAtLeastOneShownPositiveOrSubmittedTest else {
			Log.info("DeadmanNotificationManager: Keys were already submitted or positive test result was already shown for at least one registered test. Don't schedule new deadman notification.", log: .riskDetection)
			return
		}

		/// Check if Deadman Notification is already scheduled
		userNotificationCenter.getPendingNotificationRequests { notificationRequests in
			if notificationRequests.contains(where: { $0.identifier == Self.deadmanNotificationIdentifier }) {
				/// Deadman Notification already setup -> return
				return
			} else {
				/// No Deadman Notification setup, continue to setup a new one
				let content = UNMutableNotificationContent()
				content.title = AppStrings.Common.deadmanAlertTitle
				content.body = AppStrings.Common.deadmanAlertBody
				content.sound = .default
				
				let trigger = UNTimeIntervalNotificationTrigger(
					timeInterval: 36 * 60 * 60,
					repeats: false
				)
				
				let request = UNNotificationRequest(
					identifier: Self.deadmanNotificationIdentifier,
					content: content,
					trigger: trigger
				)
				
				userNotificationCenter.add(request) { error in
					if error != nil {
						Log.error("Deadman notification could not be scheduled.")
					}
				}
			}
		}
	}
	
	/// Reset the Deadman Notification, should be called after a successful risk-calculation.
	func resetDeadmanNotification() {
		cancelDeadmanNotification()
		scheduleDeadmanNotificationIfNeeded()
	}
	
	// MARK: - Private

	private let coronaTestService: CoronaTestService
	private let userNotificationCenter: UserNotificationCenter

	/// Cancels the Deadman Notification
	private func cancelDeadmanNotification() {
		userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [Self.deadmanNotificationIdentifier])
	}

}
