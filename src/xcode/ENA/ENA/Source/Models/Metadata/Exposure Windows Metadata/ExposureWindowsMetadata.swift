////
// 🦠 Corona-Warn-App
//

import Foundation

struct ExposureWindowsMetadata: Codable {
	
	// MARK: - Init
	
	init(
		newExposureWindowsQueue: [SubmissionExposureWindow],
		reportedExposureWindowsQueue: [SubmissionExposureWindow]
	) {
		self.newExposureWindowsQueue = newExposureWindowsQueue
		self.reportedExposureWindowsQueue = reportedExposureWindowsQueue
	}
	
	// MARK: - Protocol Codable
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		newExposureWindowsQueue = try container.decode([SubmissionExposureWindow].self, forKey: .newExposureWindowsQueue)
		reportedExposureWindowsQueue = try container.decode([SubmissionExposureWindow].self, forKey: .reportedExposureWindowsQueue)
	}
	
	enum CodingKeys: String, CodingKey {
		case newExposureWindowsQueue
		case reportedExposureWindowsQueue
	}
	
	// MARK: - Internal
	
	// Exposure Windows to be added to the next submission
	var newExposureWindowsQueue: [SubmissionExposureWindow]
	
	// Exposure Windows which were sent in previous submissions
	var reportedExposureWindowsQueue: [SubmissionExposureWindow]
}

struct SubmissionExposureWindow: Codable, Equatable {

	// MARK: - Init

	init(exposureWindow: ExposureWindow, transmissionRiskLevel: Int, normalizedTime: Double, hash: String?, date: Date) {
		self.exposureWindow = exposureWindow
		self.transmissionRiskLevel = transmissionRiskLevel
		self.normalizedTime = normalizedTime
		self.hash = hash
		self.date = date
	}
	
	// MARK: - Protocol Equatable

	static func == (lhs: SubmissionExposureWindow, rhs: SubmissionExposureWindow) -> Bool {
		return  lhs.exposureWindow == rhs.exposureWindow &&
			lhs.transmissionRiskLevel == rhs.transmissionRiskLevel &&
			lhs.normalizedTime == rhs.normalizedTime &&
			lhs.hash == rhs.hash &&
			lhs.date == rhs.date
	}

	// MARK: - Internal

	var exposureWindow: ExposureWindow
	var transmissionRiskLevel: Int
	var normalizedTime: Double
	var hash: String?
	var date: Date
}
