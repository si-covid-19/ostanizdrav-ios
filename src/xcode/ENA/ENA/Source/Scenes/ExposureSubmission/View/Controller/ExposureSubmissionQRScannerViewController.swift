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

import Foundation
import UIKit

enum QRScannerError: Error {
	case cameraPermissionDenied
	case other
}

extension QRScannerError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .cameraPermissionDenied:
			return AppStrings.ExposureSubmissionQRScanner.cameraPermissionDenied
		default:
			return AppStrings.ExposureSubmissionQRScanner.otherError
		}
	}
}

protocol ExposureSubmissionQRScannerDelegate: AnyObject {
	func qrScanner(_ viewController: QRScannerViewController, didScan code: String)
	func qrScanner(_ viewController: QRScannerViewController, error: QRScannerError)
}

protocol QRScannerViewController: class {
	var delegate: ExposureSubmissionQRScannerDelegate? { get set }
	func dismiss(animated: Bool, completion: (() -> Void)?)
	func present(_: UIViewController, animated: Bool, completion: (() -> Void)?)
}

final class ExposureSubmissionQRScannerNavigationController: UINavigationController {

	// MARK: - Attributes.
	
	private weak var coordinator: ExposureSubmissionCoordinating?
	private weak var exposureSubmissionService: ExposureSubmissionService?
	weak var scannerViewController: ExposureSubmissionQRScannerViewController? {
		viewControllers.first as? ExposureSubmissionQRScannerViewController
	}

	// MARK: - Initializers.
	
	init?(coder: NSCoder, coordinator: ExposureSubmissionCoordinating, exposureSubmissionService: ExposureSubmissionService) {
		self.coordinator = coordinator
		self.exposureSubmissionService = exposureSubmissionService
		super.init(coder: coder)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View lifecycle methods.
	
	override func viewDidLoad() {
		super.viewDidLoad()

		overrideUserInterfaceStyle = .dark

		navigationBar.tintColor = .enaColor(for: .textContrast)
		navigationBar.shadowImage = UIImage()
		if let image = UIImage.with(color: UIColor(white: 0, alpha: 0.5)) {
			navigationBar.setBackgroundImage(image, for: .default)
		}
	}
}

final class ExposureSubmissionQRScannerViewController: UIViewController, QRScannerViewController {
	@IBOutlet var focusView: ExposureSubmissionQRScannerFocusView!
	@IBOutlet var flashButton: UIButton!
	@IBOutlet var instructionLabel: DynamicTypeLabel!

	weak var delegate: ExposureSubmissionQRScannerDelegate?

	private var needsPreviewMaskUpdate: Bool = true

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		updateToggleFlashAccessibility()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		setNeedsPreviewMaskUpdate()
		updatePreviewMaskIfNeeded()
	}

	private func setupView() {
		navigationItem.title = AppStrings.ExposureSubmissionQRScanner.title
		instructionLabel.text = AppStrings.ExposureSubmissionQRScanner.instruction

		instructionLabel.layer.shadowColor = UIColor.enaColor(for: .textPrimary1Contrast).cgColor
		instructionLabel.layer.shadowOpacity = 1
		instructionLabel.layer.shadowRadius = 3
		instructionLabel.layer.shadowOffset = .init(width: 0, height: 0)
	}

	private func updateToggleFlashAccessibility() {
		flashButton.accessibilityLabel = AppStrings.ExposureSubmissionQRScanner.flashButtonAccessibilityLabel
		flashButton.accessibilityCustomActions?.removeAll()
		flashButton.accessibilityTraits = [.button]

		if flashButton.isSelected {
			flashButton.accessibilityValue = AppStrings.ExposureSubmissionQRScanner.flashButtonAccessibilityOnValue
			flashButton.accessibilityCustomActions = [UIAccessibilityCustomAction(name: AppStrings.ExposureSubmissionQRScanner.flashButtonAccessibilityDisableAction, target: self, selector: #selector(toggleFlash))]
		} else {
			flashButton.accessibilityValue = AppStrings.ExposureSubmissionQRScanner.flashButtonAccessibilityOffValue
			flashButton.accessibilityCustomActions = [UIAccessibilityCustomAction(name: AppStrings.ExposureSubmissionQRScanner.flashButtonAccessibilityEnableAction, target: self, selector: #selector(toggleFlash))]
		}
	}

	// Make sure to get permission to use the camera before using this method.
	private func startScanning() {
		
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	@IBAction func toggleFlash() {
		
	}

	@IBAction func close() {
		dismiss(animated: true)
	}
}

extension ExposureSubmissionQRScannerViewController {
	private func setNeedsPreviewMaskUpdate() {
		guard needsPreviewMaskUpdate else { return }
		needsPreviewMaskUpdate = true

		DispatchQueue.main.async(execute: updatePreviewMaskIfNeeded)
	}

	private func updatePreviewMaskIfNeeded() {
		guard needsPreviewMaskUpdate else { return }
		needsPreviewMaskUpdate = false

	}
}

@IBDesignable
final class ExposureSubmissionQRScannerFocusView: UIView {
	@IBInspectable var backdropOpacity: CGFloat = 0
	@IBInspectable var cornerRadius: CGFloat = 0
	@IBInspectable var borderWidth: CGFloat = 1

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()

		backgroundColor = UIColor(white: 1, alpha: 0.5)

		awakeFromNib()
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		layer.cornerRadius = cornerRadius
		layer.borderWidth = borderWidth
		layer.borderColor = tintColor.cgColor
	}
}

private extension Array {
	func first<T>(ofType _: T.Type) -> T? {
		first(where: { $0 is T }) as? T
	}
}

private extension UIImage {
	static func with(color: UIColor) -> UIImage? {
		let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

		UIGraphicsBeginImageContext(rect.size)

		if let context = UIGraphicsGetCurrentContext() {
			context.setFillColor(color.cgColor)
			context.fill(rect)
		}

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image
	}
}
