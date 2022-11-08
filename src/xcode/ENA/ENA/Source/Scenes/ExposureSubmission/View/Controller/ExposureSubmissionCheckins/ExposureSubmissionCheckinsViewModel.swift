//
// 🦠 Corona-Warn-App
//

import Foundation
import OpenCombine

class ExposureSubmissionCheckinsViewModel {
	
	// MARK: - Init
	
	init(checkins: [Checkin]) {
		self.checkinCellModels = checkins
			.filter { $0.checkinCompleted } // Only shows completed check-ins
			.map { CheckinSelectionCellModel(checkin: $0) }
	}
		
	// MARK: - Internal
	
	enum Section: Int, CaseIterable {
		case description
		case checkins
	}
	
	let title = AppStrings.ExposureSubmissionCheckins.title
	let checkinCellModels: [CheckinSelectionCellModel]
	@OpenCombine.Published private(set) var continueEnabled: Bool = false
	
	var numberOfSections: Int {
		Section.allCases.count
	}
	
	var selectedCheckins: [Checkin] {
		checkinCellModels
			.filter { $0.selected }
			.map { $0.checkin }
	}
	
	func numberOfRows(in section: Int) -> Int {
		switch Section(rawValue: section) {
		case .description:
			return 1
		case .checkins:
			return checkinCellModels.count
		case .none:
			Log.error("ExposureSubmissionCheckinsViewModel: numberOfRows asked for unknown section", log: .ui, error: nil)
			return 0
		}
	}
	
	@objc
	func selectAll() {
		checkinCellModels.forEach { $0.selected = true }
		checkContinuePossible()
	}
	
	func toggleSelection(at index: Int) {
		checkinCellModels[index].selected.toggle()
		checkContinuePossible()
	}
	
	// MARK: - Private
	
	private func checkContinuePossible() {
		continueEnabled = checkinCellModels.contains(where: { $0.selected == true })
	}
	
}
