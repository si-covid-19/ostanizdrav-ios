//
// 🦠 Corona-Warn-App
//

import Foundation
import CommonCrypto
import CryptoKit

final class CoronaWarnURLSessionDelegate: NSObject {
	private let localPublicKey: String

	// MARK: Creating a Delegate
	init(localPublicKey: String) {
		self.localPublicKey = localPublicKey
	}
}

extension CoronaWarnURLSessionDelegate: URLSessionDelegate {
	func urlSession(
		_ session: URLSession,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
	) {
		func reject() { completionHandler(.cancelAuthenticationChallenge, /* credential */ nil) }

		// `serverTrust` not nil implies that authenticationMethod == NSURLAuthenticationMethodServerTrust
		guard
			let trust = challenge.protectionSpace.serverTrust
		else {
			// Reject all requests that we do not have a public key to pin for
			reject()
			return
		}

		let localPublicKey = self.localPublicKey

		// We discard the returned status code (OSStatus) because this is also how
		// Apple is doing it in their official sample code – see [0] for more info.
		SecTrustEvaluateAsyncWithError(trust, .main) { trust, isValid, error in
			func accept() { completionHandler(.useCredential, URLCredential(trust: trust)) }

			guard isValid else {
				Log.error("Server certificate is not valid. Rejecting challenge!", log: .api)
				reject()
				return
			}

			guard error == nil else {
				Log.error("Encountered error when evaluating server trust challenge, rejecting!", log: .api)
				reject()
				return
			}

			// Our landscape has a certificate chain with three certificates.
			// We want to get the intermediate certificate, in our case the second.
			guard
				SecTrustGetCertificateCount(trust) >= 1,
				SecTrustEvaluateWithError(trust, nil),
				let remoteCertificate = SecTrustGetCertificateAtIndex(trust, 0)
			else {
				Log.error("Could not trust or get certificate, rejecting!", log: .api)
				reject()
				return
			}

			guard
				let remotePublicKey = SecCertificateCopyKey(remoteCertificate),
				let remotePublicKeyData = SecKeyCopyExternalRepresentation(remotePublicKey, nil) as Data?
			else {
				Log.error("Failed to get the remote server's public key!", log: .api)
				reject()
				return
			}

			let hashedRemotePublicKey = self.sha256ForRSA2048(data: remotePublicKeyData)
			// We simply compare the two hashed keys, and reject the challenge if they do not match
			guard hashedRemotePublicKey == localPublicKey else {
				Log.error("The server's public key did not match what we expected!", log: .api)
				reject()
				return
			}

			accept()
		}
	}
}

// [0] https://developer.apple.com/documentation/security/certificate_key_and_trust_services/trust/evaluating_a_trust_and_parsing_the_result

extension CoronaWarnURLSessionDelegate {
	var rsa2048Asn1HeaderBytes: [UInt8] { [
		0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09,
		0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
		0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
	] }

	private func sha256ForRSA2048(data: Data) -> String {
		var keyWithHeader = Data(rsa2048Asn1HeaderBytes)
		keyWithHeader.append(data)

		let hash = SHA256.hash(data: keyWithHeader)
		return Data(hash).base64EncodedString()
	}
}
