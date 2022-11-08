////
// 🦠 Corona-Warn-App
//

import Foundation
import OpenCombine

protocol CheckinRiskCalculationProtocol {
	func calculateRisk(with config: SAP_Internal_V2_ApplicationConfigurationIOS) -> CheckinRiskCalculationResult
}

final class CheckinRiskCalculation: CheckinRiskCalculationProtocol {

	struct CheckinWithRiskLevel {
		let checkin: Checkin
		let riskLevel: SAP_Internal_V2_NormalizedTimeToRiskLevelMapping.RiskLevel
		let normalizedTime: Double
	}

	// MARK: - Init

	init(
		eventStore: EventStoringProviding,
		checkinSplittingService: CheckinSplittingService,
		traceWarningMatcher: TraceWarningMatching
	) {
		self.eventStore = eventStore
		self.checkinSplittingService = checkinSplittingService
		self.traceWarningMatcher = traceWarningMatcher
	}

	// MARK: - Protocol CheckinRiskCalculationProtocol

	func calculateRisk(with config: SAP_Internal_V2_ApplicationConfigurationIOS) -> CheckinRiskCalculationResult {

		Log.info("[CheckinRiskCalculation] Start checkin risk calculation.", log: .checkin)

		let transmissionRiskValueMapping = config.presenceTracingParameters.riskCalculationParameters.transmissionRiskValueMapping
		let normalizedTimePerCheckInToRiskLevelMapping = config.presenceTracingParameters.riskCalculationParameters.normalizedTimePerCheckInToRiskLevelMapping
		let normalizedTimePerDayToRiskLevelMapping = config.presenceTracingParameters.riskCalculationParameters.normalizedTimePerDayToRiskLevelMapping
		var checkinsWithRiskLevel = [CheckinWithRiskLevel]()

		// Determine Risk Level per Check-In

		// 1. Drop Submitted CheckIns: filter out all CheckIns with Check-in Submitted set to true.
		// This is to ensure that users don't match their own submitted check-ins.

		let chickens = eventStore.checkinsPublisher.value.filter { !$0.checkinSubmitted }

		for checkin in chickens {
			// 2. Split CheckIn by Midnight UTC: the CheckIn is split as per Split CheckIn by Midnight UTC.

			let splittedCheckins = checkinSplittingService.split(checkin)

			for splittedCheckin in splittedCheckins {
				//	3. Find Relevant Matches: for each check-in after splitting, find those records in the Database Table for TraceTimeIntervalMatches that have an overlap time of > 0 as per Calculate Overlap of CheckIn and TraceTimeIntervalWarning and keep the overlap as Overlap in Minutes.

				var normalizedTimePerCheckin: Double = 0

				let matches = eventStore.traceTimeIntervalMatchesPublisher.value.filter {
					$0.checkinId == splittedCheckin.id
				}

				for match in matches {
					let overlapInMinutes = traceWarningMatcher.calculateOverlap(checkin: splittedCheckin, match: match)

					guard overlapInMinutes > 0 else {
						continue
					}

					Log.debug("[CheckinRiskCalculation] Found match with overlapInMinutes: \(overlapInMinutes)", log: .checkin)

					//	4. Determine Transmission Risk Value: for each match, the transmission risk value is determined by looking up the corresponding item of Configuration Parameter transmissionRiskValueMapping where transmissionRiskLevel matches the Transmission Risk Level of the match. The transmission risk value is the corresponding transmissionRiskValue of the item. If there is no such match, the transmission risk value is set to 0.

					let transimssionRiskValue = transmissionRiskValueMapping.first {
						$0.transmissionRiskLevel == match.transmissionRiskLevel
					}
					.map { $0.transmissionRiskValue } ?? 0

					// 	5. Determine Normalized Time per Match: the normalized time of a match is determined by multiplying the Transmission Risk Value with the Overlap in Minutes.

					Log.debug("[CheckinRiskCalculation] Calculate with transimssionRiskValue: \(transimssionRiskValue)", log: .checkin)

					let normalizedTimePerMatch = transimssionRiskValue * Double(overlapInMinutes)

					//	6. Determine Normalized Time per Check-in: the normalized time per check-in is the sum of all Normalized Time per Match of the corresponding matches.

					normalizedTimePerCheckin += normalizedTimePerMatch
				}

				//	7. Determine Risk Level: find the first item in Configuration Parameter normalizedTimePerCheckInToRiskLevelMapping where Normalized Time per Check-in of the Check-In is in the range of the item described by normalizedTimeRange (see Working with Ranges). The Risk Level is the riskLevel parameter of the matching item. If there is no matching item, no Risk Level is associated with the Check-in (i.e. the Check-in is not relevant from an epidemiological perspective).

				let riskLevel = normalizedTimePerCheckInToRiskLevelMapping.first(where: {
					let range = ENARange(from: $0.normalizedTimeRange)
					return range.contains(normalizedTimePerCheckin)
				}).map {
					$0.riskLevel
				}

				if let riskLevel = riskLevel {
					Log.debug("[CheckinRiskCalculation] Calculated riskLevel: \(riskLevel)", log: .checkin)

					let checkinWithRisk = CheckinWithRiskLevel(
						checkin: splittedCheckin,
						riskLevel: riskLevel,
						normalizedTime: normalizedTimePerCheckin
					)
					checkinsWithRiskLevel.append(checkinWithRisk)
				}
			}
		}

		//	Aggregate Results from Check-Ins

		//	1. Determine Check-in ID with Risk Level per Date: group the (split) check-ins by the date of Check-in StartDate (considering only date information, no time information) and store the ID of the (split) check-in (from Database Table for CheckIns) and the calculated Risk Level

		let checkinsRiskLevelPerDate: [Date: [CheckinWithRiskLevel]] = Dictionary(grouping: checkinsWithRiskLevel, by: {
			uctCalendar.startOfDay(for: $0.checkin.checkinStartDate)
		})

		let checkinIdsWithRiskPerDate = checkinsRiskLevelPerDate.mapValues {
			$0.map {
				CheckinIdWithRisk(
					checkinId: $0.checkin.id,
					riskLevel: RiskLevel(from: $0.riskLevel)
				)
			}
		}

		//	2. Group CheckIns by Date: group the (split) check-ins by the date of Check-in StartDate (considering only date information, no time information).
		//	3. Determine Normalized Time per Date: calculate the sum of the Normalized Time per Check-in of all (split) Check-ins of the same Date
		//	4. Determine Risk Level per Date: find the first item in Configuration Parameter normalizedTimePerDayToRiskLevelMapping where Normalized Time per Date is in the range of the item described by normalizedTimeRange (see Working with Ranges). The Risk Level is the riskLevel parameter of the matching item. If there is no matching item, no Risk Level is associated with the date (i.e. the (split) Check-ins that accumulated in the normalized time are not relevant from an epidemiological perspective).

		let normalizedTimePerDates = checkinsRiskLevelPerDate.mapValues {
			$0.reduce(0) { $0 + $1.normalizedTime }
		}

		let riskLevelPerDate: [Date: RiskLevel] = normalizedTimePerDates.compactMapValues { value in
			let riskLevel = normalizedTimePerDayToRiskLevelMapping.first(where: {
				let range = ENARange(from: $0.normalizedTimeRange)
				return range.contains(value)
			}).map {
				$0.riskLevel
			}

			if let riskLevel = riskLevel {
				return RiskLevel(from: riskLevel)
			} else {
				return nil
			}
		}

		Log.info("[CheckinRiskCalculation] Finished checkin risk calculation", log: .checkin)

		Log.debug("[CheckinRiskCalculation] Calculated risk per date: \(riskLevelPerDate)", log: .checkin)

		return CheckinRiskCalculationResult(
			calculationDate: Date(),
			checkinIdsWithRiskPerDate: checkinIdsWithRiskPerDate,
			riskLevelPerDate: riskLevelPerDate
		)
	}

	// MARK: - Private

	private let eventStore: EventStoringProviding
	private let checkinSplittingService: CheckinSplittingService
	private let traceWarningMatcher: TraceWarningMatching
	private var subscriptions = Set<AnyCancellable>()

	private lazy var uctCalendar: Calendar = {
		Calendar.utc()
	}()
}
