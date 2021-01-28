//
// 🦠 Corona-Warn-App
//

import Foundation
import UIKit

class ExposureSubmissionQRScannerViewModel: NSObject {

	// MARK: - Init

	init(
		onSuccess: @escaping (DeviceRegistrationKey) -> Void,
		onError: @escaping (QRScannerError, _ reactivateScanning: @escaping () -> Void) -> Void
	) {
		self.onSuccess = onSuccess
		self.onError = onError
		super.init()
		setupCaptureSession()
	}

	// MARK: - Internal

	enum TorchMode {
		case notAvailable
		case lightOn
		case ligthOff
	}

	let onError: (QRScannerError, _ reactivateScanning: @escaping () -> Void) -> Void

	var isScanningActivated = false
	/// get current torchMode by device state
	var torchMode = TorchMode.ligthOff

	func activateScanning() {
		
	}

	func deactivateScanning() {
		
	}

	func setupCaptureSession() {
		
	}

	func startCaptureSession() {
		
	}

	func stopCapturSession() {
		deactivateScanning()
	}

	/// toggle torchMode between on / off after finish call optional completion handler
	func toggleFlash(completion: (() -> Void)? = nil ) {
		
	}

	func didScan(metadataObjects: [MetadataObject]) {
		guard isScanningActivated else {
			Log.info("Scanning not stopped from previous run")
			return
		}
		deactivateScanning()

		if let code = metadataObjects.first(where: { $0 is MetadataMachineReadableCodeObject }) as? MetadataMachineReadableCodeObject, let stringValue = code.stringValue {
			guard let extractedGuid = extractGuid(from: stringValue) else {
				onError(.codeNotFound) { [weak self] in
					self?.activateScanning()
				}
				return
			}
			onSuccess(.guid(extractedGuid))
		}
	}

	/// Sanitizes the input string and extracts a guid.
	/// - the input needs to start with https://localhost/?
	/// - the input must not ne longer than 150 chars and cannot be empty
	/// - the guid contains only the following characters: a-f, A-F, 0-9,-
	/// - the guid is a well formatted string (6-8-4-4-4-12) with length 43
	///   (6 chars encode a random number, 32 chars for the uuid, 5 chars are separators)
	func extractGuid(from input: String) -> String? {
		guard !input.isEmpty,
			  input.count <= 150,
			  let urlComponents = URLComponents(string: input),
			  !urlComponents.path.contains(" "),
			  urlComponents.path.components(separatedBy: "/").count == 2,	// one / will separate into two components
			  urlComponents.scheme?.lowercased() == "https",
			  urlComponents.host?.lowercased() == "localhost",
			  let candidate = urlComponents.query,
			  candidate.count == 43,
			  let matchings = candidate.range(
				of: #"^[0-9A-Fa-f]{6}-[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$"#,
				options: .regularExpression
			  ) else {
			return nil
		}
		return matchings.isEmpty ? nil : candidate
	}

	// MARK: - Private

	private let onSuccess: (DeviceRegistrationKey) -> Void

}
