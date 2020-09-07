// Corona-Warn-App
//
// SAP SE and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#if !RELEASE

import ExposureNotification
import UIKit

protocol DMQRCodeScanViewControllerDelegate: AnyObject {
	func debugCodeScanViewController(
		_ viewController: DMQRCodeScanViewController,
		didScan diagnosisKey: SAP_TemporaryExposureKey
	)
}

final class DMQRCodeScanViewController: UIViewController {
	// MARK: Creating a Debug Code Scan View Controller

	init(delegate: DMQRCodeScanViewControllerDelegate) {
		self.delegate = delegate
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Properties

	private let scanView = DMQRCodeScanView()
	private weak var delegate: DMQRCodeScanViewControllerDelegate?

	// MARK: UIViewController

	override func loadView() {
		view = scanView
	}

	override func viewDidLoad() {
		scanView.dataHandler = { data in
			do {
				let diagnosisKey = try SAP_TemporaryExposureKey(serializedData: data)
				self.delegate?.debugCodeScanViewController(self, didScan: diagnosisKey)
				self.dismiss(animated: true, completion: nil)
			} catch {
				logError(message: "Failed to deserialize qr to key: \(error.localizedDescription)")
			}
		}
	}

	override var prefersStatusBarHidden: Bool {
		true
	}
}

private final class DMQRCodeScanView: UIView {
	// MARK: Types

	typealias DataHandler = (Data) -> Void

	// MARK: UIView

	// MARK: Properties

	fileprivate var dataHandler: DataHandler = { _ in }

	// MARK: Creating a code scan view

	init() {

		super.init(frame: .zero)

	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

#endif
