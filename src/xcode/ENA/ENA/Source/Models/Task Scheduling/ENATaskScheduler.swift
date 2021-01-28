//
// 🦠 Corona-Warn-App
//

import BackgroundTasks
import ExposureNotification
import UIKit

enum ENATaskIdentifier: String, CaseIterable {
	// only one task identifier is allowed have the .exposure-notification suffix
	case exposureNotification = "exposure-notification"

	var backgroundTaskSchedulerIdentifier: String {
		guard let bundleID = Bundle.main.bundleIdentifier else { return "invalid-task-id!" }
		return "\(bundleID).\(rawValue)"
	}
}

protocol ENATaskExecutionDelegate: AnyObject {
	func executeENABackgroundTask(completion: @escaping ((Bool) -> Void))
}

/// - NOTE: To simulate the execution of a background task, use the following:
///         e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"de.rki.coronawarnapp-dev.exposure-notification"]
///         To simulate the expiration of a background task, use the following:
///         e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"de.rki.coronawarnapp-dev.exposure-notification"]
final class ENATaskScheduler {

	// MARK: - Static.

	static let shared = ENATaskScheduler()

	// MARK: - Attributes.

	weak var delegate: ENATaskExecutionDelegate?

	// MARK: - Initializer.

	private init() {
		registerTask(with: .exposureNotification, execute: exposureNotificationTask(_:))
	}

	// MARK: - Task registration.

	private func registerTask(with taskIdentifier: ENATaskIdentifier, execute: @escaping ((BGTask) -> Void)) {
		let identifierString = taskIdentifier.backgroundTaskSchedulerIdentifier
		BGTaskScheduler.shared.register(forTaskWithIdentifier: identifierString, using: .main) { task in
			self.scheduleTask()
			let backgroundTask = DispatchWorkItem {
				execute(task)
			}

			task.expirationHandler = {
				self.scheduleTask()
				backgroundTask.cancel()
				Log.error("Task has expired.", log: .api)
				task.setTaskCompleted(success: false)
			}

			DispatchQueue.global().async(execute: backgroundTask)
		}
	}

	// MARK: - Task scheduling.

	func scheduleTask() {
		do {
			let taskRequest = BGProcessingTaskRequest(identifier: ENATaskIdentifier.exposureNotification.backgroundTaskSchedulerIdentifier)
			taskRequest.requiresNetworkConnectivity = true
			taskRequest.requiresExternalPower = false
			taskRequest.earliestBeginDate = nil
			try BGTaskScheduler.shared.submit(taskRequest)
		} catch {
			Log.error("ERROR: scheduleTask() could NOT submit task request: \(error)", log: .api)
		}
	}

	// MARK: - Task execution handlers.

	private func exposureNotificationTask(_ task: BGTask) {
		delegate?.executeENABackgroundTask { success in
			task.setTaskCompleted(success: success)
		}
	}
	
}
