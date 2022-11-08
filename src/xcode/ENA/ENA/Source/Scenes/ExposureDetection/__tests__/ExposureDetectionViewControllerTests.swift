//
// 🦠 Corona-Warn-App
//

import Foundation
import XCTest
@testable import ENA

class ExposureDetectionViewControllerTests: CWATestCase {

	func testHighRiskState() {
		let vc = createVC()
		vc.loadViewIfNeeded()

		XCTAssertNotNil(vc.tableView)
	}

	// MARK: - Private

	private func createVC() -> ExposureDetectionViewController {
		let store = MockTestStore()

		let homeState = HomeState(
			store: store,
			riskProvider: MockRiskProvider(),
			exposureManagerState: ExposureManagerState(authorized: true, enabled: true, status: .active),
			enState: .enabled,
			statisticsProvider: StatisticsProvider(
				client: CachingHTTPClientMock(),
				store: store
			), localStatisticsProvider: LocalStatisticsProvider(
				client: CachingHTTPClientMock(),
				store: store
			)
		)

		return ExposureDetectionViewController(
			viewModel: ExposureDetectionViewModel(
				homeState: homeState,
				appConfigurationProvider: CachedAppConfigurationMock(),
				onSurveyTap: { },
				onInactiveButtonTap: { },
				onHygieneRulesInfoButtonTap: { },
				onRiskOfContagionInfoButtonTap: { }
			),
			store: store
		)
	}

}
