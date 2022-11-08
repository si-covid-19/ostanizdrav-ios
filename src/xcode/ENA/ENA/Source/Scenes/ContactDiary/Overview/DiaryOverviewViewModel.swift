////
// 🦠 Corona-Warn-App
//

import Foundation
import OpenCombine

class DiaryOverviewViewModel {

	// MARK: - Init

	init(
		diaryStore: DiaryStoringProviding,
		store: Store,
		eventStore: EventStoringProviding,
		homeState: HomeState? = nil
	) {
		self.diaryStore = diaryStore
		self.secureStore = store
		self.eventStore = eventStore
		self.homeState = homeState
		
		self.diaryStore.diaryDaysPublisher
			.sink { [weak self] in
				self?.days = $0
			}
			.store(in: &subscriptions)
	}

	// MARK: - Internal

	enum Section: Int, CaseIterable {
		case description
		case days
	}

	@OpenCombine.Published var days: [DiaryDay] = []
	
	var homeState: HomeState?
	var numberOfSections: Int {
		Section.allCases.count
	}
	
	func day(by indexPath: IndexPath) -> DiaryDay {
		return days[indexPath.row]
	}

	func numberOfRows(in section: Int) -> Int {
		switch Section(rawValue: section) {
		case .description:
			return 1
		case .days:
			return days.count
		case .none:
			fatalError("Invalid section")
		}
	}

	func cellModel(for indexPath: IndexPath) -> DiaryOverviewDayCellModel {
		let diaryDay = days[indexPath.row]
		let currentHistoryExposure = historyExposure(by: diaryDay.utcMidnightDate)
		let minimumDistinctEncountersWithHighRisk = minimumDistinctEncountersWithHighRiskValue(by: diaryDay.utcMidnightDate)
		let checkinsWithRisk = checkinsWithRiskFor(day: diaryDay.utcMidnightDate)

		return DiaryOverviewDayCellModel(
			diaryDay: diaryDay,
			historyExposure: currentHistoryExposure,
			minimumDistinctEncountersWithHighRisk: minimumDistinctEncountersWithHighRisk,
			checkinsWithRisk: checkinsWithRisk,
			accessibilityIdentifierIndex: indexPath.row
		)
	}

	// MARK: - Private

	private let diaryStore: DiaryStoringProviding
	private let secureStore: Store
	private let eventStore: EventStoringProviding

	private var subscriptions: [AnyCancellable] = []

	private func historyExposure(by date: Date) -> HistoryExposure {
		guard let riskLevelPerDate = secureStore.enfRiskCalculationResult?.riskLevelPerDate[date] else {
			return .none
		}
		return .encounter(riskLevelPerDate)
	}

	private func minimumDistinctEncountersWithHighRiskValue(by date: Date) -> Int {
		guard let minimumDistinctEncountersWithHighRisk = secureStore.enfRiskCalculationResult?.minimumDistinctEncountersWithHighRiskPerDate[date] else {
			return -1
		}
		return minimumDistinctEncountersWithHighRisk
	}
	
	private func checkinsWithRiskFor(day: Date) -> [CheckinWithRisk] {
		#if DEBUG
		// ui test data for launch argument LaunchArguments.risk.checkinRiskLevel
		if isUITesting {
			if let checkinRisk = LaunchArguments.risk.checkinRiskLevel.stringValue {
				let riskLevel: RiskLevel = checkinRisk == "high" ? .high : .low
                return createFakeDataForCheckin(with: riskLevel)
			}
		}
		#endif
		
		guard let result = secureStore.checkinRiskCalculationResult else {
			return []
		}

		let checkinIdsWithRisk = result.checkinIdsWithRiskPerDate.filter({
			$0.key == day
		}).flatMap { $0.value }

		var checkinsWithRisk: [CheckinWithRisk] = []
		
		checkinIdsWithRisk.forEach { checkinIdWithRisk in
			for checkin in eventStore.checkinsPublisher.value where checkinIdWithRisk.checkinId == checkin.id {
				checkinsWithRisk.append(CheckinWithRisk(checkIn: checkin, risk: checkinIdWithRisk.riskLevel))
			}
		}
		checkinsWithRisk.sort(by: { $0.checkIn.traceLocationDescription < $1.checkIn.traceLocationDescription })
		return checkinsWithRisk
	}
	
	#if DEBUG
	// needs to be injected here for the ui tests.
	private func createFakeDataForCheckin(with risk: RiskLevel) -> [CheckinWithRisk] {
		
		let fakedCheckin1 = Checkin(
			id: 0,
			traceLocationId: Data(),
			traceLocationIdHash: Data(),
			traceLocationVersion: 0,
			traceLocationType: .locationTypePermanentFoodService,
			traceLocationDescription: "Supermarkt",
			traceLocationAddress: "",
			traceLocationStartDate: nil,
			traceLocationEndDate: nil,
			traceLocationDefaultCheckInLengthInMinutes: nil,
			cryptographicSeed: Data(),
			cnPublicKey: Data(),
			checkinStartDate: Date(),
			checkinEndDate: Date(),
			checkinCompleted: true,
			createJournalEntry: false,
			checkinSubmitted: false
		)
		let highRiskCheckin1 = CheckinWithRisk(checkIn: fakedCheckin1, risk: .low)
		let fakedCheckin2 = Checkin(
			id: 0,
			traceLocationId: Data(),
			traceLocationIdHash: Data(),
			traceLocationVersion: 0,
			traceLocationType: .locationTypePermanentWorkplace,
			traceLocationDescription: "Büro",
			traceLocationAddress: "",
			traceLocationStartDate: nil,
			traceLocationEndDate: nil,
			traceLocationDefaultCheckInLengthInMinutes: nil,
			cryptographicSeed: Data(),
			cnPublicKey: Data(),
			checkinStartDate: Date(),
			checkinEndDate: Date(),
			checkinCompleted: true,
			createJournalEntry: false,
			checkinSubmitted: false
		)
		let highRiskCheckin2 = CheckinWithRisk(checkIn: fakedCheckin2, risk: risk)
		let fakedCheckin3 = Checkin(
			id: 0,
			traceLocationId: Data(),
			traceLocationIdHash: Data(),
			traceLocationVersion: 0,
			traceLocationType: .locationTypePermanentWorkplace,
			traceLocationDescription: "privates Treffen mit Freunden",
			traceLocationAddress: "",
			traceLocationStartDate: nil,
			traceLocationEndDate: nil,
			traceLocationDefaultCheckInLengthInMinutes: nil,
			cryptographicSeed: Data(),
			cnPublicKey: Data(),
			checkinStartDate: Date(),
			checkinEndDate: Date(),
			checkinCompleted: true,
			createJournalEntry: false,
			checkinSubmitted: false
		)
		let highRiskCheckin3 = CheckinWithRisk(checkIn: fakedCheckin3, risk: risk)
		let checkins = [highRiskCheckin1, highRiskCheckin2, highRiskCheckin3]
		return checkins.sorted(by: { $0.checkIn.traceLocationDescription < $1.checkIn.traceLocationDescription })
		
	}
	#endif
}
