////
// 🦠 Corona-Warn-App
//

#if !RELEASE

import Foundation
import UIKit

struct DMButtonCellViewModel {

	// MARK: - Internal

	let text: String
	let textColor: UIColor
	let backgroundColor: UIColor
	let action: () -> Void

}

#endif
