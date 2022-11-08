//
// 🦠 Corona-Warn-App
//

import XCTest
import HealthCertificateToolkit
@testable import ENA

// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
class ExposureSubmissionTestResultViewModelTests: CWATestCase {
	
	private var store: Store!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		store = MockTestStore()
	}
	
	func testDidTapPrimaryButtonOnPositiveTestResult() {
		let getTestResultExpectation = expectation(description: "getTestResult on client is called")
		getTestResultExpectation.isInverted = true
		
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		
		let restServiceProvider = RestServiceProviderStub(loadResources: [
			LoadResource(
				result: .success(TestResultReceiveModel(testResult: TestResult.expired.rawValue, sc: nil, labId: "SomeLabId")),
				willLoadResource: { res in
					if let resource = res as? TestResultResource, !resource.locator.isFake {
						getTestResultExpectation.fulfill()
					}
				})
		])
		
		let onContinueWithSymptomsFlowButtonTapExpectation = expectation(
			description: "onContinueWithSymptomsFlowButtonTap closure is called"
		)
		
		let coronaTestService = CoronaTestService(
			client: client,
			restServiceProvider: restServiceProvider,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .positive, isSubmissionConsentGiven: true)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: {
				onContinueWithSymptomsFlowButtonTapExpectation.fulfill()
			},
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
		
		model.didTapPrimaryButton()
		
		XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
		
		waitForExpectations(timeout: .short)
	}
	
	func testDidTapPrimaryButtonOnNegativeInvalidOrExpiredTestResult() {
		let testResults: [TestResult] = [.negative, .invalid, .expired]
		for testResult in testResults {
			let getTestResultExpectation = expectation(description: "getTestResult on client is called")
			getTestResultExpectation.isInverted = true
			
			let client = ClientMock()
			let store = MockTestStore()
			let appConfiguration = CachedAppConfigurationMock()
			
			let restServiceProvider = RestServiceProviderStub(loadResources: [
				LoadResource(
					result: .success(TestResultReceiveModel(testResult: TestResult.expired.rawValue, sc: nil, labId: "SomeLabId")),
					willLoadResource: { res in
						if let resource = res as? TestResultResource, !resource.locator.isFake {
							getTestResultExpectation.fulfill()
						}
					})
			])

			
			let onContinueWithSymptomsFlowButtonTapExpectation = expectation(
				description: "onContinueWithSymptomsFlowButtonTap closure is called"
			)
			onContinueWithSymptomsFlowButtonTapExpectation.isInverted = true
			
			let coronaTestService = CoronaTestService(
				client: client,
				restServiceProvider: restServiceProvider,
				store: store,
				eventStore: MockEventStore(),
				diaryStore: MockDiaryStore(),
				appConfiguration: appConfiguration,
				healthCertificateService: HealthCertificateService(
					store: store,
					dccSignatureVerifier: DCCSignatureVerifyingStub(),
					dscListProvider: MockDSCListProvider(),
					client: client,
					appConfiguration: appConfiguration,
					cclService: FakeCCLService(),
					recycleBin: .fake()
				),
				recycleBin: .fake(),
				badgeWrapper: .fake()
			)
			coronaTestService.pcrTest = PCRTest.mock(testResult: testResult)
			
			let model = ExposureSubmissionTestResultViewModel(
				coronaTestType: .pcr,
				coronaTestService: coronaTestService,
				onSubmissionConsentCellTap: { _ in },
				onContinueWithSymptomsFlowButtonTap: {
					onContinueWithSymptomsFlowButtonTapExpectation.fulfill()
				},
				onContinueWarnOthersButtonTap: { _ in },
				onChangeToPositiveTestResult: { },
				onTestDeleted: { },
				onTestCertificateCellTap: { _, _ in }
			)
			
			XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
			
			model.didTapPrimaryButton()
			
			XCTAssertTrue(model.shouldShowDeletionConfirmationAlert)
			
			waitForExpectations(timeout: .short)
		}
	}
	
	func testDidTapPrimaryButtonOnPendingTestResult() {
		let getTestResultExpectation = expectation(description: "getTestResult on client is called")
		
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let restServiceProvider = RestServiceProviderStub(loadResources: [
			LoadResource(
				result: .success(TestResultReceiveModel(testResult: TestResult.expired.rawValue, sc: nil, labId: "SomeLabId")),
				willLoadResource: { res in
					if let resource = res as? TestResultResource, !resource.locator.isFake {
						getTestResultExpectation.fulfill()
					}
				})
		])
		
		let onContinueWithSymptomsFlowButtonTapExpectation = expectation(
			description: "onContinueWithSymptomsFlowButtonTap closure is called"
		)
		onContinueWithSymptomsFlowButtonTapExpectation.isInverted = true
		
		let coronaTestService = CoronaTestService(
			client: client,
			restServiceProvider: restServiceProvider,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(registrationToken: "asdf", testResult: .pending)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: {
				onContinueWithSymptomsFlowButtonTapExpectation.fulfill()
			},
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
		
		model.didTapPrimaryButton()
		
		XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
		
		waitForExpectations(timeout: .short)
	}
	
	func testDidTapPrimaryButtonOnPendingTestResultUpdatesButtons() {
		let getTestResultExpectation = expectation(description: "getTestResult on client is called")
		
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let restServiceProvider = RestServiceProviderStub(loadResources: [
			LoadResource(
				result: .success(TestResultReceiveModel(testResult: TestResult.negative.rawValue, sc: nil, labId: "SomeLabId")),
				willLoadResource: { res in
					if let resource = res as? TestResultResource, !resource.locator.isFake {
						// Since we currently don´t have a `didLoadResource` this will have to do 😇
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
							getTestResultExpectation.fulfill()
						})
					}
				})
		])
		
		let coronaTestService = CoronaTestService(
			client: client,
			restServiceProvider: restServiceProvider,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(registrationToken: "asdf", testResult: .pending)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		do {
			let modelBefore = try XCTUnwrap(model.footerViewModel)
			
			XCTAssertFalse(modelBefore.isPrimaryLoading)
			XCTAssertTrue(modelBefore.isPrimaryButtonEnabled)
			XCTAssertFalse(modelBefore.isPrimaryButtonHidden)
			
			XCTAssertFalse(modelBefore.isSecondaryLoading)
			XCTAssertTrue(modelBefore.isSecondaryButtonEnabled)
			XCTAssertFalse(modelBefore.isSecondaryButtonHidden)
			
			model.didTapPrimaryButton()
			
			waitForExpectations(timeout: .short)
			
			let modelAfter = try XCTUnwrap(model.footerViewModel)
			
			XCTAssertFalse(modelAfter.isPrimaryLoading)
			XCTAssertTrue(modelAfter.isPrimaryButtonEnabled)
			XCTAssertFalse(modelAfter.isPrimaryButtonHidden)
			
			XCTAssertFalse(modelAfter.isSecondaryLoading)
			XCTAssertTrue(modelAfter.isSecondaryButtonEnabled)
			XCTAssertTrue(modelAfter.isSecondaryButtonHidden)
			
		} catch {
			
			XCTFail(error.localizedDescription)
		}
	}
	
	func testDidTapPrimaryButtonOnPendingTestResultSetsError() {
		let getTestResultExpectation = expectation(description: "getTestResult on client is called")
		
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let restServiceProvider = RestServiceProviderStub(loadResources: [
			LoadResource(
				result: .failure(ServiceError<TestResultError>.invalidResponse),
				willLoadResource: { res in
					if let resource = res as? TestResultResource, !resource.locator.isFake {
						// Since we currently don´t have a `didLoadResource` this will have to do 😇
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
							getTestResultExpectation.fulfill()
						})
					}
				})
		])
		
		let coronaTestService = CoronaTestService(
			client: client,
			restServiceProvider: restServiceProvider,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(registrationToken: "asdf", testResult: .pending)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		model.didTapPrimaryButton()
		
		waitForExpectations(timeout: .short)
		
		XCTAssertEqual(model.error, .testResultError(.invalidResponse))
	}
	
	func testDidTapPrimaryButtonOnPendingTestResultUpdatesButtonsLoadingState() {
		let getTestResultExpectation = expectation(description: "getTestResult on client is called")
		
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let restServiceProvider = RestServiceProviderStub(loadResources: [
			LoadResource(
				result: .success(TestResultReceiveModel(testResult: TestResult.pending.rawValue, sc: nil, labId: "SomeLabId")),
				willLoadResource: { res in
					if let resource = res as? TestResultResource, !resource.locator.isFake {
						getTestResultExpectation.fulfill()
					}
				})
		])
		
		let coronaTestService = CoronaTestService(
			client: client,
			restServiceProvider: restServiceProvider,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(registrationToken: "asdf", testResult: .pending)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		model.didTapPrimaryButton()
		
		waitForExpectations(timeout: .short)
		do {
			let footerViewModel = try XCTUnwrap(model.footerViewModel)

			// Buttons should be in loading state when getTestResult is called on the exposure submission service
			XCTAssertFalse(footerViewModel.isPrimaryButtonEnabled)
			XCTAssertTrue(footerViewModel.isPrimaryLoading)
			XCTAssertFalse(footerViewModel.isSecondaryButtonEnabled)
		} catch {
			XCTFail(error.localizedDescription)
		}
		
		// Since we don't know when the request returns we just have to wait a little
		let getTestResultDoneExpectation = expectation(description: "getTestResult on client is done")
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
			do {
				let footerViewModel = try XCTUnwrap(model.footerViewModel)
				
				XCTAssertTrue(footerViewModel.isPrimaryButtonEnabled)
				XCTAssertFalse(footerViewModel.isPrimaryLoading)
				XCTAssertTrue(footerViewModel.isSecondaryButtonEnabled)
				getTestResultDoneExpectation.fulfill()
			} catch {
				XCTFail(error.localizedDescription)
			}
		})
		waitForExpectations(timeout: .short)

	}
	
	func testDidTapSecondaryButtonOnPendingTestResult() {
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let coronaTestService = CoronaTestService(
			client: client,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .pending)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
		XCTAssertFalse(model.shouldAttemptToDismiss)
		
		model.didTapSecondaryButton()
		
		XCTAssertTrue(model.shouldShowDeletionConfirmationAlert)
		XCTAssertFalse(model.shouldAttemptToDismiss)
	}
	
	func testDidTapSecondaryButtonOnNegativeInvalidOrExpiredTestResult() {
		let testResults: [TestResult] = [.negative, .invalid, .expired]
		for testResult in testResults {
			let client = ClientMock()
			let store = MockTestStore()
			let appConfiguration = CachedAppConfigurationMock()
			
			let coronaTestService = CoronaTestService(
				client: client,
				store: store,
				eventStore: MockEventStore(),
				diaryStore: MockDiaryStore(),
				appConfiguration: appConfiguration,
				healthCertificateService: HealthCertificateService(
					store: store,
					dccSignatureVerifier: DCCSignatureVerifyingStub(),
					dscListProvider: MockDSCListProvider(),
					client: client,
					appConfiguration: appConfiguration,
					cclService: FakeCCLService(),
					recycleBin: .fake()
				),
				recycleBin: .fake(),
				badgeWrapper: .fake()
			)
			coronaTestService.pcrTest = PCRTest.mock(testResult: testResult)
			
			let model = ExposureSubmissionTestResultViewModel(
				coronaTestType: .pcr,
				coronaTestService: coronaTestService,
				onSubmissionConsentCellTap: { _ in },
				onContinueWithSymptomsFlowButtonTap: { },
				onContinueWarnOthersButtonTap: { _ in },
				onChangeToPositiveTestResult: { },
				onTestDeleted: { },
				onTestCertificateCellTap: { _, _ in }
			)
			
			XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
			XCTAssertFalse(model.shouldAttemptToDismiss)
			
			model.didTapSecondaryButton()
			
			XCTAssertFalse(model.shouldShowDeletionConfirmationAlert)
			XCTAssertFalse(model.shouldAttemptToDismiss)
		}
	}
	
	func testDeletion() {
		let onTestDeletedCalledExpectation = expectation(description: "onTestDeleted closure is called")
		
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let coronaTestService = CoronaTestService(
			client: client,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .expired)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: {
				onTestDeletedCalledExpectation.fulfill()
			},
			onTestCertificateCellTap: { _, _ in }
		)
		
		model.deleteTest()
		
		waitForExpectations(timeout: .short)
		
		XCTAssertNil(coronaTestService.pcrTest)
	}
	
	func testNavigationFooterItemForPendingTestResult() {
		do {
			let client = ClientMock()
			let store = MockTestStore()
			let appConfiguration = CachedAppConfigurationMock()
			
			let coronaTestService = CoronaTestService(
				client: client,
				store: store,
				eventStore: MockEventStore(),
				diaryStore: MockDiaryStore(),
				appConfiguration: appConfiguration,
				healthCertificateService: HealthCertificateService(
					store: store,
					dccSignatureVerifier: DCCSignatureVerifyingStub(),
					dscListProvider: MockDSCListProvider(),
					client: client,
					appConfiguration: appConfiguration,
					cclService: FakeCCLService(),
					recycleBin: .fake()
				),
				recycleBin: .fake(),
				badgeWrapper: .fake()
			)
			coronaTestService.pcrTest = PCRTest.mock(testResult: .pending)
			
			let model = ExposureSubmissionTestResultViewModel(
				coronaTestType: .pcr,
				coronaTestService: coronaTestService,
				onSubmissionConsentCellTap: { _ in },
				onContinueWithSymptomsFlowButtonTap: { },
				onContinueWarnOthersButtonTap: { _ in },
				onChangeToPositiveTestResult: { },
				onTestDeleted: { },
				onTestCertificateCellTap: { _, _ in }
			)
			
			let footerViewModel = try XCTUnwrap(model.footerViewModel)
			
			XCTAssertFalse(footerViewModel.isPrimaryLoading)
			XCTAssertTrue(footerViewModel.isPrimaryButtonEnabled)
			XCTAssertFalse(footerViewModel.isPrimaryButtonHidden)
			
			XCTAssertFalse(footerViewModel.isSecondaryLoading)
			XCTAssertTrue(footerViewModel.isSecondaryButtonEnabled)
			XCTAssertFalse(footerViewModel.isSecondaryButtonHidden)
			
		} catch {
			
			XCTFail(error.localizedDescription)
		}
	}
	
	func testNavigationFooterItemForPositiveTestResult() {
		do {
			let client = ClientMock()
			let store = MockTestStore()
			let appConfiguration = CachedAppConfigurationMock()
			
			let coronaTestService = CoronaTestService(
				client: client,
				store: store,
				eventStore: MockEventStore(),
				diaryStore: MockDiaryStore(),
				appConfiguration: appConfiguration,
				healthCertificateService: HealthCertificateService(
					store: store,
					dccSignatureVerifier: DCCSignatureVerifyingStub(),
					dscListProvider: MockDSCListProvider(),
					client: client,
					appConfiguration: appConfiguration,
					cclService: FakeCCLService(),
					recycleBin: .fake()
				),
				recycleBin: .fake(),
				badgeWrapper: .fake()
			)
			coronaTestService.pcrTest = PCRTest.mock(testResult: .positive)
			
			let model = ExposureSubmissionTestResultViewModel(
				coronaTestType: .pcr,
				coronaTestService: coronaTestService,
				onSubmissionConsentCellTap: { _ in },
				onContinueWithSymptomsFlowButtonTap: { },
				onContinueWarnOthersButtonTap: { _ in },
				onChangeToPositiveTestResult: { },
				onTestDeleted: { },
				onTestCertificateCellTap: { _, _ in }
			)
			
			let footerViewModel = try XCTUnwrap(model.footerViewModel)
			
			XCTAssertFalse(footerViewModel.isPrimaryLoading)
			XCTAssertTrue(footerViewModel.isPrimaryButtonEnabled)
			XCTAssertFalse(footerViewModel.isPrimaryButtonHidden)
			
			XCTAssertFalse(footerViewModel.isSecondaryLoading)
			XCTAssertTrue(footerViewModel.isSecondaryButtonEnabled)
			XCTAssertFalse(footerViewModel.isSecondaryButtonHidden)
			
		} catch {
			
			XCTFail(error.localizedDescription)
		}
	}
	
	func testNavigationFooterItemForNegaitveInvalidOrExpiredTestResult() {
		do {
			let testResults: [TestResult] = [.negative, .invalid, .expired]
			for testResult in testResults {
				let client = ClientMock()
				let store = MockTestStore()
				let appConfiguration = CachedAppConfigurationMock()
				
				let coronaTestService = CoronaTestService(
					client: client,
					store: store,
					eventStore: MockEventStore(),
					diaryStore: MockDiaryStore(),
					appConfiguration: appConfiguration,
					healthCertificateService: HealthCertificateService(
						store: store,
						dccSignatureVerifier: DCCSignatureVerifyingStub(),
						dscListProvider: MockDSCListProvider(),
						client: client,
						appConfiguration: appConfiguration,
						cclService: FakeCCLService(),
						recycleBin: .fake()
					),
					recycleBin: .fake(),
					badgeWrapper: .fake()
				)
				coronaTestService.pcrTest = PCRTest.mock(testResult: testResult)
				
				let model = ExposureSubmissionTestResultViewModel(
					coronaTestType: .pcr,
					coronaTestService: coronaTestService,
					onSubmissionConsentCellTap: { _ in },
					onContinueWithSymptomsFlowButtonTap: { },
					onContinueWarnOthersButtonTap: { _ in },
					onChangeToPositiveTestResult: { },
					onTestDeleted: { },
					onTestCertificateCellTap: { _, _ in }
				)
				
				let footerViewModel = try XCTUnwrap(model.footerViewModel)
				
				XCTAssertFalse(footerViewModel.isPrimaryLoading)
				XCTAssertTrue(footerViewModel.isPrimaryButtonEnabled)
				XCTAssertFalse(footerViewModel.isPrimaryButtonHidden)
				
				XCTAssertFalse(footerViewModel.isSecondaryLoading)
				XCTAssertFalse(footerViewModel.isSecondaryButtonEnabled)
				XCTAssertTrue(footerViewModel.isSecondaryButtonHidden)
			}
			
		} catch {
			
			XCTFail(error.localizedDescription)
		}
		
	}
	
	func testDynamicTableViewModelForPositiveTestResult() {
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let coronaTestService = CoronaTestService(
			client: client,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .positive)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertEqual(model.dynamicTableViewModel.numberOfSection, 1)
		XCTAssertNotNil(model.dynamicTableViewModel.section(0).header)
		
		let section = model.dynamicTableViewModel.section(0)
		let cells = section.cells
		XCTAssertEqual(cells.count, 4)
		
		let firstItem = cells[0]
		var id = firstItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let secondItem = cells[1]
		id = secondItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let thirdItem = cells[2]
		id = thirdItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let fourthItem = cells[3]
		id = fourthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
	}
	
	func testDynamicTableViewModelForNegativeTestResult() {
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let coronaTestService = CoronaTestService(
			client: client,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .negative)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertEqual(model.dynamicTableViewModel.numberOfSection, 1)
		XCTAssertNotNil(model.dynamicTableViewModel.section(0).header)
		
		let section = model.dynamicTableViewModel.section(0)
		let cells = section.cells
		XCTAssertEqual(cells.count, 10)
		
		let firstItem = cells[0]
		var id = firstItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let secondItem = cells[1]
		id = secondItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let thirdItem = cells[2]
		id = thirdItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let fourthItem = cells[3]
		id = fourthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let fifthItem = cells[4]
		id = fifthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let sixthItem = cells[5]
		id = sixthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let seventhItem = cells[6]
		id = seventhItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let eigthItem = cells[7]
		id = eigthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "bulletPointCell")
		
		let ninthItem = cells[8]
		id = ninthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "bulletPointCell")
		
		let tenthItem = cells[9]
		id = tenthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "bulletPointCell")
	}
	
	func testDynamicTableViewModelForInvalidTestResult() {
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let coronaTestService = CoronaTestService(
			client: client,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .invalid)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertEqual(model.dynamicTableViewModel.numberOfSection, 1)
		XCTAssertNotNil(model.dynamicTableViewModel.section(0).header)
		
		let section = model.dynamicTableViewModel.section(0)
		let cells = section.cells
		XCTAssertEqual(cells.count, 4)
		
		let firstItem = cells[0]
		var id = firstItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let secondItem = cells[1]
		id = secondItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let thirdItem = cells[2]
		id = thirdItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let fourthItem = cells[3]
		id = fourthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
	}
	
	func testDynamicTableViewModelForPendingTestResult() {
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let coronaTestService = CoronaTestService(
			client: client,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .pending)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertEqual(model.dynamicTableViewModel.numberOfSection, 2)
		XCTAssertNotNil(model.dynamicTableViewModel.section(0).header)
		
		let section = model.dynamicTableViewModel.section(0)
		let cells = section.cells
		XCTAssertEqual(cells.count, 5)
		
		let firstItem = cells[0]
		var id = firstItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let secondItem = cells[1]
		id = secondItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let thirdItem = cells[2]
		id = thirdItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let section2 = model.dynamicTableViewModel.section(1)
		let iconCell = section2.cells
		XCTAssertEqual(iconCell.count, 1)
		
		let iconCellFirstItem = iconCell[0]
		let iconId = iconCellFirstItem.cellReuseIdentifier
		XCTAssertEqual(iconId.rawValue, "iconCell")
	}
	
	func testDynamicTableViewModelForExpiredTestResult() {
		let client = ClientMock()
		let store = MockTestStore()
		let appConfiguration = CachedAppConfigurationMock()
		
		let coronaTestService = CoronaTestService(
			client: client,
			store: store,
			eventStore: MockEventStore(),
			diaryStore: MockDiaryStore(),
			appConfiguration: appConfiguration,
			healthCertificateService: HealthCertificateService(
				store: store,
				dccSignatureVerifier: DCCSignatureVerifyingStub(),
				dscListProvider: MockDSCListProvider(),
				client: client,
				appConfiguration: appConfiguration,
				cclService: FakeCCLService(),
				recycleBin: .fake()
			),
			recycleBin: .fake(),
			badgeWrapper: .fake()
		)
		coronaTestService.pcrTest = PCRTest.mock(testResult: .expired)
		
		let model = ExposureSubmissionTestResultViewModel(
			coronaTestType: .pcr,
			coronaTestService: coronaTestService,
			onSubmissionConsentCellTap: { _ in },
			onContinueWithSymptomsFlowButtonTap: { },
			onContinueWarnOthersButtonTap: { _ in },
			onChangeToPositiveTestResult: { },
			onTestDeleted: { },
			onTestCertificateCellTap: { _, _ in }
		)
		
		XCTAssertEqual(model.dynamicTableViewModel.numberOfSection, 1)
		XCTAssertNotNil(model.dynamicTableViewModel.section(0).header)
		
		let section = model.dynamicTableViewModel.section(0)
		let cells = section.cells
		XCTAssertEqual(cells.count, 4)
		
		let firstItem = cells[0]
		var id = firstItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "labelCell")
		
		let secondItem = cells[1]
		id = secondItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let thirdItem = cells[2]
		id = thirdItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
		
		let fourthItem = cells[3]
		id = fourthItem.cellReuseIdentifier
		XCTAssertEqual(id.rawValue, "stepCell")
	}
	
}
