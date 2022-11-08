//
// 🦠 Corona-Warn-App
//

import UIKit

enum MoreInfoItem: Int, CaseIterable {
	case settings
	case recycleBin
	case appInformation

	case share
	
	var title: String {
		switch self {
		case .settings:
			return AppStrings.Home.MoreInfoCard.settingsTitle
		case .recycleBin:
			return AppStrings.Home.MoreInfoCard.recycleBinTitle
		case .appInformation:
			return AppStrings.Home.MoreInfoCard.appInformationTitle
		case .share:
			return AppStrings.Home.MoreInfoCard.shareTitle
		}
	}
	
	var accessibilityIdentifier: String {
		switch self {
		case .settings:
			return AccessibilityIdentifiers.Home.MoreInfoCell.settingsLabel
		case .recycleBin:
			return AccessibilityIdentifiers.Home.MoreInfoCell.recycleBinLabel
		case .appInformation:
			return AccessibilityIdentifiers.Home.MoreInfoCell.appInformationLabel
		case .share:
			return AccessibilityIdentifiers.Home.MoreInfoCell.shareLabel
		}
	}
	
	var image: UIImage? {
		switch self {
		case .settings:
			return UIImage(named: "more_settings")
		case .recycleBin:
			return UIImage(named: "more_recycle_bin")
		case .appInformation:
			return UIImage(named: "more_info")
		case .share:
			return UIImage(named: "more_share")
		}
	}

}
