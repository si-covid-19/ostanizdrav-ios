////
// 🦠 Corona-Warn-App
//

import UIKit

// WARNING: Do not rename class name because it is used to identify already presented onboardings. But if you need to, rename it and override the id property of the DeltaOnboarding Protocol and assign the origin id (see DeltaOnboardingProtocols)
class DeltaOnboardingDataDonation: DeltaOnboarding {
	
	let version = "2.19"
	let store: Store
	
	init(store: Store) {
		self.store = store
	}
	
	func makeViewController() -> DeltaOnboardingViewControllerProtocol {
		guard let url = Bundle.main.url(forResource: "ppdd-ppa-administrative-unit-set-ua-approved", withExtension: "json") else {
			preconditionFailure("missing json file")
		}
		
		var deltaOnboardingNavigationController: DeltaOnboardingNavigationController!
		
		let dataDonationViewModel = DefaultDataDonationViewModel(
			store: store,
			presentSelectValueList: { selectValueViewModel in
				let selectValueViewController = SelectValueTableViewController(
					selectValueViewModel,
					dismiss: {
						deltaOnboardingNavigationController.dismiss(animated: true)
					})
				let selectValueNavigationController = UINavigationController(rootViewController: selectValueViewController)
				deltaOnboardingNavigationController.present(selectValueNavigationController, animated: true)
			},
			datadonationModel: DataDonationModel(
				store: store,
				jsonFileURL: url
			)
		)
				
		let containerViewController = TopBottomContainerViewController(
			topController: DataDonationViewController(viewModel: dataDonationViewModel),
			bottomController: FooterViewController(
				FooterViewModel(
					primaryButtonName: AppStrings.DataDonation.Info.buttonOK,
					secondaryButtonName: AppStrings.DataDonation.Info.buttonNOK,
					isPrimaryButtonEnabled: true,
					isSecondaryButtonEnabled: true,
					isPrimaryButtonHidden: false,
					isSecondaryButtonHidden: false
				),
				didTapPrimaryButton: {
					dataDonationViewModel.save(consentGiven: true)
					deltaOnboardingNavigationController.finished?()
				},
				didTapSecondaryButton: {
					dataDonationViewModel.save(consentGiven: false)
					deltaOnboardingNavigationController.finished?()
				}
			)
		)
		
		deltaOnboardingNavigationController = DeltaOnboardingNavigationController(rootViewController: containerViewController)
		deltaOnboardingNavigationController.navigationBar.prefersLargeTitles = true
		
		return deltaOnboardingNavigationController
	}
}
